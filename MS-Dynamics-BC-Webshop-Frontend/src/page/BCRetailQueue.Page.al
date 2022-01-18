/// <summary>
/// Page BCRetail Queue (ID 50105).
/// </summary>
page 50108 "BCRetail Queue"
{

    Caption = 'Retail Queue';
    PageType = CardPart;
    SourceTable = "BCWeb Shop Cue";

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
                    DrillDownPageID = "BCWeb Shop";
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