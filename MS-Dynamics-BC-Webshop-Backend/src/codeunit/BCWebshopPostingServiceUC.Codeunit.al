/// <summary>
/// Codeunit BCWebshop Posting Service-UC (ID 50125).
/// </summary>
codeunit 50125 "BCWebshop Posting Service-UC"
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