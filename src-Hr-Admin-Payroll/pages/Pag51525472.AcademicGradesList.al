page 51525472 "Academic Grades List"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Academic Grades";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(GradeID; Rec.GradeID)
                {
                }
                field(GradeName; Rec.GradeName)
                {
                }
                field(CertificateID; Rec.CertificateID)
                {
                }
                field(EducationLevelID; Rec.EducationLevelID)
                {
                }
                field("Certificate Name"; Rec."Certificate Name")
                {
                }
                field("Education Level Name"; Rec."Education Level Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}