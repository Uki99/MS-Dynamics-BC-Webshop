/// <summary>
/// Codeunit BCCurrentUser (ID 50102).
/// </summary>
codeunit 50101 "BCCurrentUser"
{
    SingleInstance = true;

    /// <summary>
    /// GetUser.
    /// </summary>
    /// <returns>Return value of type Text[250].</returns>
    procedure GetUser(): Text[100]
    begin
        exit(Username);
    end;

    /// <summary>
    /// SetUser.
    /// </summary>
    /// <param name="Name">Text[250].</param>
    procedure SetUser(Name: Text[100])
    begin
        Username := Name;
    end;

    /// <summary>
    /// Register.
    /// </summary>
    /// <param name="Password">Text[250].</param>
    procedure Register(Password: Text[250])
    begin
        if not IsolatedStorage.Contains(Username) then
            IsolatedStorage.Set(Username, Password)
        else
            Error('Username already exists!');
    end;

    /// <summary>
    /// ValidatePassword.
    /// </summary>
    /// <param name="Password">Text[250].</param>
    /// <param name="NewUsername">Text[100].</param>
    procedure ValidateLogin(Password: Text[250]; NewUsername: Text[100])
    var
        PasswordFromStorage: Text;
    begin
        if not IsolatedStorage.Get(NewUsername, PasswordFromStorage) then
            Error('Username does not exist!');

        if PasswordFromStorage <> Password then
            Error('Wrong password!');

        SetUser(NewUsername);
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
            IsolatedStorage.Get(Username + 'ID', UserNo);
    end;

    var
        Username: Text[100];
}