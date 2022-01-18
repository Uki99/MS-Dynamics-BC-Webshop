/// <summary>
/// Codeunit UC Web Shop Load (ID 64902).
/// </summary>
codeunit 64902 "UC Web Shop Load"
{
    trigger OnRun()
    var
        UCWebShopSetup: Record "UC Web Shop Setup";
        httpClient: httpClient;
        HttpResponseMessage: HttpResponseMessage;
        ResponseText: Text;
    begin
        if not UCWebShopSetup.Get() then
            Error('Failed to read Web Shop setup.\Please, setup the Web Shop setup page first.');

        SetRequestHeader(httpClient, UCWebShopSetup);

        httpClient.Get(StrSubstNo(BackEndWebShopUrlTxt, UCWebShopSetup."Backend Web Service URL"), HttpResponseMessage);

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
        UCWebShopItem: Record "UC Web Shop Item";
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
            UCWebShopItem.Init();

            UCWebShopItem."No." := CopyStr(BCJSONUtility.GetFieldValue(ItemJsonObject, 'no').AsCode(), 1, MaxStrLen(UCWebShopItem."No."));
            UCWebShopItem.Name := CopyStr(BCJSONUtility.GetFieldValue(ItemJsonObject, 'name').AsText(), 1, MaxStrLen(UCWebShopItem.Name));
            UCWebShopItem."Unit Price" := BCJSONUtility.GetFieldValue(ItemJsonObject, 'unitPrice').AsDecimal();
            UCWebShopItem."Inventory" := BCJSONUtility.GetFieldValue(ItemJsonObject, 'inventory').AsDecimal();
            UCWebShopItem.Intern := GetIntern(ItemJsonObject);
            UCWebShopItem.Specification := CopyStr(BCJSONUtility.GetFieldValue(ItemJsonObject, 'specification').AsText(), 1, MaxStrLen(UCWebShopItem.Specification));

            loadImage(UCWebShopItem, ItemJsonObject);

            UCWebShopItem.Insert();
        end;
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

    // Returns intern enum according to string value.
    local procedure GetIntern(ItemJsonObject: JsonObject): Enum "UC Intern"
    var
        Intern: Text;
    begin
        Intern := BCJSONUtility.GetFieldValue(ItemJsonObject, 'intern').AsText();

        case Intern of
            'KC':
                exit(Enum::"UC Intern"::KC);
            'MM':
                exit(Enum::"UC Intern"::MM);
            'IA':
                exit(Enum::"UC Intern"::IA);
            'LJ':
                exit(Enum::"UC Intern"::LJ);
            'UC':
                exit(Enum::"UC Intern"::UC);
            'PA':
                exit(Enum::"UC Intern"::PA);
            'YS':
                exit(Enum::"UC Intern"::YS);
            else
                exit(Enum::"UC Intern"::" ");
        end;
    end;

    // Loads image to provided record from json that holds data of image.
    local procedure loadImage(var BCItemUC: Record "UC Web Shop Item"; var ItemJsonObject: JsonObject)
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
        BCJSONUtility: Codeunit "UC JSON Utility";
        UserPwdTok: Label '%1:%2', Comment = '%1 is username, %2 is password.';
        HeaderDataTok: Label 'Basic %1', Comment = '%1 represents Base64 encoded WebService login in a specific format.';
        WebErrorErr: Label 'Error occurred.\Status code: %1', Comment = '%1 is http status code.';
        BackEndWebShopUrlTxt: Label '%1/beTerna/webShop/v1.0/companies(3adc449e-8621-ec11-bb76-000d3a29933c)/itemsUC?$filter=intern eq ''UC''', Comment = '%1 is API base URL.';
}