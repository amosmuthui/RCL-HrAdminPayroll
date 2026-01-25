table 51525357 "Candidate Talent Pools"
{
    Caption = 'Candidate Talent Pools';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Candidate Talent Pools";
    LookupPageId = "Candidate Talent Pools";

    fields
    {
        field(1; "Pool Code"; Code[250])
        {
            Caption = 'Pool Code';
            TableRelation = "Talent Pools".Code;

            trigger OnValidate()
            begin
                if "Pool Code" <> '' then begin
                    TalentPools.Reset();
                    TalentPools.SetRange(Code, "Pool Code");
                    if TalentPools.FindFirst() then
                        "Pool Description" := TalentPools.Description;
                end;
            end;
        }
        field(2; "Candidate Email"; Text[250])
        {
            Caption = 'Candidate Email';
            TableRelation = "HR Online Applicant"."Email Address";

            trigger OnValidate()
            begin
                if "Candidate Email" <> '' then begin
                    Applicant.Reset();
                    Applicant.SetRange("Email Address", "Candidate Email");
                    if Applicant.FindFirst() then
                        "Candidate Name" := Applicant."First Name" + ' ' + Applicant."Middle Name" + ' ' + Applicant."Last Name";
                end;
            end;
        }
        field(3; "Pool Description"; Text[250])
        {
            Caption = 'Pool Description';
            Editable = false;
        }
        field(4; "Candidate Name"; Text[250])
        {
            Caption = 'Candidate Name';
            Editable = false;
        }
        field(5; "Application No."; Code[100])
        {
            Caption = 'Application No.';
            TableRelation = "Job Applications".ApplicationNo;

            trigger OnValidate()
            begin
                if "Application No." <> '' then begin
                    JobApplications.Reset();
                    JobApplications.SetRange(ApplicationNo, "Application No.");
                    if JobApplications.FindFirst() then begin
                        "Candidate Email" := JobApplications."Applicant Email";
                        "Candidate Name" := JobApplications.ApplicantName;
                    end;
                end;
            end;
        }
    }
    keys
    {
        key(PK; "Pool Code", "Candidate Email")
        {
            Clustered = true;
        }
    }

    var
        Applicant: Record "HR Online Applicant";
        JobApplications: Record "Job Applications";
        TalentPools: Record "Talent Pools";
}