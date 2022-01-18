/// <summary>
/// Page UC Checkout (ID 64903).
/// </summary>
page 64903 "UC Checkout"
{
    UsageCategory = None;
    PageType = List;
    SourceTable = "UC Cart Entry";
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
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Name field.';
                    Editable = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
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
                        ApplicationArea = All;
                        Caption = 'Total Cost';
                        ToolTip = 'Specifies the value of the Total Cost field';
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
                begin
                    MakeTransaction();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        UCCurrentUser: Codeunit "UC Current User";
    begin
        Rec.SetRange(Username, UCCurrentUser.GetUser());
    end;

    trigger OnModifyRecord(): Boolean
    var
        UCWebShopItem: Record "UC Web Shop Item";
    begin
        if Rec.Quantity <= 0 then
            Error('You can''t set the quantity of the item to zero (0) or less.');

        UCWebShopItem.Get(Rec."Item No.");

        if UCWebShopItem.Inventory < Rec.Quantity then
            Error('Not enough of items on stock.');
    end;

    local procedure MakeTransaction()
    var
        UCSplitPayment: Record "UC Split Payment";
        UCPostingHandler: Codeunit "UC Posting Handler";
        UCJSONUtility: Codeunit "UC JSON Utility";
        UCWebServiceOData: Codeunit "UC Web Service OData";
        UCCurrentUser: Codeunit "UC Current User";
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
        SalesDocumentJsonObject := UCWebServiceOData.CallODataService('salesOrders', UCJSONUtility.CreateSalesOrder(UCCurrentUser.GetUserCustomerNo()));

        // Get SalesLines path for newely crafted Sales Header
        OrderLinePath := UCWebServiceOData.GetSalesOrderLinePath(UCJSONUtility.GetFieldValue(SalesDocumentJsonObject, 'id').AsText());

        // Add sales lines
        SalesLineNo := 10000;
        repeat
            SalesLineJsonObject := UCWebServiceOData.CallODataService(OrderLinePath, UCJSONUtility.CreateSalesLine(SalesLineNo, Rec."Item No.", Rec.Quantity, Rec."Unit Price"));
            SalesLineNo += 10000;
        until Rec.Next() = 0;

        // Document number for posting
        SalesHeaderNo := UCJSONUtility.GetFieldValue(SalesDocumentJsonObject, 'number').AsCode();

        SelectedPaymentMethod := Dialog.StrMenu(PaymentMethodsLbl, 1, 'Choose your payment method:');

        case SelectedPaymentMethod of
            1:
                OrderJSONText := UCJSONUtility.CreateOrderJSONText(SalesHeaderNo, 'CASH', '', Format(Rec.CalcTotalAmount()));
            2:
                OrderJSONText := UCJSONUtility.CreateOrderJSONText(SalesHeaderNo, 'CARD', Format(Rec.CalcTotalAmount()), '');
            3:
                begin
                    Page.RunModal(Page::"UC Split Payment Menu");
                    if UCSplitPayment.FindFirst() then
                        if UCSplitPayment."Payment Amount Card" + UCSplitPayment."Payment Amount Cash" = Rec.CalcTotalAmount() then
                            OrderJSONText := UCJSONUtility.CreateOrderJSONText(SalesHeaderNo, 'SPLIT', Format(UCSplitPayment."Payment Amount Card"), Format(UCSplitPayment."Payment Amount Cash"))
                        else
                            Error('Invalid split payment amount.');
                end;
        end;

        UCPostingHandler.SendToPost(OrderJSONText);
    end;
}