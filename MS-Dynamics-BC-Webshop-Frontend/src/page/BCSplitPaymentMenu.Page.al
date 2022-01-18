/// <summary>
/// Page BCSplitPaymentMenu (ID 50105).
/// </summary>
page 50105 "BCSplitPaymentMenu"
{
    Caption = 'Split Payment Menu';
    SourceTable = BCSplitPayment;
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

                field(PaymentAmountCard; Rec.PaymentAmountCard)
                {
                    ApplicationArea = All;
                    Caption = 'Payment Amount Card';
                    ToolTip = 'Specifies the value of the Payment Amount Card field.';

                    trigger OnValidate()
                    begin
                        if ((TotalAmount - Rec.PaymentAmountCash) <> Rec.PaymentAmountCard) AND (Rec.PaymentAmountCard < TotalAmount) then
                            Rec.PaymentAmountCash := TotalAmount - Rec.PaymentAmountCard
                        else begin
                            Rec.PaymentAmountCard := TotalAmount;
                            Rec.PaymentAmountCash := 0;
                        end;
                    end;
                }
                field(PaymentAmountCash; Rec.PaymentAmountCash)
                {
                    ApplicationArea = All;
                    Caption = 'Payment Amount Cash';
                    ToolTip = 'Specifies the value of the Payment Amount Cash field.';

                    trigger OnValidate()
                    begin
                        if ((TotalAmount - Rec.PaymentAmountCard) <> Rec.PaymentAmountCash) AND (Rec.PaymentAmountCash < TotalAmount) then
                            Rec.PaymentAmountCard := TotalAmount - Rec.PaymentAmountCash
                        else begin
                            Rec.PaymentAmountCash := TotalAmount;
                            Rec.PaymentAmountCard := 0;
                        end;
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
        BCCartEntry: Record "BCCart Entry";
        BCCurrentUser: Codeunit BCCurrentUser;
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        BCCartEntry.SetRange(Username, BCCurrentUser.GetUser());
        TotalAmount := BCCartEntry.CalcTotalAmount();
    end;

    var
        TotalAmount: Decimal;
}