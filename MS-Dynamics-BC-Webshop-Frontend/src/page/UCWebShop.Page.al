/// <summary>
/// Page UC Web Shop (ID 64902).
/// </summary>
page 64902 "UC Web Shop"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "UC Web Shop Item";
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
            part(Cart; "UC Cart Subform")
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
                Caption = 'Add To Cart';
                ApplicationArea = All;
                ToolTip = 'Adds the selected item to cart.';
                Image = Apply;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ShortcutKey = 'Return';

                trigger OnAction()
                begin
                    AddItemToCart();
                end;
            }
            action(ClearCart)
            {
                Caption = 'Clear Cart';
                ApplicationArea = All;
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
            action(Checkout)
            {
                Caption = 'Checkout';
                ApplicationArea = All;
                ToolTip = 'Proceed to checkout';
                Image = ExpandAll;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = Page "UC Checkout";
            }
        }
    }

    var
        UCCurrentUser: Codeunit "UC Current User";

    trigger OnOpenPage()
    var
        UCWebShopLoad: Codeunit "UC Web Shop Load";
    begin
        if UCCurrentUser.GetUser() = '' then begin
            Message('You''re not logged in. Please login to proceed.');

            if (Page.RunModal(Page::"UC Login Page") = Action::LookupOK) or (Page.RunModal(Page::"UC Login Page") = Action::LookupCancel) then begin
                Rec.DeleteAll(true);
                UCWebShopLoad.Run();
            end
        end
        else begin
            Rec.DeleteAll(true);
            UCWebShopLoad.Run();
        end;
    end;

    local procedure AddItemToCart()
    var
        UCCartEntry: Record "UC Cart Entry";
    begin
        UCCartEntry.SetRange(Username, UCCurrentUser.GetUser());
        UCCartEntry.SetRange("Item No.", Rec."No.");

        if UCCartEntry.IsEmpty() then begin
            UCCartEntry.Init();
            UCCartEntry."Entry No." := 0;
            UCCartEntry.Validate("Item No.", Rec."No.");
            UCCartEntry.Validate(Quantity, 1);
            UCCartEntry.Insert(true);
        end
        else begin
            UCCartEntry.FindFirst();
            UCCartEntry.Validate(Quantity, UCCartEntry.Quantity + 1);
            UCCartEntry.Modify(true);
        end;
    end;

    local procedure ClearUserCart()
    var
        UCCartEntry: Record "UC Cart Entry";
    begin
        if Dialog.Confirm('Do you want to clear the cart?', false) then begin
            UCCartEntry.SetRange(Username, UCCurrentUser.GetUser());
            UCCartEntry.DeleteAll(true);
        end;
    end;
}