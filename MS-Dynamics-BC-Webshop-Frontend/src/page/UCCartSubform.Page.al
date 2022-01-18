/// <summary>
/// Page UC Cart Subform (ID 64904).
/// </summary>
page 64904 "UC Cart Subform"
{
    Caption = 'Cart Subform';
    PageType = ListPart;
    SourceTable = "UC Cart Entry";
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
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Name field.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                    Editable = true;
                }
            }
            group(Total)
            {
                Caption = 'Total';

                field("Total Amount"; Rec.CalcTotalAmount())
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the value of the Amount field';
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
                Caption = 'Checkout';
                ToolTip = 'Proceed to checkout';
                Image = ExpandAll;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = Page "UC Checkout";
            }
            action(ClearCart)
            {
                ApplicationArea = All;
                Caption = 'Clear Cart';
                ToolTip = 'Deletes all content from this cart.';
                Image = CreateMovement;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ClearUserCart();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Username, UCCurrentUser.GetUser());
    end;

    local procedure ClearUserCart()
    begin
        if Dialog.Confirm('Do you want to clear the cart?', false) then begin
            Rec.SetRange(Username, UCCurrentUser.GetUser());
            Rec.DeleteAll(true);
        end;
    end;

    var
        UCCurrentUser: Codeunit "UC Current User";
}