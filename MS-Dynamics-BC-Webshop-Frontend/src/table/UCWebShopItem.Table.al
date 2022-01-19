/// <summary>
/// Table UC Web Shop Item (ID 64901).
/// </summary>
table 64901 "UC Web Shop Item"
{
    DataClassification = CustomerContent;
    Caption = 'Items UC';
    LookupPageId = "UC Web Shop";
    DrillDownPageId = "UC Web Shop";

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
        field(4; Inventory; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Inventory';
        }
        field(5; Intern; Enum "UC Intern")
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
        fieldgroup(DropDown; Name, "Unit Price", Inventory) { }
        fieldgroup(Brick; Name, "Unit Price", Picture) { }
    }
}