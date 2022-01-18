/// <summary>
/// Table BCCart Entry (ID 50102).
/// </summary>
table 50102 "BCCart Entry"
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
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                "BCItem UC": Record "BCItem UC";
            begin
                if "Item No." <> '' then begin
                    "BCItem UC".Get("Item No.");
                    Rec.Validate("Item Name", "BCItem UC".Name);
                    Rec.Validate("Unit Price", "BCItem UC"."Unit Price");
                end;
            end;
        }
        field(3; "Item Name"; Text[100])
        {
            Caption = 'Item Name';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                Rec.Validate(Rec."Amount");
            end;
        }
        field(4; "Unit Price"; Integer)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                Rec.Validate(Rec."Amount");
            end;
        }
        field(5; Quantity; Integer)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                Rec.Validate(Rec."Amount");
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

    /// <summary>
    /// CalcTotalAmount.
    /// </summary>
    /// <returns>Return value of type Decimal.</returns>
    procedure CalcTotalAmount(): Decimal;
    var
        BCCurrentUser: Codeunit "BCCurrentUser";
    begin
        Rec.SetRange(Username, BCCurrentUser.GetUser());
        Rec.CalcSums(Amount);
        exit(Rec.Amount);
    end;

    trigger OnInsert()
    var
        BCCurrentUser: Codeunit BCCurrentUser;
    begin
        Rec.Username := BCCurrentUser.GetUser();
    end;
}