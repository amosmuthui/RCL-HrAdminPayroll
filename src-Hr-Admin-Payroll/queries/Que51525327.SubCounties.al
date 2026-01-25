query 51525327 "Sub Counties"
{
    Caption = 'Sub Counties';
    QueryType = Normal;

    elements
    {
        dataitem(Sub_County; "Sub County")
        {
            column(County_Code; "County Code")
            {
            }
            column(Sub_County_Code; "Sub County Code")
            {
            }
            column(Sub_County_Description; "Sub County Description")
            {
            }
        }
    }
}