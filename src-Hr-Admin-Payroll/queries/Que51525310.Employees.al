query 51525310 Employees
{
    OrderBy = Ascending(Full_Name);

    elements
    {
        dataitem(Employee; Employee)
        {
            DataItemTableFilter = Status = CONST(Active)
;
            column(No; "No.")
            {
            }
            column(Full_Name; "Search Name")
            {
            }
        }
    }
}