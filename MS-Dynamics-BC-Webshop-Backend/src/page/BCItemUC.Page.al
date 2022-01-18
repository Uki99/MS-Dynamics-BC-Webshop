/// <summary>
/// Page BCItem-UC (ID 50125).
/// </summary>
page 50125 "BCItem-UC"
{
    PageType = API;
    Caption = 'itemUC';
    APIPublisher = 'beTerna';
    APIGroup = 'webShop';
    APIVersion = 'v1.0';
    SourceTable = Item;
    DelayedInsert = true;
    EntityName = 'itemUC';
    EntitySetName = 'itemsUC';

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
                field(intern; Rec.BCIntern)
                {
                    Caption = 'Intern';
                    ApplicationArea = All;
                }
                field(specification; Rec.BCCommentLJ)
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
        Mime: Text;

    trigger OnAfterGetCurrRecord()
    begin
        exportPictureToAPI(Rec);
    end;

    // Exports data such as file name, file binary in base 64 and mime type to API.
    // Only a single picture from MediaSet is exported.
    local procedure exportPictureToAPI(var Item: Record Item)
    var
        TenantMedia: Record "Tenant Media";
        Base64Convert: Codeunit "Base64 Convert";
        MediaInStream: InStream;
    begin
        if Item.Picture.Count = 0 then begin
            ImageDataBase64 := 'No Content';
            Mime := '';
            PictureName := '';
            exit;
        end;

        TenantMedia.Get(Item.Picture.Item(1));
        TenantMedia.CalcFields(Content);

        if TenantMedia.Content.HasValue() then begin
            TenantMedia.Content.CreateInStream(MediaInStream, TextEncoding::Windows);
            ImageDataBase64 := Base64Convert.ToBase64(MediaInStream);
            Mime := TenantMedia."Mime Type";
            PictureName := Item."No." + ' ' + Item.Description + GetImgFileExtension(Mime);
        end;
    end;

    // Gets file exitension from mime type.
    local procedure GetImgFileExtension(Mime: Text): Text
    begin
        case Mime of
            'image/jpeg':
                exit('.jpg');
            'image/png':
                exit('.png');
            'image/bmp':
                exit('.bmp');
            'image/gif':
                exit('.gif');
            'image/tiff':
                exit('.tiff');
            'image/wmf':
                exit('.wmf');
            else
                exit('');
        end;
    end;
}