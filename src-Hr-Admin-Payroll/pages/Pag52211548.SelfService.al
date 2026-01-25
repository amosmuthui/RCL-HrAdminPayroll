page 52211548 "Self Service"
{
    ApplicationArea = All;
    Caption = 'Self Service';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            part(Control8; "Common Headline")
            {
                ApplicationArea = Basic, Suite;
            }
            /* part(Control7; "Self Service Cues")
            {
            }
 */
            part(Control6; "Power BI Embedded Report Part")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action("Travelling Request")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Travelling Request';
                RunObject = Page "Travelling Request Lines";
            }
            action("Employee Travel Request")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Employee Travel Request';
                RunObject = Page "Employee Travel Request";
            }

            action("Accident / Incident Logs")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Accident / Incident Logs';
                RunObject = Page "Accident / Incident Logs List";
            }
            action("My Shifts")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'My Shifts';
                RunObject = Page "My Shifts";
            }
        }
    }
}
