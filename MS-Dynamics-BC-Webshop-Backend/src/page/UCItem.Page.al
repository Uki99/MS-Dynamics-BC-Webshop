/// <summary>
/// Page UC Item (ID 50125).
/// </summary>
page 50125 "UC Item"
{
    PageType = API;
    Caption = 'itemUC', Locked = true;
    APIPublisher = 'ugljesa';
    APIGroup = 'webShop';
    APIVersion = 'v1.0';
    EntityCaption = 'itemUC', Locked = true;
    EntitySetCaption = 'itemsUC', Locked = true;
    EntityName = 'itemUC';
    EntitySetName = 'itemsUC';
    SourceTable = Item;
    DelayedInsert = true;
    ODataKeyFields = "No.";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                    ApplicationArea = All;
                }
                field(name; Rec.Description)
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                }
                field(unitPrice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                    ApplicationArea = All;
                }
                field(inventory; Rec.Inventory)
                {
                    Caption = 'Inventory';
                    ApplicationArea = All;
                }
                field(intern; Rec."UC Intern")
                {
                    Caption = 'Intern';
                    ApplicationArea = All;
                }
                field(specification; Rec."UC Comment")
                {
                    Caption = 'Specification';
                    ApplicationArea = All;
                }
                field(imageDataBase64; ImageDataBase64)
                {
                    Caption = 'Image Data';
                    ApplicationArea = All;
                }
                field(mime; Mime)
                {
                    Caption = 'Mime';
                    ApplicationArea = All;
                }
                field(pictureName; PictureName)
                {
                    Caption = 'Picture name';
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        ImageDataBase64: Text;
        PictureName: Text;
        Mime: Text[100];

    trigger OnAfterGetCurrRecord()
    begin
        ExportPictureToAPI();
    end;

    local procedure ExportPictureToAPI()
    var
        TenantMedia: Record "Tenant Media";
        Base64Convert: Codeunit "Base64 Convert";
        MediaInStream: InStream;
    begin
        if Rec.Picture.Count = 0 then begin
            ImageDataBase64 := 'No Content';
            Mime := '';
            PictureName := '';
            exit;
        end;

        // Only a single picture from MediaSet is exported.
        TenantMedia.Get(Rec.Picture.Item(1));
        TenantMedia.CalcFields(Content);

        if TenantMedia.Content.HasValue() then begin
            TenantMedia.Content.CreateInStream(MediaInStream, TextEncoding::Windows);
            ImageDataBase64 := Base64Convert.ToBase64(MediaInStream);
            Mime := TenantMedia."Mime Type";
            PictureName := Rec."No." + ' ' + Rec.Description + GetImageFileExtension(Mime);
        end;
    end;

    local procedure GetImageFileExtension(Mime: Text): Text
    begin
        case Mime of
            'image/jpeg':
                Exit('.jpg');
            'image/png':
                Exit('.png');
            'image/bmp':
                Exit('.bmp');
            'image/gif':
                Exit('.gif');
            'image/tiff':
                Exit('.tiff');
            'image/wmf':
                Exit('.wmf');
            else
                Error('Unsupported image extension of mime type: %1', Mime);
        end;
    end;
}