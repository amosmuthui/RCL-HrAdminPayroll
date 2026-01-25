page 51525323 "Applicants List"
{
    ApplicationArea = All;
    CardPageID = "Applicant Card";
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "HR Online Applicant";//"Job Applicants";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                }
                field("Email Address"; Rec."Email Address")
                { }
                field("First Name"; Rec."First Name")
                {
                }
                field("Middle Name"; Rec."Middle Name")
                {
                }
                field("Last Name"; Rec."Last Name")
                {
                }
                field("Marital Status"; Rec."Marital Status")
                {
                }
                field("ID Number"; Rec."ID Number")
                {
                }
                field(Citizenship; Rec.Citizenship)
                {
                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                }
                field(Employ; Rec.Employ)
                {
                }
            }
        }
    }

    actions
    {
    }

    /*trigger OnOpenPage()
    var
    begin
        Window.Open('Updating records from portal. Please wait ##############################1', ApplicantEmail);
        HrOnlineApplicants.Reset();
        if HrOnlineApplicants.FindSet() then
            repeat
                Window.Update(1, HrOnlineApplicants."Email Address");
                JobApplicants.Reset();
                JobApplicants.SetRange("E-Mail", HrOnlineApplicants."Email Address");
                if JobApplicants.FindFirst() then begin
                    JobApplicants."First Name" := HrOnlineApplicants."First Name";
                    JobApplicants."Middle Name" := HrOnlineApplicants."Middle Name";
                    JobApplicants."Last Name" := HrOnlineApplicants."Last Name";
                    JobApplicants."E-Mail" := HrOnlineApplicants."Email Address";
                    JobApplicants.Gender := HrOnlineApplicants.Gender;
                    JobApplicants."2nd Skills Category" := HrOnlineApplicants."2nd Skills Category";
                    JobApplicants."3rd Skills Category" := HrOnlineApplicants."3rd Skills Category";
                    JobApplicants.Age := HrOnlineApplicants.Age;
                    JobApplicants."Applicant Type" := HrOnlineApplicants."Applicant Type";
                    JobApplicants."Cellular Phone Number" := HrOnlineApplicants."Cellular Phone Number";
                    JobApplicants.Citizenship := HrOnlineApplicants.Citizenship;
                    JobApplicants.City := HrOnlineApplicants.City;
                    JobApplicants.Comment := HrOnlineApplicants.Comment;
                    //JobApplicants."Country Code" := HrOnlineApplicants.Country;
                    JobApplicants.County := HrOnlineApplicants.County;
                    JobApplicants."Date Of Birth" := HrOnlineApplicants."Date Of Birth";
                    JobApplicants.DateEmployed := HrOnlineApplicants.DateEmployed;
                    JobApplicants."Disability Details" := HrOnlineApplicants."Disability Details";
                    JobApplicants."Disability Grade" := HrOnlineApplicants."Disability Grade";
                    JobApplicants.Disabled := HrOnlineApplicants.Disabled;
                    JobApplicants."Driving Licence" := HrOnlineApplicants."Driving Licence";
                    JobApplicants."Employee No" := HrOnlineApplicants."Employee No";
                    JobApplicants."Ethnic Origin" := HrOnlineApplicants."Ethnic Origin";
                    JobApplicants."Ext." := HrOnlineApplicants."Ext.";
                    JobApplicants."Home Phone Number" := HrOnlineApplicants."Home Phone Number";
                    JobApplicants."Health Assesment" := HrOnlineApplicants."Health Assesment";
                    JobApplicants."ID Number" := HrOnlineApplicants."ID Number";
                    JobApplicants.Initials := HrOnlineApplicants.Initials;
                    JobApplicants."Marital Status" := HrOnlineApplicants."Marital Status";
                    JobApplicants."Passport Number" := HrOnlineApplicants."Passport Number";
                    JobApplicants.Picture := HrOnlineApplicants.Picture;
                    JobApplicants."PIN Number" := HrOnlineApplicants."PIN Number";
                    JobApplicants."Post Code" := HrOnlineApplicants."Post Code";
                    JobApplicants."Post Code2" := HrOnlineApplicants."Post Code2";
                    JobApplicants."Postal Address" := HrOnlineApplicants."Postal Address";
                    JobApplicants."Postal Address2" := HrOnlineApplicants."Postal Address2";
                    JobApplicants."Postal Address3" := HrOnlineApplicants."Postal Address3";
                    JobApplicants."Previous Employee" := HrOnlineApplicants."Previous Employee";
                    JobApplicants."Primary Skills Category" := HrOnlineApplicants."Primary Skills Category";
                    JobApplicants.Region := HrOnlineApplicants.Region;
                    JobApplicants."Residential Address" := HrOnlineApplicants."Residential Address";
                    JobApplicants."Residential Address2" := HrOnlineApplicants."Residential Address2";
                    JobApplicants."Residential Address3" := HrOnlineApplicants."Residential Address3";
                    JobApplicants."Search Name" := HrOnlineApplicants."Search Name";
                    JobApplicants.Status := HrOnlineApplicants.Status;
                    JobApplicants.Modify();
                end else begin
                    JobApplicantInit.Reset();
                    JobApplicantInit.Init();
                    JobApplicantInit."No." := '';
                    JobApplicantInit."First Name" := HrOnlineApplicants."First Name";
                    JobApplicantInit."Middle Name" := HrOnlineApplicants."Middle Name";
                    JobApplicantInit."Last Name" := HrOnlineApplicants."Last Name";
                    JobApplicantInit."E-Mail" := HrOnlineApplicants."Email Address";
                    JobApplicantInit.Gender := HrOnlineApplicants.Gender;
                    JobApplicantInit."2nd Skills Category" := HrOnlineApplicants."2nd Skills Category";
                    JobApplicantInit."3rd Skills Category" := HrOnlineApplicants."3rd Skills Category";
                    JobApplicantInit.Age := HrOnlineApplicants.Age;
                    JobApplicantInit."Applicant Type" := HrOnlineApplicants."Applicant Type";
                    JobApplicantInit."Cellular Phone Number" := HrOnlineApplicants."Cellular Phone Number";
                    JobApplicantInit.Citizenship := HrOnlineApplicants.Citizenship;
                    JobApplicantInit.City := HrOnlineApplicants.City;
                    JobApplicantInit.Comment := HrOnlineApplicants.Comment;
                    //JobApplicantInit."Country Code" := HrOnlineApplicants.Country;
                    JobApplicantInit.County := HrOnlineApplicants.County;
                    JobApplicantInit."Date Of Birth" := HrOnlineApplicants."Date Of Birth";
                    JobApplicantInit.DateEmployed := HrOnlineApplicants.DateEmployed;
                    JobApplicantInit."Disability Details" := HrOnlineApplicants."Disability Details";
                    JobApplicantInit."Disability Grade" := HrOnlineApplicants."Disability Grade";
                    JobApplicantInit.Disabled := HrOnlineApplicants.Disabled;
                    JobApplicantInit."Driving Licence" := HrOnlineApplicants."Driving Licence";
                    JobApplicantInit."Employee No" := HrOnlineApplicants."Employee No";
                    JobApplicantInit."Ethnic Origin" := HrOnlineApplicants."Ethnic Origin";
                    JobApplicantInit."Ext." := HrOnlineApplicants."Ext.";
                    JobApplicantInit."Home Phone Number" := HrOnlineApplicants."Home Phone Number";
                    JobApplicantInit."Health Assesment" := HrOnlineApplicants."Health Assesment";
                    JobApplicantInit."ID Number" := HrOnlineApplicants."ID Number";
                    JobApplicantInit.Initials := HrOnlineApplicants.Initials;
                    JobApplicantInit."Marital Status" := HrOnlineApplicants."Marital Status";
                    JobApplicantInit."Passport Number" := HrOnlineApplicants."Passport Number";
                    JobApplicantInit.Picture := HrOnlineApplicants.Picture;
                    JobApplicantInit."PIN Number" := HrOnlineApplicants."PIN Number";
                    JobApplicantInit."Post Code" := HrOnlineApplicants."Post Code";
                    JobApplicantInit."Post Code2" := HrOnlineApplicants."Post Code2";
                    JobApplicantInit."Postal Address" := HrOnlineApplicants."Postal Address";
                    JobApplicantInit."Postal Address2" := HrOnlineApplicants."Postal Address2";
                    JobApplicantInit."Postal Address3" := HrOnlineApplicants."Postal Address3";
                    JobApplicantInit."Previous Employee" := HrOnlineApplicants."Previous Employee";
                    JobApplicantInit."Primary Skills Category" := HrOnlineApplicants."Primary Skills Category";
                    JobApplicantInit.Region := HrOnlineApplicants.Region;
                    JobApplicantInit."Residential Address" := HrOnlineApplicants."Residential Address";
                    JobApplicantInit."Residential Address2" := HrOnlineApplicants."Residential Address2";
                    JobApplicantInit."Residential Address3" := HrOnlineApplicants."Residential Address3";
                    JobApplicantInit."Search Name" := HrOnlineApplicants."Search Name";
                    JobApplicantInit.Status := HrOnlineApplicants.Status;
                    JobApplicantInit.Insert(true);
                end;
            until HrOnlineApplicants.Next() = 0;
        Window.Close();
    end;*/

    var
        Window: Dialog;
        ApplicantEmail: Text;
        HrOnlineApplicants: Record "HR Online Applicant";
        JobApplicants: Record "Job Applicants";
        JobApplicantInit: Record "Job Applicants";
}