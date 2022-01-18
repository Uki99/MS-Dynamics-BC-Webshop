/// <summary>
/// Table BCSplitPayment (ID 50103).
/// </summary>
table 50103 "BCSplitPayment"
{
    DataClassification = CustomerContent;
    Caption = 'Split Payment';

    fields
    {
        field(1; "No."; Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'No.';
        }
        field(2; PaymentAmountCard; Decimal)
        {
            DataClassification = SystemMetadata;
            Caption = 'No.';
        }
        field(3; PaymentAmountCash; Decimal)
        {
            DataClassification = SystemMetadata;
            Caption = 'No.';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}