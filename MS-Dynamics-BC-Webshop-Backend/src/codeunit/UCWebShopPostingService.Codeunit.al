/// <summary>
/// Codeunit UC Web Shop Posting Service (ID 50125).
/// </summary>
codeunit 50125 "UC Web Shop Posting Service"
{
    /// <summary>
    /// PostTransaction.
    /// </summary>
    /// <param name="OrderJSON">Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure PostTransaction(OrderJSON: Text): Text
    begin
        exit('Hello ' + OrderJSON);


        // To do: Post the order and sales lines and do general journal entries
    end;
}