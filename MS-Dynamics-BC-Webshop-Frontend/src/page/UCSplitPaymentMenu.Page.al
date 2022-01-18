/// <summary>
/// Page UC Split Payment Menu (ID 64906).
/// </summary>
page 64906 "UC Split Payment Menu"
{
    Caption = 'Split Payment Menu';
    SourceTable = "UC Split Payment";
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(PaymentAmount)
            {
                Caption = 'Payment Amount';

                field("Payment Amount Card"; Rec."Payment Amount Card")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Amount Card';
                    ToolTip = 'Specifies the value of the Payment Amount Card field.';

                    trigger OnValidate()
                    begin
                        ValidateAmountCard();
                    end;
                }
                field(PaymentAmountCash; Rec."Payment Amount Cash")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Amount Cash';
                    ToolTip = 'Specifies the value of the Payment Amount Cash field.';

                    trigger OnValidate()
                    begin
                        ValidateAmountCash();
                    end;
                }
            }
            group(Total)
            {
                Caption = 'Total';

                field(TotalAmount; TotalAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Total Amount';
                    ToolTip = 'Specifies the value of the PTotal Amount field.';
                    Editable = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        UCCartEntry: Record "UC Cart Entry";
        UCCurrentUser: Codeunit "UC Current User";
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        UCCartEntry.SetRange(Username, UCCurrentUser.GetUser());
        TotalAmount := UCCartEntry.CalcTotalAmount();
    end;

    local procedure ValidateAmountCard()
    begin
        if ((TotalAmount - Rec."Payment Amount Cash") <> Rec."Payment Amount Card") and (Rec."Payment Amount Card" < TotalAmount) then
            Rec."Payment Amount Cash" := TotalAmount - Rec."Payment Amount Card"
        else begin
            Rec."Payment Amount Card" := TotalAmount;
            Rec."Payment Amount Cash" := 0;
        end;
    end;

    local procedure ValidateAmountCash()
    begin
        if ((TotalAmount - Rec."Payment Amount Card") <> Rec."Payment Amount Cash") AND (Rec."Payment Amount Cash" < TotalAmount) then
            Rec."Payment Amount Card" := TotalAmount - Rec."Payment Amount Cash"
        else begin
            Rec."Payment Amount Cash" := TotalAmount;
            Rec."Payment Amount Card" := 0;
        end;
    end;

    var
        TotalAmount: Decimal;
}