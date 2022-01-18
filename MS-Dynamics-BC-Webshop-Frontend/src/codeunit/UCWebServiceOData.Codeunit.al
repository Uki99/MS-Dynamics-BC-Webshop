/// <summary>
/// Codeunit UC Web Service OData (ID 64904).
/// </summary>
codeunit 64904 "UC Web Service OData"
{
    /// <summary>
    /// CallODataService.
    /// </summary>
    /// <param name="OperationName">Text.</param>
    /// <param name="BodyContent">Text.</param>
    /// <returns>Return value of type JsonObject.</returns>
    procedure CallODataService(OperationName: Text; BodyContent: Text): JsonObject;
    var
        UCWebShopSetup: Record "UC Web Shop Setup";
        HttpClient: HttpClient;
        HttpHeaders: HttpHeaders;
        HttpContent: HttpContent;
        HttpResponseMessage: HttpResponseMessage;
        ResponseJsonToken: JsonToken;
        ResponseText: Text;
    begin
        if not UCWebShopSetup.Get() then
            Error('Failed to read Web Shop setup.\Please, setup the Web Shop setup page first.');

        SetRequestHeader(HttpClient, UCWebShopSetup);

        HttpContent.WriteFrom(BodyContent);

        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/json');

        if not HttpClient.Post(GetServicePath(OperationName), HttpContent, HttpResponseMessage) then
            Error('Something went wrong. Error status code is %1.', HttpResponseMessage.HttpStatusCode);

        if HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpResponseMessage.Content.ReadAs(ResponseText);
            ResponseJsonToken.ReadFrom(ResponseText);
            exit(ResponseJsonToken.AsObject());
        end
        else begin
            HttpResponseMessage.Content.ReadAs(ResponseText);
            Error('Error: %1\from request: %2', ResponseText, BodyContent);
        end;
    end;

    /// <summary>
    /// SetRequestHeader.
    /// </summary>
    /// <param name="httpClient">VAR httpClient.</param>
    /// <param name="BCWebShopSetup">VAR Record "BCWeb Shop Setup".</param>
    procedure SetRequestHeader(var httpClient: httpClient; var BCWebShopSetup: Record "UC Web Shop Setup")
    var
        Base64Convert: Codeunit "Base64 Convert";
        AuthString: Text;
    begin
        AuthString := StrSubstNo(UserPwdTok, BCWebShopSetup."Backend Username", BCWebShopSetup."Backend Password");
        AuthString := Base64Convert.ToBase64(AuthString);
        httpClient.DefaultRequestHeaders().Add('Authorization', StrSubstNo(HeaderDataTok, AuthString));
    end;

    local procedure GetServicePath(OperationName: Text): Text
    begin
        exit('https://bc-webshop.westeurope.cloudapp.azure.com:7048/bc/api/v2.0/companies(3adc449e-8621-ec11-bb76-000d3a29933c)/' + OperationName);
    end;

    /// <summary>
    /// GetSalesOrderLinePath.
    /// </summary>
    /// <param name="id">Text.</param>
    /// <returns>Return value of type text.</returns>
    procedure GetSalesOrderLinePath(id: Text): text
    begin
        exit('salesOrders(' + id + ')/salesOrderLines');
    end;

    var
        UserPwdTok: Label '%1:%2', Comment = '%1 is username, %2 is password.';
        HeaderDataTok: Label 'Basic %1', Comment = '%1 represents Base64 encoded WebService login in a specific format.';
}