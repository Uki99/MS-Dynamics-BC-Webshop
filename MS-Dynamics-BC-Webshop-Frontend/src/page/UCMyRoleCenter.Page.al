/// <summary>
/// Page UC My Role Center (ID 64908).
/// </summary>
page 64908 "UC My Role Center"
{
    PageType = RoleCenter;
    Caption = 'Car Part Role Center';

    layout
    {
        area(RoleCenter)
        {
            part(Headline; "UC Web Shop Headline")
            {
                ApplicationArea = All;
            }
            part(Info; "UC Retail Queue")
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
                RunObject = Page "UC Login Page";
                ToolTip = 'Executes the LoginPage action.';
            }
            action(Setup)
            {
                ApplicationArea = All;
                Caption = 'Web Shop Setup';
                RunObject = Page "UC Web Shop Setup";
                ToolTip = 'Executes the Setup action.';
            }
            action(WebShop)
            {
                ApplicationArea = All;
                Caption = 'Web Shop';
                RunObject = Page "UC Web Shop";
                ToolTip = 'Executes the WebShop action.';
            }
        }
    }
}