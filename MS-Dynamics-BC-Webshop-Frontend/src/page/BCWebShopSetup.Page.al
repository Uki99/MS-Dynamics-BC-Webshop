/// <summary>
/// Page BCWeb Shop Setup (ID 50100).
/// </summary>
page 50100 "BCWeb Shop Setup"
{
    Caption = 'Web Shop Setup';
    PageType = Card;
    SourceTable = "BCWeb Shop Setup";
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