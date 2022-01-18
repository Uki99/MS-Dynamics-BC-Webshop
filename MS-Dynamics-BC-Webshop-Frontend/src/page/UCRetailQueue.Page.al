/// <summary>
/// Page UC Retail Queue (ID 64907).
/// </summary>
page 64907 "UC Retail Queue"
{

    Caption = 'Retail Queue';
    PageType = CardPart;
    SourceTable = "UC Web Shop Cue";

    layout
    {
        area(content)
        {
            cuegroup(Transport)
            {
                Caption = 'No. of unique items';

                field("No. of Items"; Rec."No. of Items")
                {
                    ToolTip = 'Specifies the value of the No. of Items field.';
                    ApplicationArea = All;
                    DrillDownPageID = "UC Web Shop";
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}