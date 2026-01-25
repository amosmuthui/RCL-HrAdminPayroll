page 51525324 "Applicant Card"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "HR Online Applicant";//;"Job Applicants";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            group(BIODATA)
            {
                Caption = 'Bio Data';
                field("No."; Rec."No.")
                {
                }
                field("Applicant Type"; Rec."Applicant Type")
                {
                    Editable = true;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        if Rec."Applicant Type" = Rec."Applicant Type"::Internal then
                            ShowInternalApplicant := true
                        else
                            ShowInternalApplicant := false;
                    end;
                }
                field("Employee No"; Rec."Employee No")
                {
                    Caption = 'Internal Applicant';
                    Editable = true;
                    Visible = ShowInternalApplicant;
                }
                field("First Name"; Rec."First Name")
                {
                }
                field("Middle Name"; Rec."Middle Name")
                {
                }
                field(Is_Active_Staff; Rec."Is Active Staff")
                {
                    Visible = false;
                }
                field("Last Name"; Rec."Last Name")
                {
                }
                field(Initials; Rec.Initials)
                {
                }
                field("ID Number"; Rec."ID Number")
                {
                }
                field(Gender; Rec.Gender)
                {
                }
                field(Citizenship; Rec.Citizenship)
                {
                }
                field(Employ; Rec.Employ)
                {
                    Caption = 'Employed';
                    Editable = false;
                }
            }
            group(PERSONAL)
            {
                Caption = 'Personal';
                field("Marital Status"; Rec."Marital Status")
                {
                }
                /*field("Ethnic Origin"; Rec. "Ethnic Origin")
                {
                }*/
                /*field(County; Rec.County)
                {
                }*/
                field(Disabled; Rec.Disabled)
                {
                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                }
                field(Age; Rec.Age)
                {
                }
            }
            group(COMMUNICATION)
            {
                Caption = 'Communication';
                field("Home Phone Number"; Rec."Home Phone Number")
                {
                }
                field("Postal Address"; Rec."Postal Address")
                {
                }
                field("Postal Address2"; Rec."Postal Address2")
                {
                }
                field("Postal Address3"; Rec."Postal Address3")
                {
                }
                field("Post Code"; Rec."Post Code")
                {
                }
                field("Residential Address"; Rec."Residential Address")
                {
                }
                field("Residential Address2"; Rec."Residential Address2")
                {
                }
                field("Residential Address3"; Rec."Residential Address3")
                {
                }
                field("Post Code2"; Rec."Post Code2")
                {
                }
                field("Cellular Phone Number"; Rec."Cellular Phone Number")
                {
                }
                field("Work Phone Number"; Rec."Work Phone Number")
                {
                }
                field("Ext."; Rec."Ext.")
                {
                }
                field("E-Mail"; Rec."Email Address"/*"E-Mail"*/)
                {
                }
                field("Fax Number"; Rec."Fax Number")
                {
                }
            }
            part("ACADEMIC RECORDS"; "Applicant Qualification")
            {
                //SubPageLink = "Applicant No." = FIELD("No.");
                SubPageLink = "Email Address" = Field("Email Address");
            }
            part("EMPLOYMENT HISTORY"; "Applicant Work Experience")
            {
                //SubPageLink = "Applicant No." = FIELD("No.");
                SubPageLink = "Applicant Email Address" = Field("Email Address");
            }
            part(REFEREES; "Applicant Referees")
            {
                //SubPageLink = No = FIELD("No.");
                SubPageLink = "Applicant Email" = Field("Email Address");
            }
            part(DOCUMENTS; "Applicant Documents")
            {
                //SubPageLink = "Applicant No" = FIELD("No.");
                SubPageLink = "Email Address" = Field("Email Address");
            }
            part("View/Comments"; "Applicant Comments/Views")
            {
                SubPageLink = "Applicant No" = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Talent Pools")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Candidate Talent Pools";
                RunPageLink = "Candidate Email" = field("Email Address");
            }
            action("Employ Applicant")
            {
                Caption = 'Employ Applicant';
            }
        }
    }

    var
        Employee: Record Employee;
        Applicants: Record Applicants;
        EmpQualifications: Record "Employee Qualification";
        AppQualifications: Record "Applicants Qualification";
        RNeeds: Record "Recruitment Needs";
        ShowInternalApplicant: Boolean;
}