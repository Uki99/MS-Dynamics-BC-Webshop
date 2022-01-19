/// <summary>
/// TableExtension UC Web Shop Item Ext (ID 50125) extends Record Item.
/// </summary>
tableextension 50125 "UC Web Shop Item Ext" extends Item
{
    fields
    {
        field(50125; "UC Intern"; Enum "UC Intern")
        {
            DataClassification = CustomerContent;
            Caption = 'Intern';
        }
        field(50126; "UC Comment"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Comment';
        }
    }
}