query 51525329 "Job Resps"
{
    Caption = 'Job Resps';
    QueryType = Normal;

    OrderBy = Ascending(Line_No);

    elements
    {
        dataitem(Job_Responsiblities; "Job Responsiblities")
        {
            column(Job_ID; "Job ID")
            {
            }
            column(Responsibility; Responsibility)
            {
            }
            column(Remarks; Remarks)
            {
            }
            column(Line_No; "Line No")
            {
            }
            column(Job_Responsibility_Category; "Job Responsibility Category")
            {
            }
            column(Need_ID; "Need ID")
            {
            }
        }
    }
}