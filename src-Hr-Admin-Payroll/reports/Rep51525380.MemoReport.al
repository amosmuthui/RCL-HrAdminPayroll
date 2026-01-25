report 51525380 "Memo Report"
{
    Caption = 'Memo Report';
    dataset
    {
        dataitem(MemoHeader; "Memo Header")
        {
            column(No; "No.")
            {
            }
            column(RequestorUserID; "Requestor User ID")
            {
            }
            column(RequestorName; "Requestor Name")
            {
            }
            column(DepartmentCode; "Department Code")
            {
            }
            column(ActivityDate; "Activity Date")
            {
            }
            column(StartTime; "Start Time")
            {
            }
            column(EndTime; "End Time")
            {
            }
            column(EndDate; "End Date")
            {
            }
            column(Venue; Venue)
            {
            }
            column(CreatedDate; "Created Date")
            {
            }
            column(Purpose; Purpose)
            {
            }
            dataitem("Memo Lines"; "Memo Lines")
            {
                DataItemLink = "Doc No" = FIELD("No.");


                column(Start_Date; "Start Date")
                {

                }
                column(End_Date; "End Date")
                {

                }
                column(Activity_Description; "Activity Description")
                {

                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
