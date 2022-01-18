/// <summary>
/// Page BCLoginPage (ID 50104).
/// </summary>
page 50104 "BCLoginPage"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
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
                    BCCurrentUser.ValidateLogin(Password, Username);
                    Message('Successfully logged in as: ' + BCCurrentUser.GetUser());
                    CurrPage.Close();
                    Page.Run(Page::BCLoginPage);
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
                var
                    BCWebShopSetup: Record "BCWeb Shop Setup";
                    BCJSONUtility: Codeunit BCJSONUtility;
                    BCWebService: Codeunit BCWebServiceOData;
                    CustomerJSON: Text;
                    ReturnJSONCustomer: JsonObject;
                begin
                    if not BCWebShopSetup.Get() then
                        Error('Failed to read Web Shop setup.\Please, setup the Web Shop setup page first.');

                    BCCurrentUser.SetUser(Username);
                    BCCurrentUser.Register(Password);
                    Message('Successfully registered as user: ' + BCCurrentUser.GetUser());
                    CurrPage.Close();
                    Page.Run(Page::BCLoginPage);

                    // Creating new customer for this username on backend
                    CustomerJSON := BCJSONUtility.CreateCustomerJSON(BCCurrentUser.GetUser());
                    ReturnJSONCustomer := BCWebService.CallODataService('customers', CustomerJSON);

                    // Sets currently logged in user's Customer No. from backend so it can be refferenced from frontend when crafting transaction body
                    BCCurrentUser.SetUserCustomerNo(BCJSONUtility.GetFieldValue(ReturnJSONCustomer, 'number').AsText());
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if BCCurrentUser.GetUser() = '' then
            Notification := 'You are currently not logged in. Register or log in.'
        else
            Notification := 'You are currently logged in as: ' + BCCurrentUser.GetUser();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::LookupOK then begin
            BCCurrentUser.ValidateLogin(Password, Username);

            if Username <> '' then
                Message('Successfully logged in as: ' + BCCurrentUser.GetUser());

            exit(BCCurrentUser.GetUser() <> '');
        end;
    end;

    var
        BCCurrentUser: codeunit BCCurrentUser;
        Username: Text[100];
        Password: Text[250];
        Notification: Text;
}