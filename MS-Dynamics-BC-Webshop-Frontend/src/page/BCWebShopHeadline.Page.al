/// <summary>
/// Page BCRetail Headline (ID 50106).
/// </summary>
page 50107 "BCWebShop Headline"
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
        BCCurrentUser: Codeunit BCCurrentUser;
    begin
        if BCCurrentUser.GetUser() <> '' then
            LoginMessage := 'Welcome back, ' + BCCurrentUser.GetUser() + '!'
        else
            LoginMessage := 'Please, login or create account to make purchase and view items!';
    end;

    var
        LoginMessage: Text;
}