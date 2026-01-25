report 51525381 "Shift Report"
{
    Caption = 'Shift Report';
    dataset
    {
        dataitem(ShiftHeader; "Shift Header")
        {
            column(No; "No.")
            {
            }
            column(ShiftDepartment; "Shift Department")
            {
            }
            column(ShiftStartDate; "Shift Start Date")
            {
            }
            column(ShiftEndDate; "Shift End Date")
            {
            }
            column(ShiftType; "Shift Type")
            {
            }
            column(Department; Department)
            {
            }
            column(Createdby; "Created by")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(SupervisorUserID; "Supervisor User ID")
            {
            }
            dataitem("Shift Line"; "Shift Line")
            {
                DataItemLink = "Shift No." = FIELD("No.");

                column(Employee_No_; "Employee No.")
                {

                }
                column(Employee_Name; "Employee Name")
                {

                }
                column(Meal_Order; "Meal Order")
                {

                }
                column(Meal_Order_Description; "Meal Order Description")
                {

                }
                column(Shift_Date; "Shift Date")
                {

                }
                column(Shift_Start_Time; "Shift Start Time")
                {

                }
                column(Shift_End_Time; "Shift End Time")
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
