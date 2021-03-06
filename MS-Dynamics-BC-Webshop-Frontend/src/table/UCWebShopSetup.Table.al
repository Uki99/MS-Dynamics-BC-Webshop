/// <summary>
/// Table UC Web Shop Setup (ID 64902).
/// </summary>
table 64902 "UC Web Shop Setup"
{
    Caption = 'Web Shop Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; "Backend Web Service URL"; Text[250])
        {
            Caption = 'Backend Web Service URL';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
        }
        field(3; "Backend Username"; Text[100])
        {
            Caption = 'Backend Username';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(4; "Backend Password"; Text[100])
        {
            Caption = 'Backend Password';
            DataClassification = EndUserIdentifiableInformation;
            ExtendedDatatype = Masked;
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