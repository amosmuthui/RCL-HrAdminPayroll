query 51525315 "Payroll Period"
{
    elements
    {
        dataitem(Payroll_Period; "Payroll Period")
        {
            DataItemTableFilter = "Display On Portal" = FILTER(true);
            column(Starting_Date; "Starting Date")
            {
            }
            column(Name; Name)
            {
            }
            column(Closed; Closed)
            {
            }
        }
    }
}