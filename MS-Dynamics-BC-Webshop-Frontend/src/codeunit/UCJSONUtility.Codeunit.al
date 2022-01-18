/// <summary>
/// Codeunit UC JSON Utility (ID 64901).
/// </summary>
codeunit 64901 "UC JSON Utility"
{
    /// <summary>
    /// GetFieldValue.
    /// </summary>
    /// <param name="JsonObject">VAR JsonObject.</param>
    /// <param name="FieldName">Text.</param>
    /// <returns>Return value of type JsonValue.</returns>
    /// Returns JSON value from JSON object which can be cased to any data type you need.
    procedure GetFieldValue(var JsonObject: JsonObject; FieldName: Text): JsonValue
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.Contains(FieldName) then
            Error('Could not parse JSON. Please try again.');

        JsonObject.Get(FieldName, JsonToken);
        exit(JsonToken.AsValue());
    end;

    /// <summary>
    /// CreateCustomerJSON.
    /// </summary>
    /// <param name="Name">Text[100].</param>
    /// <returns>Return variable Customer of type Text.</returns>
    /// Creates JSON for a new dummy customer and returns it as a string
    procedure CreateCustomerJSON(Name: Text[100]) Customer: Text
    var
        CustomerJSON: JsonObject;
    begin
        CustomerJSON.Add('displayName', Name);
        CustomerJSON.Add('type', 'Company');
        CustomerJSON.Add('addressLine1', 'Some Imaginary Address 123');
        CustomerJSON.Add('country', 'RS');
        CustomerJSON.Add('city', 'Beograd');
        CustomerJSON.Add('postalCode', '11100');

        // ID for 'Domestic customers and vendors' customers.
        CustomerJSON.Add('taxAreaId', '95f441a9-8621-ec11-bb76-000d3a29933c');

        CustomerJSON.WriteTo(Customer);
    end;

    /// <summary>
    /// CreateSalesOrder.
    /// </summary>
    /// <param name="CustomerNo">Text.</param>
    /// <returns>Return variable SalesHeaderJSONText of type Text.</returns>
    procedure CreateSalesOrder(CustomerNo: Text) SalesHeaderJSONText: Text
    var
        SalesOrderJsonObject: JsonObject;
    begin
        SalesOrderJsonObject.Add('number', '');
        SalesOrderJsonObject.Add('orderDate', Format(System.Today(), 0, 9));
        SalesOrderJsonObject.Add('customerNumber', CustomerNo);
        SalesOrderJsonObject.WriteTo(SalesHeaderJSONText);
    end;

    /// <summary>
    /// CreateSalesLine.
    /// </summary>
    /// <param name="LineNo">Integer.</param>
    /// <param name="ItemNo">Code[20].</param>
    /// <param name="Qty">Decimal.</param>
    /// <param name="Price">Decimal.</param>
    /// <returns>Return variable SalesLineJSONText of type Text.</returns>
    procedure CreateSalesLine(LineNo: Integer; ItemNo: Code[20]; Qty: Decimal; Price: Decimal) SalesLineJSONText: Text
    var
        SalesLineJsonObject: JsonObject;
    begin
        SalesLineJsonObject.Add('sequence', LineNo);
        SalesLineJsonObject.Add('lineType', 'Item');
        SalesLineJsonObject.Add('lineObjectNumber', ItemNo);
        SalesLineJsonObject.Add('quantity', Qty);
        SalesLineJsonObject.Add('unitPrice', Price);
        SalesLineJsonObject.Add('shipQuantity', Qty);
        SalesLineJsonObject.WriteTo(SalesLineJSONText);
    end;

    /// <summary>
    /// CreateOrderJSONText.
    /// </summary>
    /// <param name="SalesHeaderNo">Text.</param>
    /// <param name="PaymentMethod">Text.</param>
    /// <param name="PayAmountCard">Text.</param>
    /// <param name="PayAmountCash">Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure CreateOrderJSONText(SalesHeaderNo: Text; PaymentMethod: Text; PayAmountCard: Text; PayAmountCash: Text) OrderJSONText: Text;
    var
        OrderJSON: JsonObject;
    begin
        OrderJSON.Add('salesHeaderNo', SalesHeaderNo);
        OrderJSON.Add('paymentMethod', PaymentMethod);
        OrderJSON.Add('payAmountCard', PayAmountCard);
        OrderJSON.Add('payAmountCash', PayAmountCash);

        OrderJSON.WriteTo(OrderJSONText);
    end;
}