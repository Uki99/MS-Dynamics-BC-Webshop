table 64903 "UC Web Shop Cue"
{
    Caption = 'Web Shop Cue';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; "No. of Items"; Integer)
        {
            Caption = 'All Items';
            FieldClass = FlowField;
            CalcFormula = count("UC Web Shop Item");
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}