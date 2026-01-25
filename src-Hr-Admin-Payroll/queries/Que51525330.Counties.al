query 51525330 Counties
{
    Caption = 'Counties';
    QueryType = Normal;

    elements
    {
        dataitem(County; County)
        {
            column("Code"; "Code")
            {
            }
            column(Name; Name)
            {
            }
        }
    }
}