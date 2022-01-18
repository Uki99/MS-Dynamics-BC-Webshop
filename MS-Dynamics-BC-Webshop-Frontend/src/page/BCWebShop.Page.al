/// <summary>
/// Page BCWeb Shop (ID 50101).
/// </summary>
page 50101 "BCWeb Shop"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "BCItem UC";
    Caption = 'Web Shop';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Caption = 'Item';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inventory field.';
                }
                field(Intern; Rec.Intern)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Intern field.';
                }
                field(Specification; Rec.Specification)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Specification field.';
                }
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Picture field.';
                }
            }
        }
        area(Factboxes)
        {
            part(Cart; "BCCart Subform")
            {
                ApplicationArea = All;
                Caption = 'Cart';
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Add To Cart")
            {
                ApplicationArea = All;
                Caption = 'Add To Cart';
                ToolTip = 'Adds the selected item to cart.';
                Image = Apply;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ShortcutKey = 'Return';

                trigger OnAction()
                var
                    CartEntry: Record "BCCart Entry";
                    BCCurrentUser: Codeunit BCCurrentUser;
                begin
                    CartEntry.SetRange(Username, BCCurrentUser.GetUser());
                    CartEntry.SetRange("Item No.", Rec."No.");

                    if CartEntry.IsEmpty() then begin
                        CartEntry.Init();
                        CartEntry."Entry No." := 0;
                        CartEntry.Validate("Item No.", Rec."No.");
                        CartEntry.Validate(Quantity, 1);
                        CartEntry.Insert(true);
                    end
                    else begin
                        CartEntry.FindFirst();
                        CartEntry.Validate(Quantity, CartEntry.Quantity + 1);
                        CartEntry.Modify(true);
                    end;
                end;
            }
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
                var
                    BCCartEntry: Record "BCCart Entry";
                    BCCurrentUser: Codeunit BCCurrentUser;
                begin
                    if Dialog.Confirm('Do you want to clear the cart?', false) then begin
                        BCCartEntry.SetRange(Username, BCCurrentUser.GetUser());
                        BCCartEntry.DeleteAll(true);
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        BCWebShopLoad: Codeunit BCWebShopLoad;
        BCCurrentUser: Codeunit BCCurrentUser;
    begin
        // Delete everything from the table and use codeunit to send GET request to backend to retrieve product data.
        if BCCurrentUser.GetUser() = '' then begin
            Message('You''re not logged in. Please login to proceed.');

            if (Page.RunModal(Page::BCLoginPage) = Action::LookupOK) OR (Page.RunModal(Page::BCLoginPage) = Action::LookupCancel) then begin
                Rec.DeleteAll(true);
                BCWebShopLoad.Run();
            end
        end
        else begin
            Rec.DeleteAll(true);
            BCWebShopLoad.Run();
        end;
    end;
}