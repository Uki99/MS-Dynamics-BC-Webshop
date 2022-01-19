/// <summary>
/// Table UC Cart Entry (ID 64900).
/// </summary>
table 64900 "UC Cart Entry"
{
    Caption = 'Cart Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                ValidateNameAndPrice();
            end;
        }
        field(3; "Item Name"; Text[100])
        {
            Caption = 'Item Name';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                Rec.Validate(Amount);
            end;
        }
        field(4; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                Rec.Validate(Amount);
            end;
        }
        field(5; Quantity; Integer)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                Rec.Validate(Amount);
            end;
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                Rec.Amount := (Rec.Quantity * Rec."Unit Price");
            end;
        }
        field(7; Username; Text[250])
        {
            Caption = 'Username';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        UCCurrentUser: Codeunit "UC Current User";

    trigger OnInsert()
    begin
        Rec.Username := UCCurrentUser.GetUser();
    end;

    local procedure ValidateNameAndPrice()
    var
        UCWebShopItem: Record "UC Web Shop Item";
    begin
        if Rec."Item No." <> '' then begin
            UCWebShopItem.SetLoadFields(Name, "Unit Price");
            UCWebShopItem.Get(Rec."Item No.");
            Rec.Validate("Item Name", UCWebShopItem.Name);
            Rec.Validate("Unit Price", UCWebShopItem."Unit Price");
        end;
    end;

    /// <summary>
    /// CalcTotalAmount.
    /// </summary>
    /// <returns>Return value of type Decimal.</returns>
    procedure CalcTotalAmount(): Decimal;
    begin
        Rec.SetRange(Username, UCCurrentUser.GetUser());
        Rec.CalcSums(Amount);
        exit(Rec.Amount);
    end;
}