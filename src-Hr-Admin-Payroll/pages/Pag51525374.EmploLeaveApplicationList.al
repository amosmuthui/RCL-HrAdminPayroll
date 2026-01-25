page 51525374 "Emplo Leave Application List"
{
    ApplicationArea = All;
    Caption = 'Employee Leave Applications List';
    CardPageID = "Leave Applications List";
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Employee Leave Application";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Employee No"; Rec."Employee No")
                {
                }
                field("Employee Name"; Rec."Employee Name")
                {
                }
                field("Application No"; Rec."Application No")
                {
                }
                field("Leave Type"; Rec."Leave Type")
                {
                }
                field("Days Applied"; Rec."Days Applied")
                {
                }
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("Application Date"; Rec."Application Date")
                {
                }
                field("Approved Days"; Rec."Approved Days")
                {
                }
                field("Leave Status"; Rec."Leave Status")
                {
                }
                field("Approved End Date"; Rec."Approved End Date")
                {
                }
                field("Approval Date"; Rec."Approval Date")
                {
                }
                field("Leave Allowance Payable"; Rec."Leave Allowance Payable")
                {
                }
                field(days; Rec.days)
                {
                }
                field("No. series"; Rec."No. series")
                {
                }
                field("Resumption Date"; Rec."Resumption Date")
                {
                }
                field(Status; Rec.Status)
                {
                    Editable = true;
                }
                field("Balance brought forward"; Rec."Balance brought forward")
                {
                }
                field("Leave Entitlment"; Rec."Leave Entitlment")
                {
                }
                field("Recalled Days"; Rec."Recalled Days")
                {
                }
                field("Total Leave Days Taken"; Rec."Total Leave Days Taken")
                {
                }
                field("Days Absent"; Rec."Days Absent")
                {
                }
                field("Leave balance"; Rec."Leave balance")
                {
                }
                field("Duties Taken Over By"; Rec."Duties Taken Over By")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Annual Leave Entitlement Bal"; Rec."Annual Leave Entitlement Bal")
                {
                }
                field("Mobile No"; Rec."Mobile No")
                {
                }
                field("Approved Start Date"; Rec."Approved Start Date")
                {
                }
                field("Leave Earned to Date"; Rec."Leave Earned to Date")
                {
                }
                field("Maturity Date"; Rec."Maturity Date")
                {
                }
                field("Date of Joining Company"; Rec."Date of Joining Company")
                {
                }
                field("Fiscal Start Date"; Rec."Fiscal Start Date")
                {
                }
                field("No. of Months Worked"; Rec."No. of Months Worked")
                {
                }
                field("Off Days"; Rec."Off Days")
                {
                }
                field("Department Code"; Rec."Department Code")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Contract No."; Rec."Contract No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}