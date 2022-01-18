/// <summary>
/// Page BCCheckout (ID 50103).
/// </summary>
page 50103 "BCCheckout"
{
    UsageCategory = None;
    PageType = List;
    SourceTable = "BCCart Entry";
    Caption = 'Checkout';
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item Name"; Rec."Item Name")
                {
                    ToolTip = 'Specifies the value of the Item Name field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            fixed(Total)
            {
                group(TotalCost)
                {
                    Caption = 'Total';
                    field("Total Cost"; Rec.CalcTotalAmount())
                    {
                        ToolTip = 'Specifies the value of the Total Cost field';
                        ApplicationArea = All;
                        Caption = 'Total Cost';
                    }
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Buy)
            {
                ApplicationArea = All;
                ToolTip = 'Buy everything from the cart.';
                Caption = 'Buy';
                Image = MoveDown;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    BCSplitPayment: Record BCSplitPayment;
                    BCPostingHandler: Codeunit BCPostingHandler;
                    BCJSONUtility: Codeunit BCJSONUtility;
                    BCWebServiceOData: Codeunit BCWebServiceOData;
                    BCCurrentUser: Codeunit BCCurrentUser;
                    SalesDocumentJsonObject: JsonObject;
                    SalesLineJsonObject: JsonObject;
                    PaymentMethodsLbl: Label 'Cash,Card,Split Payment';
                    SelectedPaymentMethod: Integer;
                    OrderLinePath: Text;
                    SalesLineNo: Integer;
                    SalesHeaderNo: Text;
                    OrderJSONText: Text;
                begin
                    if Rec.Count() <= 0 then
                        Error('You did not select anything for purchase.');

                    // Create Sales Header for currently logged in user
                    SalesDocumentJsonObject := BCWebServiceOData.CallODataService('salesOrders', BCJSONUtility.CreateSalesOrder(BCCurrentUser.GetUserCustomerNo()));
                    // Get SalesLines path for newely crafted Sales Header
                    OrderLinePath := BCWebServiceOData.GetSalesOrderLinePath(BCJSONUtility.GetFieldValue(SalesDocumentJsonObject, 'id').AsText());

                    // Add sales lines
                    SalesLineNo := 10000;
                    repeat
                        SalesLineJsonObject := BCWebServiceOData.CallODataService(OrderLinePath, BCJSONUtility.CreateSalesLine(SalesLineNo, Rec."Item No.", Rec.Quantity, Rec."Unit Price"));
                        SalesLineNo += 10000;
                    until Rec.Next() = 0;

                    // Document number for posting
                    SalesHeaderNo := BCJSONUtility.GetFieldValue(SalesDocumentJsonObject, 'number').AsCode();

                    SelectedPaymentMethod := Dialog.StrMenu(PaymentMethodsLbl, 1, 'Choose your payment method:');

                    case SelectedPaymentMethod of
                        1:
                            OrderJSONText := BCJSONUtility.CreateOrderJSONText(SalesHeaderNo, 'CASH', '', Format(Rec.CalcTotalAmount()));
                        2:
                            OrderJSONText := BCJSONUtility.CreateOrderJSONText(SalesHeaderNo, 'CARD', Format(Rec.CalcTotalAmount()), '');
                        3:
                            begin
                                Page.RunModal(Page::BCSplitPaymentMenu);
                                if BCSplitPayment.FindFirst() then
                                    if BCSplitPayment.PaymentAmountCard + BCSplitPayment.PaymentAmountCash = Rec.CalcTotalAmount() then
                                        OrderJSONText := BCJSONUtility.CreateOrderJSONText(SalesHeaderNo, 'SPLIT', Format(BCSplitPayment.PaymentAmountCard), Format(BCSplitPayment.PaymentAmountCash))
                                    else
                                        Error('Invalid split payment amount.');
                            end;
                    end;

                    BCPostingHandler.SendToPost(OrderJSONText);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        BCCurrentUser: Codeunit BCCurrentUser;
    begin
        Rec.SetRange(Username, BCCurrentUser.GetUser());
    end;

    trigger OnModifyRecord(): Boolean
    var
        BCItemUC: Record "BCItem UC";
    begin
        if Rec.Quantity <= 0 then
            Error('You can''t set the quantity of the item to zero (0) or less.');

        BCItemUC.Get(Rec."Item No.");

        if BCItemUC.Inventory < Rec.Quantity then
            Error('Not enough of items on stock.');
    end;
}