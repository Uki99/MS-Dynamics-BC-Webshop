/// <summary>
/// Page UC Web Shop Headline (ID 64905).
/// </summary>
page 64905 "UC Web Shop Headline"
{

    Caption = 'WebShop Headline';
    PageType = HeadlinePart;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {

            field(GreetingText; 'Welcome to Ugljesa''s Car Part WebShop')
            {
                ApplicationArea = All;
                Caption = 'Greeting headline 1';
                Editable = false;
            }
            field(GreetingText2; LoginMessage)
            {
                ApplicationArea = All;
                Caption = 'Greeting headline 2';
                Editable = false;
            }
            field(GreetingText3; 'Did you know you can split your payment to card and cash in our shop?')
            {
                ApplicationArea = All;
                Caption = 'Greeting headline 3';
                Editable = false;
            }
        }
    }

    trigger OnOpenPage()
    var
        UCCurrentUser: Codeunit "UC Current User";
    begin
        if UCCurrentUser.GetUser() <> '' then
            LoginMessage := 'Welcome back, ' + UCCurrentUser.GetUser() + '!'
        else
            LoginMessage := 'Please, login or create account to make purchase and view items!';
    end;

    var
        LoginMessage: Text;
}