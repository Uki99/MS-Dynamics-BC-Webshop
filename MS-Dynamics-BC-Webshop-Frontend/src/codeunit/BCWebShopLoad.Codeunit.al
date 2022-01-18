/// <summary>
/// Codeunit BCWebShopLoad (ID 50100).
/// </summary>
codeunit 50100 "BCWebShopLoad"
{
    trigger OnRun()
    var
        BCWebShopSetup: Record "BCWeb Shop Setup";
        httpClient: httpClient;
        HttpResponseMessage: HttpResponseMessage;
        ResponseText: Text;
    begin
        if not BCWebShopSetup.Get() then
            Error('Failed to read Web Shop setup.\Please, setup the Web Shop setup page first.');

        SetRequestHeader(httpClient, BCWebShopSetup);

        httpClient.Get(StrSubstNo(BackEndWebShopUrlTxt, BCWebShopSetup."Backend Web Service URL"), HttpResponseMessage);

        if HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpResponseMessage.Content().ReadAs(ResponseText);
            ParseJson(ResponseText);
        end
        else
            Error(WebErrorErr, HttpResponseMessage.HttpStatusCode());
    end;

    // Parses provided text (JSON) and inserts it into table
    local procedure ParseJson(ResponseText: Text)
    var
        BCItemUC: Record "BCItem UC";
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
        ItemJsonObject: JsonObject;
        ItemJsonToken: JsonToken;
    begin
        JsonObject.ReadFrom(ResponseText);

        if JsonObject.Contains('value') then
            JsonObject.Get('value', JsonToken)
        else
            Error('Could not parse JSON. Please try again.');

        if JsonToken.IsArray() then
            JsonArray := JsonToken.AsArray()
        else
            Error('JSON parse error: JSON is not an array!');

        foreach ItemJsonToken in JsonArray do begin
            ItemJsonObject := ItemJsonToken.AsObject();
            BCItemUC.Init();

            BCItemUC."No." := CopyStr(BCJSONUtility.GetFieldValue(ItemJsonObject, 'no').AsCode(), 1, MaxStrLen(BCItemUC."No."));
            BCItemUC.Name := CopyStr(BCJSONUtility.GetFieldValue(ItemJsonObject, 'name').AsText(), 1, MaxStrLen(BCItemUC.Name));
            BCItemUC."Unit Price" := BCJSONUtility.GetFieldValue(ItemJsonObject, 'unitPrice').AsDecimal();
            BCItemUC."Inventory" := BCJSONUtility.GetFieldValue(ItemJsonObject, 'inventory').AsDecimal();
            BCItemUC.Intern := GetIntern(ItemJsonObject);
            BCItemUC.Specification := CopyStr(BCJSONUtility.GetFieldValue(ItemJsonObject, 'specification').AsText(), 1, MaxStrLen(BCItemUC.Specification));

            loadImage(BCItemUC, ItemJsonObject);

            BCItemUC.Insert();
        end;
    end;

    // Sets request header and does authorization
    local procedure SetRequestHeader(var httpClient: httpClient; var BCWebShopSetup: Record "BCWeb Shop Setup")
    var
        Base64Convert: Codeunit "Base64 Convert";
        AuthString: Text;
    begin
        AuthString := StrSubstNo(UserPwdTok, BCWebShopSetup."Backend Username", BCWebShopSetup."Backend Password");
        AuthString := Base64Convert.ToBase64(AuthString);
        httpClient.DefaultRequestHeaders().Add('Authorization', StrSubstNo(HeaderDataTok, AuthString));
    end;

    // Returns intern enum according to string value.
    local procedure GetIntern(ItemJsonObject: JsonObject): Enum BCIntern
    var
        Intern: Text;
    begin
        Intern := BCJSONUtility.GetFieldValue(ItemJsonObject, 'intern').AsText();

        case Intern of
            'KC':
                exit(ENUM::BCIntern::KC);
            'MM':
                exit(ENUM::BCIntern::MM);
            'IA':
                exit(ENUM::BCIntern::IA);
            'LJ':
                exit(ENUM::BCIntern::LJ);
            'UC':
                exit(ENUM::BCIntern::UC);
            'PA':
                exit(ENUM::BCIntern::PA);
            'YS':
                exit(ENUM::BCIntern::YS);
            else
                exit(ENUM::BCIntern::" ");
        end;
    end;

    // Loads image to provided record from json that holds data of image.
    local procedure loadImage(var BCItemUC: Record "BCItem UC"; var ItemJsonObject: JsonObject)
    var
        Base64Convert: Codeunit "Base64 Convert";
        tempBlob: Codeunit "Temp Blob";
        ImageDataBase64: Text;
        PictureName: Text;
        Mime: Text;
        InStream: InStream;
        OutStream: OutStream;
    begin
        ImageDataBase64 := BCJSONUtility.GetFieldValue(ItemJsonObject, 'imageDataBase64').AsText();
        if ImageDataBase64 = 'No Content' then
            exit;

        TempBlob.CreateOutStream(OutStream);
        Base64Convert.FromBase64(ImageDataBase64, OutStream);
        TempBlob.CreateInStream(InStream);

        PictureName := BCJSONUtility.GetFieldValue(ItemJsonObject, 'pictureName').AsText();
        Mime := BCJSONUtility.GetFieldValue(ItemJsonObject, 'mime').AsText();

        BCItemUC.Picture.ImportStream(InStream, PictureName, Mime);
    end;

    // Global vars
    var
        BCJSONUtility: Codeunit BCJSONUtility;
        UserPwdTok: Label '%1:%2', Comment = '%1 is username, %2 is password.';
        HeaderDataTok: Label 'Basic %1', Comment = '%1 represents Base64 encoded WebService login in a specific format.';
        WebErrorErr: Label 'Error occurred.\Status code: %1', Comment = '%1 is http status code.';
        BackEndWebShopUrlTxt: Label '%1/beTerna/webShop/v1.0/companies(3adc449e-8621-ec11-bb76-000d3a29933c)/itemsUC?$filter=intern eq ''UC''', Comment = '%1 is API base URL.';
}