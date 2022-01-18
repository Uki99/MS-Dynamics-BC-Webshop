/// <summary>
/// Table BCItem UC (ID 50101).
/// </summary>
table 50101 "BCItem UC"
{
    DataClassification = CustomerContent;
    Caption = 'Items UC';
    LookupPageId = "BCWeb Shop";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(2; Name; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
        field(3; "Unit Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Price';
        }
        field(4; Inventory; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Inventory';
        }
        field(5; Intern; Enum BCIntern)
        {
            DataClassification = CustomerContent;
            Caption = 'Intern';
        }
        field(6; Specification; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Specification';
        }
        field(7; Picture; Media)
        {
            DataClassification = CustomerContent;
            Caption = 'Picture';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Brick; Name, "Unit Price", Picture) { }
    }
}