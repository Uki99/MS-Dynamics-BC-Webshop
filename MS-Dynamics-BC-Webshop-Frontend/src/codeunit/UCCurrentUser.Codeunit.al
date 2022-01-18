/// <summary>
/// Codeunit UC Current User (ID 64900).
/// </summary>
codeunit 64900 "UC Current User"
{
    SingleInstance = true;

    /// <summary>
    /// GetUser.
    /// </summary>
    /// <returns>Return value of type Text[100].</returns>
    procedure GetUser(): Text[100]
    begin
        exit(Username);
    end;

    /// <summary>
    /// SetUser.
    /// </summary>
    /// <param name="Name">Text[100].</param>
    procedure SetUser(Name: Text[100])
    begin
        Username := Name;
    end;

    /// <summary>
    /// Register.
    /// </summary>
    /// <param name="Password">Text[100].</param>
    procedure Register(Password: Text[250])
    begin
        if not IsolatedStorage.Contains(Username) then
            IsolatedStorage.Set(Username, Password)
        else
            Error('Username already exists!');
    end;

    /// <summary>
    /// ValidateLogin.
    /// </summary>
    /// <param name="Password">Text[250].</param>
    /// <param name="Username">Text[100].</param>
    procedure ValidateLogin(Password: Text[250]; Username: Text[100])
    var
        PasswordFromStorage: Text;
    begin
        if not IsolatedStorage.Get(Username, PasswordFromStorage) then
            Error('Username does not exist!');

        if PasswordFromStorage <> Password then
            Error('Wrong password!');

        SetUser(Username);
    end;

    /// <summary>
    /// SetUserCustomerNo.
    /// </summary>
    /// <param name="Customer No.">Text.</param>
    procedure SetUserCustomerNo("Customer No.": Text)
    begin
        IsolatedStorage.Set(Username + 'ID', "Customer No.")
    end;

    /// <summary>
    /// GetUserCustomerNo.
    /// </summary>
    /// <returns>Return variable 'User No' of type Text.</returns>
    procedure GetUserCustomerNo() UserNo: Text
    begin
        if Username <> '' then
            IsolatedStorage.Get(Username + 'ID', UserNo)
        else
            Error('Login first to try to get Customer number from logged user!');
    end;

    var
        Username: Text[100];
}