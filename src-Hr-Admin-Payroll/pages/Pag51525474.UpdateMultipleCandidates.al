page 51525474 "Update Multiple Candidates"
{
    ApplicationArea = All;
    Caption = 'Update Multiple Candidates';
    PageType = List;
    SourceTable = "Job Applications";
    UsageCategory = Lists;
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTableView = sorting("Serial No.") order(ascending) where(Submitted = const(true));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Serial No."; Rec."Serial No.")
                { }
                field("Applicant Email"; Rec."Applicant Email")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Phone Number"; Rec."Mobile No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field(ApplicantName; Rec.ApplicantName)
                {
                    ToolTip = 'Specifies the value of the Applicant Name field.';
                }

                field("Screening Results"; Rec.ScreeningResults())
                {
                    Visible = ViewShortlisting;
                }
                field(Shortlist; Rec.Shortlist)
                {
                    Editable = Rec.Stage = Rec.Stage::Shortlisting;
                    Visible = ViewShortlisting;//Rec.Stage = Rec.Stage::Shortlisting;
                }
                field("Not Shortlisted"; Rec."Not Shortlisted")
                {
                    Editable = Rec.Stage = Rec.Stage::Shortlisting;
                    Visible = ViewShortlisting;//Rec.Stage = Rec.Stage::Shortlisting;
                }
                field("Shortlisting Comments"; Rec."Shortlisting Comments")
                {
                    Editable = Rec.Stage = Rec.Stage::Shortlisting;
                    Visible = ViewShortlisting;//Rec.Stage = Rec.Stage::Shortlisting;
                }
                field("Passed First Interview"; Rec."Passed First Interview")
                {
                    Editable = Rec.Stage = Rec.Stage::"First Interview";
                    Visible = ViewFirstInterview;//Rec.Stage = Rec.Stage::"First Interview";
                }
                field("Failed First Interview"; Rec."Failed First Interview")
                {
                    Editable = Rec.Stage = Rec.Stage::"First Interview";
                    Visible = ViewFirstInterview;//Rec.Stage = Rec.Stage::"First Interview";
                }
                field("First Interview Comments"; Rec."First Interview Comments")
                {
                    Editable = Rec.Stage = Rec.Stage::"First Interview";
                    Visible = ViewFirstInterview;//Rec.Stage = Rec.Stage::"First Interview";
                }
                field("Passed Due Diligence"; Rec."Passed Due Diligence")
                {
                    Editable = Rec.Stage = Rec.Stage::"Due Diligence";
                    Visible = VieewDueDiligence;//Rec.Stage = Rec.Stage::"Due Diligence";
                }
                field("Failed Due Diligence"; Rec."Failed Due Diligence")
                {
                    Editable = Rec.Stage = Rec.Stage::"Due Diligence";
                    Visible = VieewDueDiligence;//Rec.Stage = Rec.Stage::"Due Diligence";
                }
                field("Due Diligence Comments"; Rec."Due Diligence Comments")
                {
                    Editable = Rec.Stage = Rec.Stage::"Due Diligence";
                    Visible = VieewDueDiligence;//Rec.Stage = Rec.Stage::"Due Diligence";
                }
                field("Passed Second Interview"; Rec."Passed Second Interview")
                {
                    Editable = Rec.Stage = Rec.Stage::"Second Interview";
                    Visible = ViewSecondInterview;//Rec.Stage = Rec.Stage::"Second Interview";
                }
                field("Failed Second Interview"; Rec."Failed Second Interview")
                {
                    Editable = Rec.Stage = Rec.Stage::"Second Interview";
                    Visible = ViewSecondInterview;//Rec.Stage = Rec.Stage::"Second Interview";
                }
                field("Second Interview Comments"; Rec."Second Interview Comments")
                {
                    Editable = Rec.Stage = Rec.Stage::"Second Interview";
                    Visible = ViewSecondInterview;//Rec.Stage = Rec.Stage::"Second Interview";
                }
                field(Successful; Rec.Successful)
                {
                    Editable = Rec.Stage = Rec.Stage::Completed;
                    Visible = ViewSuccessful;//Rec.Stage = Rec.Stage::Completed;
                }
                field(Unsuccessful; Rec.Unsuccessful)
                {
                    Editable = Rec.Stage = Rec.Stage::Completed;
                    Visible = ViewSuccessful;//Rec.Stage = Rec.Stage::Completed;
                }
                field("Final Comments"; Rec."Final Comments")
                {
                    Editable = Rec.Stage = Rec.Stage::Completed;
                    Visible = ViewSuccessful;//Rec.Stage = Rec.Stage::Completed;
                }
                field("Talent Pool"; Rec."Talent Pool")
                { }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; /*"Document Attachment Factbox"*/"Attached Documents")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(Database::"Job Applications"),
                              "No." = FIELD(ApplicationNo);
            }
            systempart(Control1900383207; Links)
            {
                Visible = true;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ViewShortlisting := false;
        ViewFirstInterview := false;
        VieewDueDiligence := false;
        ViewSecondInterview := false;
        ViewSuccessful := false;

        RecruitmentNeed.Reset();
        RecruitmentNeed.SetRange("No.", Rec."Recruitment Need Code");
        if RecruitmentNeed.FindFirst() then begin
            if RecruitmentNeed."Current Stage" = RecruitmentNeed."Current Stage"::Shortlisting then begin
                ViewShortlisting := true;
                Rec.SetRange(Submitted, true);
            end;
            if RecruitmentNeed."Current Stage" = RecruitmentNeed."Current Stage"::"First Interview" then begin
                ViewFirstInterview := true;
                Rec.SetRange(Shortlist, true);
            end;
            if RecruitmentNeed."Current Stage" = RecruitmentNeed."Current Stage"::"Due Diligence" then begin
                VieewDueDiligence := true;
                if RecruitmentNeed."Applicable Interview(s)" = RecruitmentNeed."Applicable Interview(s)"::Oral then
                    Rec.SetRange(Shortlist, true)
                else
                    Rec.SetRange("Passed First Interview", true);
            end;
            if RecruitmentNeed."Current Stage" = RecruitmentNeed."Current Stage"::"Second Interview" then begin
                ViewSecondInterview := true;
                Rec.SetRange("Passed Due Diligence", true);
            end;
            if RecruitmentNeed."Current Stage" = RecruitmentNeed."Current Stage"::Completed then begin
                ViewSuccessful := true;
                Rec.SetRange("Passed Second Interview", true);
            end;
        end;
    end;

    var
        RecruitmentNeed: Record "Recruitment Needs";
        ViewShortlisting: Boolean;
        ViewFirstInterview: Boolean;
        VieewDueDiligence: Boolean;
        ViewSecondInterview: Boolean;
        ViewSuccessful: Boolean;
}