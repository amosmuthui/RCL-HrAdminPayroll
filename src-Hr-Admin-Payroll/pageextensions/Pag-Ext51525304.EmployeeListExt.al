pageextension 51525304 "Employee List Ext." extends "Employee List"
{
    layout
    {
        addafter("Last Name")
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
            }
        }
        addafter("Job Title")
        {
            field("PTH Job Title"; Rec."PTH Job Title")
            {
                ApplicationArea = All;
            }
        }
    }
}
