report 51525361 "Job Report"
{
    ApplicationArea = All;
    Caption = 'Job Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/JobReport.rdlc';
    dataset
    {
        dataitem(RecruitmentNeeds; "Recruitment Needs")
        {
            RequestFilterFields = "No.", "Responsibility Center", "Sub Responsibility Center";
            column(CompanyName; CompanyInformation.Name)
            {
            }
            column(CompanyAddress; CompanyInformation.Address)
            {
            }
            column(CompanyCity; CompanyInformation.City)
            {
            }
            column(CompanyPhone; CompanyInformation."Phone No.")
            {
            }
            column(CompanyPicture; CompanyInformation.Picture)
            {
            }
            column(CompanyPIN; CompanyInformation."P.I.N")
            {
            }
            column(CompanyPostCode; CompanyInformation."Post Code")
            {
            }
            column(CompanyAddress2; CompanyInformation."Address 2")
            {
            }
            column(ComapnyEmail; CompanyInformation."E-Mail")
            {
            }
            column(CompanyHomePage; CompanyInformation."Home Page")
            {
            }
            column(No; "No.")
            {
            }
            column(JobID; "Job ID")
            {
            }
            column(Description; Description)
            {
            }
            column(RequisitionType; "Requisition Type")
            {
            }
            column(ResponsibilityCenterName; "Responsibility Center Name")
            {
            }
            column(SubResponsibilityCenter; "Sub Responsibility Center")
            {
            }
            column(ReportingToDesc; "Reporting To(Desc)")
            {
            }
            column(ReasonforRecruitment; "Reason for Recruitment")
            {
            }
            column(Positions; Positions)
            {
            }
            column(StartDate; Format("Start Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(EndDate; Format("End Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(Status; Status)
            {
            }
            column(CurrentStage; "Current Stage")
            {
            }
            column(ShowShortlisted; ShowShortlisted)
            {
            }

            column(ShowUnshortlisted; ShowUnshortlisted)
            {
            }

            column(ShowPassedFirstInterview; ShowPassedFirstInterview)
            {
            }

            column(ShowFailedFirstInterview; ShowFailedFirstInterview)
            {
            }

            column(ShowPassedDueDiligence; ShowPassedDueDiligence)
            {
            }

            column(ShowFailedDueDiligence; ShowFailedDueDiligence)
            {
            }

            column(ShowPassedSecondInterview; ShowPassedSecondInterview)
            {
            }

            column(ShowFailedSecondInterview; ShowFailedSecondInterview)
            {
            }

            column(ShowSuccessful; ShowSuccessful)
            {
            }

            column(ShowUnsuccessful; ShowUnsuccessful)
            {
            }
            column(ShowAllApplicants; ShowAllApplicants)
            { }

            dataitem(ShowAllApplicantApps; "Job Applications")
            {
                DataItemLink = "Recruitment Need Code" = field("No.");
                DataItemTableView = where(Status = const(Submitted));

                column(ApplicationNo_ShowAllApplicantApps; ApplicationNo)
                { }
                column(ApplicantName_ShowAllApplicantApps; ApplicantName)
                { }
                column(Applicant_Email_ShowAllApplicantApps; "Applicant Email")
                { }
                column(Mobile_No_ShowAllApplicantApps; "Mobile No.")
                { }
                column(Shortlisting_Comments_ShowAllApplicantApps; "Shortlisting Comments")
                { }

                trigger OnPreDataItem()
                begin
                    if not ShowAllApplicants then
                        ShowAllApplicantApps.SetRange(ApplicationNo, 'USIONYESHE KITU');
                end;
            }

            dataitem(ShortlistedApps; "Job Applications")
            {
                DataItemLink = "Recruitment Need Code" = field("No.");
                DataItemTableView = where(Shortlist = const(true), Status = const(Submitted));

                column(ApplicationNo_ShortlistedApps; ApplicationNo)
                { }
                column(ApplicantName_ShortlistedApps; ApplicantName)
                { }
                column(Applicant_Email_ShortlistedApps; "Applicant Email")
                { }
                column(Mobile_No_ShortlistedApps; "Mobile No.")
                { }
                column(Shortlisting_Comments_ShortlistedApps; "Shortlisting Comments")
                { }

                trigger OnPreDataItem()
                begin
                    if not ShowShortlisted then
                        ShortlistedApps.SetRange(ApplicationNo, 'USIONYESHE KITU');
                end;
            }

            dataitem(UnShortlistedApps; "Job Applications")
            {
                DataItemLink = "Recruitment Need Code" = field("No.");
                DataItemTableView = where("Not Shortlisted" = const(true), Status = const(Submitted));

                column(ApplicationNo_UnShortlistedApps; ApplicationNo)
                { }
                column(ApplicantName_UnShortlistedApps; ApplicantName)
                { }
                column(Applicant_Email_UnShortlistedApps; "Applicant Email")
                { }
                column(Mobile_No_UnShortlistedApps; "Mobile No.")
                { }
                column(Shortlisting_Comments_UnShortlistedApps; "Shortlisting Comments")
                { }

                trigger OnPreDataItem()
                begin
                    if not ShowUnshortlisted then
                        UnShortlistedApps.SetRange(ApplicationNo, 'USIONYESHE KITU');
                end;
            }

            dataitem(PassedFirstInterviewApps; "Job Applications")
            {
                DataItemLink = "Recruitment Need Code" = field("No.");
                DataItemTableView = where("Passed First Interview" = const(true), Status = const(Submitted));

                column(ApplicationNo_PassedFirstInterviewApps; ApplicationNo)
                { }
                column(ApplicantName_PassedFirstInterviewApps; ApplicantName)
                { }
                column(Applicant_Email_PassedFirstInterviewApps; "Applicant Email")
                { }
                column(Mobile_No_PassedFirstInterviewApps; "Mobile No.")
                { }
                column(FirstInterview_Comments_PassedFirstInterviewApps; "First Interview Comments")
                { }

                trigger OnPreDataItem()
                begin
                    if not ShowPassedFirstInterview then
                        PassedFirstInterviewApps.SetRange(ApplicationNo, 'USIONYESHE KITU');
                end;
            }

            dataitem(FailedFirstInterviewApps; "Job Applications")
            {
                DataItemLink = "Recruitment Need Code" = field("No.");
                DataItemTableView = where("Failed First Interview" = const(true), Status = const(Submitted));

                column(ApplicationNo_FailedFirstInterviewApps; ApplicationNo)
                { }
                column(ApplicantName_FailedFirstInterviewApps; ApplicantName)
                { }
                column(Applicant_Email_FailedFirstInterviewApps; "Applicant Email")
                { }
                column(Mobile_No_FailedFirstInterviewApps; "Mobile No.")
                { }
                column(FirstInterview_Comments_FailedFirstInterviewApps; "First Interview Comments")
                { }

                trigger OnPreDataItem()
                begin
                    if not ShowFailedFirstInterview then
                        FailedFirstInterviewApps.SetRange(ApplicationNo, 'USIONYESHE KITU');
                end;
            }

            dataitem(PasseddueDiligenceApps; "Job Applications")
            {
                DataItemLink = "Recruitment Need Code" = field("No.");
                DataItemTableView = where("Passed Due Diligence" = const(true), Status = const(Submitted));

                column(ApplicationNo_PasseddueDiligenceApps; ApplicationNo)
                { }
                column(ApplicantName_PasseddueDiligenceApps; ApplicantName)
                { }
                column(Applicant_Email_PasseddueDiligenceApps; "Applicant Email")
                { }
                column(Mobile_No_PasseddueDiligenceApps; "Mobile No.")
                { }
                column(DueDiligence_Comments_PasseddueDiligenceApps; "Due Diligence Comments")
                { }

                trigger OnPreDataItem()
                begin
                    if not ShowPassedDueDiligence then
                        PasseddueDiligenceApps.SetRange(ApplicationNo, 'USIONYESHE KITU');
                end;
            }
            dataitem(FaileddueDiligenceApps; "Job Applications")
            {
                DataItemLink = "Recruitment Need Code" = field("No.");
                DataItemTableView = where("Failed Due Diligence" = const(true), Status = const(Submitted));

                column(ApplicationNo_FaileddueDiligenceApps; ApplicationNo)
                { }
                column(ApplicantName_FaileddueDiligenceApps; ApplicantName)
                { }
                column(Applicant_Email_FaileddueDiligenceApps; "Applicant Email")
                { }
                column(Mobile_No_FaileddueDiligenceApps; "Mobile No.")
                { }
                column(DueDiligence_Comments_FaileddueDiligenceApps; "Due Diligence Comments")
                { }

                trigger OnPreDataItem()
                begin
                    if not ShowFailedDueDiligence then
                        FaileddueDiligenceApps.SetRange(ApplicationNo, 'USIONYESHE KITU');
                end;
            }

            dataitem(PassedSecondInterview; "Job Applications")
            {
                DataItemLink = "Recruitment Need Code" = field("No.");
                DataItemTableView = where("Passed Second Interview" = const(true), Status = const(Submitted));

                column(ApplicationNo_PassedSecondInterview; ApplicationNo)
                { }
                column(ApplicantName_PassedSecondInterview; ApplicantName)
                { }
                column(Applicant_Email_PassedSecondInterview; "Applicant Email")
                { }
                column(Mobile_No_PassedSecondInterview; "Mobile No.")
                { }
                column(SecondInterviewComments_PassedSecondInterview; "Second Interview Comments")
                { }

                trigger OnPreDataItem()
                begin
                    if not ShowPassedSecondInterview then
                        PassedSecondInterview.SetRange(ApplicationNo, 'USIONYESHE KITU');
                end;
            }
            dataitem(FailedSecondInterview; "Job Applications")
            {
                DataItemLink = "Recruitment Need Code" = field("No.");
                DataItemTableView = where("Failed Second Interview" = const(true), Status = const(Submitted));

                column(ApplicationNo_FailedSecondInterview; ApplicationNo)
                { }
                column(ApplicantName_FailedSecondInterview; ApplicantName)
                { }
                column(Applicant_Email_FailedSecondInterview; "Applicant Email")
                { }
                column(Mobile_No_FailedSecondInterview; "Mobile No.")
                { }
                column(SecondInterviewComments_FailedSecondInterview; "Second Interview Comments")
                { }

                trigger OnPreDataItem()
                begin
                    if not ShowFailedSecondInterview then
                        FailedSecondInterview.SetRange(ApplicationNo, 'USIONYESHE KITU');
                end;
            }
            dataitem(UnsuccessfulApps; "Job Applications")
            {
                DataItemLink = "Recruitment Need Code" = field("No.");
                DataItemTableView = where(Unsuccessful = const(true), Status = const(Submitted));

                column(ApplicationNo_UnsuccessfulApps; ApplicationNo)
                { }
                column(ApplicantName_UnsuccessfulApps; ApplicantName)
                { }
                column(Applicant_Email_UnsuccessfulApps; "Applicant Email")
                { }
                column(Mobile_No_UnsuccessfulApps; "Mobile No.")
                { }
                column(FinalComments_UnsuccessfulApps; "Final Comments")
                { }

                trigger OnPreDataItem()
                begin
                    if not ShowUnsuccessful then
                        UnsuccessfulApps.SetRange(ApplicationNo, 'USIONYESHE KITU');
                end;
            }
            dataitem(SuccessfulApps; "Job Applications")
            {
                DataItemLink = "Recruitment Need Code" = field("No.");
                DataItemTableView = where(Successful = const(true), Status = const(Submitted));

                column(ApplicationNo_SuccessfulApps; ApplicationNo)
                { }
                column(ApplicantName_SuccessfulApps; ApplicantName)
                { }
                column(Applicant_Email_SuccessfulApps; "Applicant Email")
                { }
                column(Mobile_No_SuccessfulApps; "Mobile No.")
                { }
                column(FinalComments_SuccessfulApps; "Final Comments")
                { }

                trigger OnPreDataItem()
                begin
                    if not ShowSuccessful then
                        SuccessfulApps.SetRange(ApplicationNo, 'USIONYESHE KITU');
                end;
            }


            trigger OnAfterGetRecord()
            begin
                if not ComapnyInfoCaptured then
                    CompanyInformation.CalcFields(Picture)
                else
                    ComapnyInfoCaptured := true;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInformation.Get;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Show All Stages"; ShowAll)
                {
                    trigger OnValidate()
                    begin
                        ShowShortlisted := ShowAll;
                        ShowUnshortlisted := ShowAll;
                        ShowPassedFirstInterview := ShowAll;
                        ShowFailedFirstInterview := ShowAll;
                        ShowPassedDueDiligence := ShowAll;
                        ShowFailedDueDiligence := ShowAll;
                        ShowPassedSecondInterview := ShowAll;
                        ShowFailedSecondInterview := ShowAll;
                        ShowSuccessful := ShowAll;
                        ShowUnsuccessful := ShowAll;
                        ShowAllApplicants := ShowAll;
                    end;
                }
                field("Show All Applicants"; ShowAllApplicants)
                {
                    trigger OnValidate()
                    begin
                        if (not ShowShortlisted) and (ShowAll) then
                            ShowAll := false;
                        if (ShowShortlisted) and (ShowUnshortlisted) and
                        (ShowPassedFirstInterview) and (ShowFailedFirstInterview) and
                        (ShowPassedDueDiligence) and (ShowFailedDueDiligence) and
                        (ShowPassedSecondInterview) and (ShowFailedSecondInterview) and
                        (ShowSuccessful) and (ShowUnsuccessful) and (ShowAllApplicants) then begin
                            ShowAll := true;
                        end;
                    end;
                }
                field("Show Shortlisted"; ShowShortlisted)
                {
                    trigger OnValidate()
                    begin
                        if (not ShowShortlisted) and (ShowAll) then
                            ShowAll := false;
                        if (ShowShortlisted) and (ShowUnshortlisted) and
                        (ShowPassedFirstInterview) and (ShowFailedFirstInterview) and
                        (ShowPassedDueDiligence) and (ShowFailedDueDiligence) and
                        (ShowPassedSecondInterview) and (ShowFailedSecondInterview) and
                        (ShowSuccessful) and (ShowUnsuccessful) and (ShowAllApplicants) then begin
                            ShowAll := true;
                        end;
                    end;
                }

                field("Show Unshortlisted"; ShowUnshortlisted)
                {
                    trigger OnValidate()
                    begin
                        if (not ShowUnshortlisted) and (ShowAll) then
                            ShowAll := false;
                        if (ShowShortlisted) and (ShowUnshortlisted) and
                        (ShowPassedFirstInterview) and (ShowFailedFirstInterview) and
                        (ShowPassedDueDiligence) and (ShowFailedDueDiligence) and
                        (ShowPassedSecondInterview) and (ShowFailedSecondInterview) and
                        (ShowSuccessful) and (ShowUnsuccessful) and (ShowAllApplicants) then begin
                            ShowAll := true;
                        end;
                    end;
                }

                field("Show Passed First Interview"; ShowPassedFirstInterview)
                {
                    trigger OnValidate()
                    begin
                        if (not ShowPassedFirstInterview) and (ShowAll) then
                            ShowAll := false;
                        if (ShowShortlisted) and (ShowUnshortlisted) and
                        (ShowPassedFirstInterview) and (ShowFailedFirstInterview) and
                        (ShowPassedDueDiligence) and (ShowFailedDueDiligence) and
                        (ShowPassedSecondInterview) and (ShowFailedSecondInterview) and
                        (ShowSuccessful) and (ShowUnsuccessful) and (ShowAllApplicants) then begin
                            ShowAll := true;
                        end;
                    end;
                }

                field("Show Failed First Interview"; ShowFailedFirstInterview)
                {
                    trigger OnValidate()
                    begin
                        if (not ShowFailedFirstInterview) and (ShowAll) then
                            ShowAll := false;
                        if (ShowShortlisted) and (ShowUnshortlisted) and
                        (ShowPassedFirstInterview) and (ShowFailedFirstInterview) and
                        (ShowPassedDueDiligence) and (ShowFailedDueDiligence) and
                        (ShowPassedSecondInterview) and (ShowFailedSecondInterview) and
                        (ShowSuccessful) and (ShowUnsuccessful) and (ShowAllApplicants) then begin
                            ShowAll := true;
                        end;
                    end;
                }

                field("Show Passed Due Diligence"; ShowPassedDueDiligence)
                {
                    trigger OnValidate()
                    begin
                        if (not ShowPassedDueDiligence) and (ShowAll) then
                            ShowAll := false;
                        if (ShowShortlisted) and (ShowUnshortlisted) and
                        (ShowPassedFirstInterview) and (ShowFailedFirstInterview) and
                        (ShowPassedDueDiligence) and (ShowFailedDueDiligence) and
                        (ShowPassedSecondInterview) and (ShowFailedSecondInterview) and
                        (ShowSuccessful) and (ShowUnsuccessful) and (ShowAllApplicants) then begin
                            ShowAll := true;
                        end;
                    end;
                }

                field("Show Failed Due Diligence"; ShowFailedDueDiligence)
                {
                    trigger OnValidate()
                    begin
                        if (not ShowFailedDueDiligence) and (ShowAll) then
                            ShowAll := false;
                        if (ShowShortlisted) and (ShowUnshortlisted) and
                        (ShowPassedFirstInterview) and (ShowFailedFirstInterview) and
                        (ShowPassedDueDiligence) and (ShowFailedDueDiligence) and
                        (ShowPassedSecondInterview) and (ShowFailedSecondInterview) and
                        (ShowSuccessful) and (ShowUnsuccessful) and (ShowAllApplicants) then begin
                            ShowAll := true;
                        end;
                    end;
                }

                field("Show Passed Second Interview"; ShowPassedSecondInterview)
                {
                    trigger OnValidate()
                    begin
                        if (not ShowPassedSecondInterview) and (ShowAll) then
                            ShowAll := false;
                        if (ShowShortlisted) and (ShowUnshortlisted) and
                        (ShowPassedFirstInterview) and (ShowFailedFirstInterview) and
                        (ShowPassedDueDiligence) and (ShowFailedDueDiligence) and
                        (ShowPassedSecondInterview) and (ShowFailedSecondInterview) and
                        (ShowSuccessful) and (ShowUnsuccessful) and (ShowAllApplicants) then begin
                            ShowAll := true;
                        end;
                    end;
                }

                field("Show Failed Second Interview"; ShowFailedSecondInterview)
                {
                    trigger OnValidate()
                    begin
                        if (not ShowFailedSecondInterview) and (ShowAll) then
                            ShowAll := false;
                        if (ShowShortlisted) and (ShowUnshortlisted) and
                        (ShowPassedFirstInterview) and (ShowFailedFirstInterview) and
                        (ShowPassedDueDiligence) and (ShowFailedDueDiligence) and
                        (ShowPassedSecondInterview) and (ShowFailedSecondInterview) and
                        (ShowSuccessful) and (ShowUnsuccessful) and (ShowAllApplicants) then begin
                            ShowAll := true;
                        end;
                    end;
                }

                field("Show Successful"; ShowSuccessful)
                {
                    trigger OnValidate()
                    begin
                        if (not ShowSuccessful) and (ShowAll) then
                            ShowAll := false;
                        if (ShowShortlisted) and (ShowUnshortlisted) and
                        (ShowPassedFirstInterview) and (ShowFailedFirstInterview) and
                        (ShowPassedDueDiligence) and (ShowFailedDueDiligence) and
                        (ShowPassedSecondInterview) and (ShowFailedSecondInterview) and
                        (ShowSuccessful) and (ShowUnsuccessful) and (ShowAllApplicants) then begin
                            ShowAll := true;
                        end;
                    end;
                }

                field("Show Unsuccessful"; ShowUnsuccessful)
                {
                    trigger OnValidate()
                    begin
                        if (not ShowUnsuccessful) and (ShowAll) then
                            ShowAll := false;
                        if (ShowShortlisted) and (ShowUnshortlisted) and
                        (ShowPassedFirstInterview) and (ShowFailedFirstInterview) and
                        (ShowPassedDueDiligence) and (ShowFailedDueDiligence) and
                        (ShowPassedSecondInterview) and (ShowFailedSecondInterview) and
                        (ShowSuccessful) and (ShowUnsuccessful) and (ShowAllApplicants) then begin
                            ShowAll := true;
                        end;
                    end;
                }

            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
        trigger OnOpenPage()
        begin
            ShowAll := true;
            ShowAllApplicants := true;
            ShowShortlisted := true;
            ShowUnshortlisted := true;
            ShowPassedFirstInterview := true;
            ShowFailedFirstInterview := true;
            ShowPassedDueDiligence := true;
            ShowFailedDueDiligence := true;
            ShowPassedSecondInterview := true;
            ShowFailedSecondInterview := true;
            ShowSuccessful := true;
            ShowUnsuccessful := true;
        end;
    }
    var
        CompanyInformation: Record "Company Information";
        ComapnyInfoCaptured: Boolean;
        ShowAll: Boolean;
        ShowAllApplicants: Boolean;
        ShowShortlisted: Boolean;
        ShowUnshortlisted: Boolean;
        ShowPassedFirstInterview: Boolean;
        ShowFailedFirstInterview: Boolean;
        ShowPassedDueDiligence: Boolean;
        ShowFailedDueDiligence: Boolean;
        ShowPassedSecondInterview: Boolean;
        ShowFailedSecondInterview: Boolean;
        ShowSuccessful: Boolean;
        ShowUnsuccessful: Boolean;
}