page 51525337 "Employee Change Card"
{
    ApplicationArea = All;
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Employee Details,Approval Mgmt';
    SourceTable = "Change Request";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                }
                field("Emp No."; Rec."Emp No.")
                {
                    ShowMandatory = true;
                    Editable = Rec."Change Type" <> Rec."Change Type"::Onboarding;
                }
                field("First Name(Prev)"; Rec."First Name(Prev)")
                {
                }
                field("First Name"; Rec."First Name")
                {
                    ShowMandatory = true;
                }
                field("Middle Name(Prev)"; Rec."Middle Name(Prev)")
                {
                }
                field("Middle Name"; Rec."Middle Name")
                {
                }
                field("Last Name(Prev)"; Rec."Last Name(Prev)")
                {
                    ShowMandatory = true;
                }
                field("Last Name"; Rec."Last Name")
                {
                }
                field("Change Type"; Rec."Change Type")
                { }
                field("Summarized reasons for change"; Rec."Summarized reasons for change")
                {
                    MultiLine = true;
                    ShowMandatory = true;
                }
                field("Change Approval Status"; Rec."Change Approval Status")
                {
                    ToolTip = 'Specifies the value of the Change Approval Status field.', Comment = '%';
                }
            }
            group("Movement Changes")
            {
                field("Create New Movement"; Rec."Create New Movement")
                { }
                field("Movement Type"; Rec."Movement Type")
                { }
                field("Movement Start Date"; Rec."Movement Start Date")
                { }
                field("Prev Position"; Rec."Prev Position")
                {
                }
                field("Job Title(Prev)"; Rec."Job Title(Prev)")
                {
                }
                field("Position"; Rec.Position)
                {
                    ShowMandatory = true;
                }
                field("Job Title"; Rec."Job Title")
                {
                }
                field("Prev Workstation Country"; Rec."Prev Workstation Country")
                {
                }
                field("Workstation Country"; Rec."Workstation Country")
                {
                    ShowMandatory = true;
                }
                field("Prev Responsibility Center"; Rec."Prev Responsibility Center")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ShowMandatory = true;
                }
                field("Prev Sub Responsibility Center"; Rec."Prev Sub Responsibility Center")
                {
                }
                field("Sub Responsibility Center"; Rec."Sub Responsibility Center")
                {
                    ShowMandatory = true;
                }
                field("Prev Station"; Rec."Prev Station")
                {
                }

                field(Station; Rec.Station)
                {
                    ShowMandatory = true;
                }
            }
            group("Other Details")
            {
                field("Previous ID Number"; Rec."Previous ID Number")
                {
                }
                field("ID Number"; Rec."ID Number")
                {
                    ShowMandatory = true;
                }
                field("Prev Passport Number"; Rec."Prev Passport Number")
                {
                }

                field("Passport Number"; Rec."Passport Number")
                {
                    ShowMandatory = true;
                }
                field("Prev Sub Section"; Rec."Prev Sub Section")
                {
                }

                field("Sub Section"; Rec."Sub Section")
                {
                }

                field("Address(Prev)"; Rec."Address(Prev)")
                {
                }
                field(Address; Rec.Address)
                {
                }

                field("Personal Email(Prev)"; Rec."Personal Email(Prev)")
                {
                }
                field("Personal Email"; Rec."Personal Email")
                {
                }
                field("Company E-Mail(Prev)"; Rec."Company E-Mail(Prev)")
                {
                }
                field("Company E-Mail"; Rec."Company E-Mail")
                {
                    ShowMandatory = true;
                }
                field("Prevailing Country/Region Code"; Rec."Prevailing Country/Region Code")
                {
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field("Prev Religion"; Rec."Prev Religion")
                {
                }

                field(Religion; Rec.Religion)
                {
                }
                field("Prev Annual Leave Entitlement"; Rec."Prev Annual Leave Entitlement")
                {
                }

                field("Annual Leave Entitlement"; Rec."Annual Leave Entitlement")
                {
                }

                field("Prev No. of Children"; Rec."Prev No. of Children")
                {
                }
                field("No. of Children"; Rec."No. of Children")
                {
                }
                field("Prev Province"; Rec."Prev Province")
                {
                }
                field(Province; Rec.Province)
                {
                }

                field("Prev District"; Rec."Prev District")
                {
                }
                field(District; Rec.District)
                {
                }

                field("Prev Sector"; Rec."Prev Sector")
                {
                }
                field(Sector; Rec.Sector)
                {
                }

                field("Prev Cell"; Rec."Prev Cell")
                {
                }
                field(Cell; Rec.Cell)
                {
                }

                field("Prev Village"; Rec."Prev Village")
                {
                }
                field(Village; Rec.Village)
                {
                }

                field("Prev Plot No."; Rec."Prev Plot No.")
                {
                }
                field("Plot No."; Rec."Plot No.")
                {
                }

                field("Prev Street No."; Rec."Prev Street No.")
                {
                }
                field("Street No."; Rec."Street No.")
                {
                }

                field("Prev Date Of Birth"; Rec."Prev Date Of Birth")
                {
                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                    ShowMandatory = true;
                }

                field("Prev Date Of Join"; Rec."Prev Date Of Join")
                {
                }
                field("Date Of Join"; Rec."Date Of Join")
                {
                    ShowMandatory = true;
                }

                field("Prev Date of Appointment"; Rec."Prev Date of Appointment")
                {
                }
                field("Date of Appointment"; Rec."Date of Appointment")
                {
                    ShowMandatory = true;
                }

                field("Prev Date Of Leaving"; Rec."Prev Date Of Leaving")
                {
                }
                field("Date Of Leaving"; Rec."Date Of Leaving")
                {
                }
                field("Bank Account No.(Prev)"; Rec."Bank Account No.(Prev)")
                {
                    Visible = false;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    Visible = false;
                }
                field("Marital Status(Prev)"; Rec."Marital Status(Prev)")
                {
                }
                field("Marital Status"; Rec."Marital Status")
                {
                }
                field("KRA Pin(Prev)"; Rec."KRA Pin(Prev)")
                {
                    Visible = false;
                }
                field("KRA Pin"; Rec."KRA Pin")
                {
                    Visible = false;
                }
                field("NSSF No(Prev)"; Rec."NSSF No(Prev)")
                {
                    Caption = 'Prev Pension No.';
                }
                field("NSSF No"; Rec."NSSF No")
                {
                    Caption = 'Pension No.';
                }
                field("NHIF No(Prev)"; Rec."NHIF No(Prev)")
                {
                    Caption = 'Prev Medical No.';
                }
                field("NHIF No"; Rec."NHIF No")
                {
                    Caption = 'Medical No.';
                }
                field("Employment Type(Prev)"; Rec."Employment Type(Prev)")
                {
                }
                field("Employment Type"; Rec."Employment Type")
                {
                }
                field("Job Grade(Prev)"; Rec."Job Grade(Prev)")
                {
                }
                field("Job Grade"; Rec."Job Grade")
                {
                }
                field("Bank Code(Prev)"; Rec."Bank Code(Prev)")
                {
                    Visible = false;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    Visible = false;
                }
                field("Bank Branch Code(Prev)"; Rec."Bank Branch Code(Prev)")
                {
                    Visible = false;
                }
                field("Bank Branch Code"; Rec."Bank Branch Code")
                {
                    Visible = false;
                }
                field("Bank Name(Prev)"; Rec."Bank Name(Prev)")
                {
                    Visible = false;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    Visible = false;
                }
                field("Bank Brach Name(Prev)"; Rec."Bank Brach Name(Prev)")
                {
                    Visible = false;
                }
                field("Bank Brach Name"; Rec."Bank Brach Name")
                {
                    Visible = false;
                }
                field("Contract Start Date(Prev)"; Rec."Contract Start Date(Prev)")
                {
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                }
                field("Citizenship(Prev)"; Rec."Citizenship(Prev)")
                {
                }
                field(Citizenship; Rec.Citizenship)
                {
                }
                field("Contract End Date(Prev)"; Rec."Contract End Date(Prev)")
                {
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                }
                field("Ethnic Group(Prev)"; Rec."Ethnic Group(Prev)")
                {
                    Visible = false;
                }
                field("Ethnic Group"; Rec."Ethnic Group")
                {
                    Visible = false;
                }
                field("Phone Number(Prev)"; Rec."Phone Number(Prev)")
                {
                }
                field("Phone Number"; Rec."Phone Number")
                {
                }
                field("County(Prev)"; Rec."County(Prev)")
                {
                    Caption = 'County(Prev)';
                }
                field(County; Rec.County)
                {
                }
                field("Birth Date(Prev)"; Rec."Birth Date(Prev)")
                {
                }
                field("Birth Date"; Rec."Birth Date")
                {
                }
                field("Gender(Prev)"; Rec."Gender(Prev)")
                {
                }
                field(Gender; Rec.Gender)
                {
                    ShowMandatory = true;
                }
                field("Employment Date(Prev)"; Rec."Employment Date(Prev)")
                {
                }
                field("Employment Date"; Rec."Employment Date")
                {
                }
                field("Status(Prev)"; Rec."Status(Prev)")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Salary Scale(Prev)"; Rec."Salary Scale(Prev)")
                {
                }
                field("Salary Scale"; Rec."Salary Scale")
                {
                }
                field("Number Of Years(Prev)"; Rec."Number Of Years(Prev)")
                {
                }
                field("Number Of Years"; Rec."Number Of Years")
                {
                }
                field("USER ID"; Rec."USER ID")
                {
                }
                field("Datetime Created"; Rec."Datetime Created")
                { }
                field("Date Modified"; Rec."Date Modified")
                {
                }
                field("Time Modified"; Rec."Time Modified")
                {
                }
                field("Reason For Change"; Rec."Reason For Change")
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Attached Documents")
            {
                ApplicationArea = All;
                Caption = 'Applicant Attachments';
                SubPageLink = "Table ID" = CONST(51525286),
                              "No." = FIELD("Job Application No.");
            }
            part("Academic Attachments"; "Academic Certificates FactBox")
            {
                ApplicationArea = All;
                Caption = 'Academic Attachments';
                SubPageLink = "Email Address" = FIELD("Personal Email");
                ;
            }
            part("Professional Certificates"; "Professional Certs FactBox")
            {
                ApplicationArea = All;
                Caption = 'Professional Certificates';
                SubPageLink = "Email Address" = FIELD("Personal Email");
            }
            systempart(Control1900383207; Links)
            {
                Visible = true;
            }
            systempart(Control1905767507; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Employee Details")
            {
                Image = Users;

                action(DocAttach)
                {
                    ApplicationArea = All;
                    Caption = 'Attachments';
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal;
                    end;
                }
                action(Relatives)
                {
                    Caption = 'Relatives';
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Employee Relatives Changes";
                    RunPageLink = "Employee Change No." = FIELD("No.");
                }
                action(Dependants)
                {
                    Caption = 'Dependants';
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Employee Beneficiaries Line ch";
                    RunPageLink = "Employee Change Code" = FIELD("No.");
                }
                action("Next of Kin")
                {
                    Caption = 'Next of Kin';
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Employee Kin Lines - ch";
                    RunPageLink = "Employee Change Code" = FIELD("No.");
                }
                action("Employee Card")
                {
                    Caption = 'Employee Card';
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "HR Employee";
                    RunPageLink = "No." = FIELD("Emp No.");
                }
            }

            group("Approvals Mgmt")
            {
                action("Send Approval Request")
                {
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category5;
                    //PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CurrPage.Update(false);
                        if Rec."Change Type" <> Rec."Change Type"::Onboarding then
                            Rec.TestField("Emp No.");
                        Rec.TestField("Summarized reasons for change");
                        Rec.Testfield("First Name");
                        Rec.Testfield("Last Name");
                        if (Rec."Passport Number" = '') and (Rec."ID Number" = '') then
                            Error('Kindly provide either ID or Passport Number.');
                        Rec.Testfield("Date Of Birth");
                        Rec.Testfield("Date Of Join");
                        Rec.Testfield("Date of Appointment");
                        Rec.Testfield(Gender);
                        Rec.Testfield("Company E-Mail");
                        Rec.Testfield(Position);
                        Rec.Testfield("Responsibility Center");
                        Rec.Testfield("Sub Responsibility Center");
                        Rec.Testfield(Station);
                        Rec.Testfield("Workstation Country");

                        if Rec."Create New Movement" then
                            Rec.TestField("Movement Start Date");

                        if Rec."Change Approval Status" <> Rec."Change Approval Status"::Open then
                            Error('The status must be open!');

                        VarVariant := Rec;

                        if (Rec."Change Approval Status" <> Rec."Change Approval Status"::Open) and (Rec."Change Approval Status" <> Rec."Change Approval Status"::Rejected) then
                            Error('Document Status has to be open or rejected');
                        if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                            CustomApprovals.OnSendDocForApproval(VarVariant);

                    end;
                }
                action("Cancel Approval Request")
                {
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;
                    //PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CurrPage.Update(false);
                        if Rec."Change Approval Status" <> Rec."Change Approval Status"::"Pending Approval" then
                            Error('The status must be pending approval!');

                        //if "Change Approval Status" <> Rec."Change Approval Status"::Approved then begin
                        VarVariant := Rec;
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                        //end;
                        // ApprovalsMgmt.OnCancelPVApprovalRequest(Rec);
                    end;
                }
                action("Approval Entries")
                {
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category5;
                    //PromotedIsBig = true;
                    RunPageMode = View;

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId)
                    end;
                }
            }
            group(Action65)
            {
                Image = Dimensions;
                action("Update Employee")
                {
                    Visible = false;
                    ApplicationArea = Dimensions;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.TestField("Reason For Change");
                        if Confirm('Are you sure you want to modify this record?', true, false) = true then begin
                            Employees.Reset;
                            Employees.SetRange(Employees."No.", Rec."Emp No.");
                            if Employees.FindFirst then begin
                                Employees."First Name" := Rec."First Name";
                                Employees."Middle Name" := Rec."Middle Name";
                                Employees."Last Name" := Rec."Last Name";
                                Employees."Job Title" := Rec."Job Title";
                                Employees.Address := Rec.Address;
                                Employees."Company E-Mail" := Rec."Company E-Mail";
                                Employees."Bank Account No." := Rec."Bank Account No.";
                                Employees."Marital Status" := Rec."Marital Status";
                                Employees."PIN Number" := Rec."KRA Pin";
                                Employees."NHIF No." := Rec."NHIF No";
                                Employees."NSSF No." := Rec."NSSF No";
                                Employees."Emplymt. Contract Code" := Rec."Employment Type";
                                Employees."Job Grade" := Rec."Job Grade";
                                Employees."Bank Code" := Rec."Bank Code";
                                Employees."Bank Name" := Rec."Bank Name";
                                Employees."Contract Start Date" := Rec."Contract Start Date";
                                Employees.Citizenship := Rec.Citizenship;
                                Employees."Contract End Date" := Rec."Contract End Date";
                                Employees."Ethnic Group" := Rec."Ethnic Group";
                                Employees."Phone No." := Rec."Phone Number";
                                Employees."Birth Date" := Rec."Birth Date";
                                Employees.Status := Rec.Status;
                                //Employees.Gender := Rec.Gender;
                                if Rec.Gender = Rec.Gender::Female then
                                    Employees.Gender := "Employee Gender"::Female;
                                if Rec.Gender = Rec.Gender::Male then
                                    Employees.Gender := "Employee Gender"::Male;
                                Employees."Employment Date" := Rec."Employment Date";
                                Employees.Present := Rec."Number Of Years";
                                Employees."Salary Scale" := Rec."Salary Scale";
                                Employees.Modify;
                            end;
                            Rec.Updated := true;
                            Rec."Modified By" := UserId;
                            Rec."Date Modified" := Today;
                            Rec."Time Modified" := Time;
                            Message('Employee record has been updated.');
                        end;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        CurrPage.Editable(true);
        if (Rec."Change Approval Status" <> Rec."Change Approval Status"::Open) and (Rec."Change Approval Status" <> Rec."Change Approval Status"::Rejected) then
            CurrPage.Editable(false);
    end;

    var
        Employees: Record Employee;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CustomApprovals: Codeunit "Custom Approvals Mgmt HR";
        VarVariant: Variant;
}