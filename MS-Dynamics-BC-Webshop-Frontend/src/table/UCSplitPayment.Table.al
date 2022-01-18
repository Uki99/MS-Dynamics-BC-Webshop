/// <summary>
/// Table UC Split Payment (ID 64904).
/// </summary>
table 64904 "UC Split Payment"
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
        field(2; "Payment Amount Card"; Decimal)
        {
            DataClassification = SystemMetadata;
            Caption = 'Payment Amount Card';
        }
        field(3; "Payment Amount Cash"; Decimal)
        {
            DataClassification = SystemMetadata;
            Caption = 'Payment Amount Cash';
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