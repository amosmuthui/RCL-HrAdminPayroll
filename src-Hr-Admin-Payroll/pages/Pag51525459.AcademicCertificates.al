page 51525459 "Academic Certificates"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Academic Certificates";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(CertificateID; Rec.CertificateID)
                {
                }
                field(CertificateName; Rec.CertificateName)
                {
                }
                field(EducationLevelID; Rec.EducationLevelID)
                {
                }
                field("Level Name"; Rec."Level Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}