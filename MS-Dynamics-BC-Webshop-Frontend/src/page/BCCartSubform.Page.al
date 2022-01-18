/// <summary>
/// Page BCCart Subform (ID 50102).
/// </summary>
page 50102 "BCCart Subform"
{
    Caption = 'Cart Subform';
    PageType = ListPart;
    SourceTable = "BCCart Entry";
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item Name"; Rec."Item Name")
                {
                    ToolTip = 'Specifies the value of the Item Name field.';
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field.';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;
                    Editable = true;
                }
            }
            group(Total)
            {
                Caption = 'Total';

                field("Total Amount"; Rec.CalcTotalAmount())
                {
                    ToolTip = 'Specifies the value of the Amount field';
                    ApplicationArea = All;
                    Caption = 'Amount';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Checkout)
            {
                ApplicationArea = All;
                ToolTip = 'Proceed to checkout';
                Caption = 'Checkout';
                Image = ExpandAll;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = Page BCCheckout;
            }
            action(ClearCart)
            {
                ApplicationArea = All;
                ToolTip = 'Deletes all content from this cart.';
                Caption = 'Clear Cart';
                Image = CreateMovement;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Dialog.Confirm('Do you want to clear the cart?', false) then begin
                        Rec.SetRange(Username, BCCurrentUser.GetUser());
                        Rec.DeleteAll(true);
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Username, BCCurrentUser.GetUser());
    end;

    var
        BCCurrentUser: codeunit BCCurrentUser;
}