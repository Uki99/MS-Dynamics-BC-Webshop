/// <summary>
/// Page UC Login Page (ID 64901).
/// </summary>
page 64901 "UC Login Page"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = Card;
    Caption = 'Login';

    layout
    {
        area(Content)
        {
            group(Info)
            {
                Caption = 'Credentials';

                field(Username; Username)
                {
                    ApplicationArea = All;
                    Caption = 'Username';
                    ToolTip = 'Specifies the value of the Username field.';
                }
                field(Password; Password)
                {
                    ApplicationArea = All;
                    Caption = 'Username';
                    ExtendedDatatype = Masked;
                    ToolTip = 'Specifies the value of the Username field.';
                }
            }
            group(Notifications)
            {
                Caption = 'Notification';

                field(Notification; Notification)
                {
                    ApplicationArea = All;
                    Caption = 'Notification';
                    ToolTip = 'Specifies the value of the Notification field.';
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Login)
            {
                ApplicationArea = All;
                Caption = 'Login';
                Image = ImportLog;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Login action.';

                trigger OnAction()
                begin
                    TryLogin();
                end;
            }
            action(Register)
            {
                ApplicationArea = All;
                Caption = 'Register';
                Image = Add;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Register action.';

                trigger OnAction()
                begin
                    RegisterNewUser();
                end;
            }
        }
    }

    var
        UCCurrentUser: Codeunit "UC Current User";
        Username: Text[100];
        Password: Text[250];
        Notification: Text;

    trigger OnOpenPage()
    begin
        if UCCurrentUser.GetUser() = '' then
            Notification := 'You are currently not logged in. Register or log in.'
        else
            Notification := 'You are currently logged in as: ' + UCCurrentUser.GetUser();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::LookupOK then begin
            UCCurrentUser.ValidateLogin(Password, Username);
            Message('Successfully logged in as: ' + UCCurrentUser.GetUser());
            Exit(UCCurrentUser.GetUser() <> '');
        end;
    end;

    local procedure TryLogin()
    begin
        UCCurrentUser.ValidateLogin(Password, Username);
        Message('Successfully logged in as: ' + UCCurrentUser.GetUser());
        CurrPage.Close();
        Page.Run(Page::"UC Login Page");
    end;

    local procedure RegisterNewUser()
    var
        UCWebShopSetup: Record "UC Web Shop Setup";
        UCJSONUtility: Codeunit "UC JSON Utility";
        UCWebServiceOData: Codeunit "UC Web Service OData";
        CustomerJSON: Text;
        ReturnJSONCustomer: JsonObject;
    begin
        if not UCWebShopSetup.Get() then
            Error('Failed to read Web Shop setup.\Please, setup the Web Shop setup page first.');

        UCCurrentUser.SetUser(Username);
        UCCurrentUser.Register(Password);
        Message('Successfully registered as user: ' + UCCurrentUser.GetUser());
        CurrPage.Close();
        Page.Run(Page::"UC Login Page");

        // Creating new customer for this username on backend
        CustomerJSON := UCJSONUtility.CreateCustomerJSON(UCCurrentUser.GetUser());
        ReturnJSONCustomer := UCWebServiceOData.CallODataService('customers', CustomerJSON);

        // Sets currently logged in user's Customer No. from backend so it can be refferenced from frontend when crafting transaction body
        UCCurrentUser.SetUserCustomerNo(UCJSONUtility.GetFieldValue(ReturnJSONCustomer, 'number').AsText());
    end;
}