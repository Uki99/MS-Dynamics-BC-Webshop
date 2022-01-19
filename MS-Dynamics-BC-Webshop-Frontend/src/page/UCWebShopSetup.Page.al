/// <summary>
/// Page UC Web Shop Setup (ID 64900).
/// </summary>
page 64900 "UC Web Shop Setup"
{
    Caption = 'Web Shop Setup';
    PageType = Card;
    SourceTable = "UC Web Shop Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(BackendWebService)
            {
                Caption = 'Backend Web Service';

                field("Backend Web Service URL"; Rec."Backend Web Service URL")
                {
                    ToolTip = 'Specifies the value of the Backend Web Service URL field.';
                    ApplicationArea = All;
                    MultiLine = true;
                }

                group(BackendWebServiceLogin)
                {
                    Caption = 'Credentials';

                    field("Backend Username"; Rec."Backend Username")
                    {
                        Caption = 'Username';
                        ToolTip = 'Specifies the value of the Backend Username field.';
                        ApplicationArea = All;
                    }
                    field("Backend Password"; Rec."Backend Password")
                    {
                        Caption = 'Password';
                        ToolTip = 'Specifies the value of the Backend Password field.';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec."Backend Web Service URL" := 'https://<servername>/<service>/api/1.0';
            Rec.Insert();
        end;
    end;
}