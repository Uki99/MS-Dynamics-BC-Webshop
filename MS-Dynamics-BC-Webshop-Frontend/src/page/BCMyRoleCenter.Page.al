/// <summary>
/// Page BCMyRoleCenter (ID 50106).
/// </summary>
page 50106 "BCMyRoleCenter"
{
    PageType = RoleCenter;
    Caption = 'Car Part Role Center';

    layout
    {
        area(RoleCenter)
        {
            part(Headline; "BCWebShop Headline")
            {
                ApplicationArea = All;
            }
            part(Info; "BCRetail Queue")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action(LoginPage)
            {
                ApplicationArea = All;
                Caption = 'Log in / Register';
                RunObject = Page BCLoginPage;
                ToolTip = 'Executes the LoginPage action.';
            }
            action(Setup)
            {
                ApplicationArea = All;
                Caption = 'Web Shop Setup';
                RunObject = Page "BCWeb Shop Setup";
                ToolTip = 'Executes the Setup action.';
            }
            action(WebShop)
            {
                ApplicationArea = All;
                Caption = 'Web Shop';
                RunObject = Page "BCWeb Shop";
                ToolTip = 'Executes the WebShop action.';
            }
        }
    }
}