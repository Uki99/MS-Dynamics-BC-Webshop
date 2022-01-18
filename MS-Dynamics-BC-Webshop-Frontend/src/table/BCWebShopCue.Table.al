/// <summary>
/// Table Retail Cue (ID 50102).
/// </summary>
table 50104 "BCWeb Shop Cue"
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
            CalcFormula = count("BCItem UC");
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