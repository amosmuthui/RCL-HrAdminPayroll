page 51525363 "Comm Disciplinary Cases"
{
    ApplicationArea = All;
    CardPageID = "Disciplinary Cases Card";
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Disciplinary Cases";
    SourceTableView = WHERE("Case Status" = CONST(Committee));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Case No"; Rec."Case No")
                {
                }
                field("Case Description"; Rec."Case Description")
                {
                }
                field("Date of the Case"; Rec."Date of the Case")
                {
                }
                field("Offense Type"; Rec."Offense Type")
                {
                }
                field("Offense Name"; Rec."Offense Name")
                {
                }
                field("Employee No"; Rec."Employee No")
                {
                }
                field("Employee Name"; Rec."Employee Name")
                {
                }
                field("Case Status"; Rec."Case Status")
                {
                }
                field("HOD Name"; Rec."HOD Name")
                {
                }
                field("HOD Recommendation"; Rec."HOD Recommendation")
                {
                }
                field("HR Recommendation"; Rec."HR Recommendation")
                {
                }
                field("Commitee Recommendation"; Rec."Commitee Recommendation")
                {
                }
                field("Action Taken"; Rec."Action Taken")
                {
                }
                field(Appealed; Rec.Appealed)
                {
                }
                field("Committee Recon After Appeal"; Rec."Committee Recon After Appeal")
                {
                }
            }
        }
    }

    actions
    {
    }
}