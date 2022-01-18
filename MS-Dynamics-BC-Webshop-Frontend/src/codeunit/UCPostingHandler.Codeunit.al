/// <summary>
/// Codeunit UC Posting Handler (ID 64903).
/// </summary>
codeunit 64903 "UC Posting Handler"
{
    /// <summary>
    /// SendToPost.
    /// </summary>
    /// <param name="OrderJSON">Text.</param>
    procedure SendToPost(OrderJSON: Text)
    var
        UCWebShopSetup: Record "UC Web Shop Setup";
        HttpClient: HttpClient;
        HttpHeaders: HttpHeaders;
        HttpContent: HttpContent;
        HttpResponseMessage: HttpResponseMessage;
        ResponseText: Text;
    begin
        if not UCWebShopSetup.Get() then
            Error('Failed to read Web Shop setup.\Please, setup the Web Shop setup page first.');

        SetRequestHeader(HttpClient, UCWebShopSetup);

        HttpContent.GetHeaders(HttpHeaders);
        HttpContent.WriteFrom(SoapContentBody(OrderJSON));
        SoapContentHeader(HttpHeaders, 'PostTransaction');

        if not HttpClient.Post('https://bc-webshop.westeurope.cloudapp.azure.com:7047/BC/WS/CRONUS%20International%20Ltd./Codeunit/SOAPUC', HttpContent, HttpResponseMessage) then
            Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode());

        if HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpResponseMessage.Content.ReadAs(ResponseText);
            Message('Your items are on the way! Thank you for having a business with us!' + ParseResponse(ResponseText));
        end
        else begin
            HttpResponseMessage.Content.ReadAs(ResponseText);
            Error(WebError2Msg, HttpResponseMessage.HttpStatusCode(), ParseResponseError(ResponseText));
        end;
    end;

    local procedure SoapContentBody(Content: Text) returnValue: Text
    begin
        returnValue := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soap="urn:microsoft-dynamics-schemas/codeunit/SOAPUC">'
                     + '<soapenv:Header/>'
                     + '<soapenv:Body>'
                     + '<soap:PostTransaction>'
                     + '<soap:orderJSON>' + Content + '</soap:orderJSON>'
                     + '</soap:PostTransaction>'
                     + '</soapenv:Body>'
                     + '</soapenv:Envelope>';
    end;

    // Edits the header according to the content type we are sending
    local procedure SoapContentHeader(var HttpHeaders: HttpHeaders; Operation: Text)
    begin
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'text/xml');
        HttpHeaders.Add('SOAPAction', '"urn:microsoft-dynamics-schemas/codeunit/SOAPUC' + Operation + '"');
    end;

    // Sets request header and does authorization
    local procedure SetRequestHeader(var httpClient: httpClient; var BCWebShopSetup: Record "UC Web Shop Setup")
    var
        Base64Convert: Codeunit "Base64 Convert";
        AuthString: Text;
    begin
        AuthString := StrSubstNo(UserPwdTok, BCWebShopSetup."Backend Username", BCWebShopSetup."Backend Password");
        AuthString := Base64Convert.ToBase64(AuthString);
        httpClient.DefaultRequestHeaders().Add('Authorization', StrSubstNo(HeaderDataTok, AuthString));
    end;

    local procedure ParseResponseError(ResponseText: Text): Text
    var
        ResponseXMLDocument: XMLDocument;
        RootXmlElement: XMLElement;
        BodyXMLNode: XMLNode;
        OperationResultXMLNode: XMLNode;
        ResultXMLNode: XMLNode;
        ResultsXMLNodeList: XMLNodeList;
    begin
        XMLDocument.ReadFrom(ResponseText, ResponseXMLDocument);
        ResponseXMLDocument.GetRoot(RootXmlElement);
        RootXmlElement.GetChildNodes().Get(1, BodyXMLNode);
        BodyXMLNode.AsXmlElement().GetChildNodes().Get(1, OperationResultXMLNode);
        ResultsXMLNodeList := OperationResultXMLNode.AsXmlElement().GetChildNodes();
        foreach ResultXMLNode in ResultsXMLNodeList do
            if ResultXMLNode.AsXmlElement().Name() = 'detail' then
                exit(ResultXMLNode.AsXmlElement().InnerText);

        exit('Something went wrong.');
    end;

    local procedure ParseResponse(ResponseText: Text): Text
    var
        ResponseXMLDocument: XMLDocument;
        RootXmlElement: XMLElement;
        BodyXMLNode: XMLNode;
        OperationResultXMLNode: XMLNode;
        ResultXMLNode: XMLNode;
    begin
        XMLDocument.ReadFrom(ResponseText, ResponseXMLDocument);
        ResponseXMLDocument.GetRoot(RootXmlElement);
        RootXmlElement.GetChildNodes().Get(1, BodyXMLNode);
        BodyXMLNode.AsXmlElement().GetChildNodes().Get(1, OperationResultXMLNode);
        OperationResultXMLNode.AsXmlElement().GetChildNodes().Get(1, ResultXMLNode);
        if ResultXMLNode.IsXmlElement() then
            exit(ResultXMLNode.AsXmlElement().InnerText)
        else
            exit('');
    end;

    var
        WebErrorMsg: Label 'Something went wrong. Error Code is: %1', Comment = '%1 = Error code.';
        WebError2Msg: Label 'Error on server side. Error Code is: %1, Error Text is: %2', Comment = '%1 = Error code., %2 = Error text.';
        UserPwdTok: Label '%1:%2', Comment = '%1 is username, %2 is password.';
        HeaderDataTok: Label 'Basic %1', Comment = '%1 represents Base64 encoded WebService login in a specific format.';
}