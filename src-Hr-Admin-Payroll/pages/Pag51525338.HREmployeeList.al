page 51525338 "HR Employee List"
{
    ApplicationArea = All;
    CardPageID = "HR Employee";
    PageType = List;
    UsageCategory = Lists;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            repeater(Control21)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies a number for the employee.';
                    StyleExpr = StyleText;
                }
                field("First Name"; Rec."First Name")
                {
                    ToolTip = 'Specifies the employee''s first name.';
                    StyleExpr = StyleText;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ToolTip = 'Specifies the employee''s middle name.';
                    StyleExpr = StyleText;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ToolTip = 'Specifies the employee''s last name.';
                    StyleExpr = StyleText;
                }
                field(Initials; Rec.Initials)
                {
                    ToolTip = 'Specifies the employee''s initials.';
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    StyleExpr = StyleText;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ToolTip = 'Specifies a search name for the employee.';
                    StyleExpr = StyleText;
                }
                field("User ID"; Rec."User ID")
                {
                    StyleExpr = StyleText;
                }
                field("MyID Eligibility"; Rec."MyID Eligibility")
                { }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the employee''s job title.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the postal code of the address.';
                    Visible = false;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the country/region code.';
                    Visible = true;
                }
                field("Payroll Country"; Rec."Payroll Country")
                {
                    ApplicationArea = BasicHR;
                    Visible = true;
                }
                field("Payment/Bank Country"; Rec."Payment/Bank Country")
                {
                    ApplicationArea = BasicHR;
                }
                field(Extension; Rec.Extension)
                {
                    ToolTip = 'Specifies the employee''s telephone extension.';
                    Visible = false;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the employee''s telephone number.';
                    Visible = false;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'Specifies the employee''s mobile telephone number.';
                    Visible = false;
                }
                field("Statistics Group Code"; Rec."Statistics Group Code")
                {
                    ToolTip = 'Specifies a statistics group code to assign to the employee for statistical purposes.';
                    Visible = false;
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ToolTip = 'Specifies a resource number for the employee, if the employee is a resource in Resources Planning.';
                    Visible = false;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies if a comment has been entered for this entry.';
                    Visible = false;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the employee''s email address.';
                    Visible = true;
                }
                field("Date Of Join"; Rec."Date Of Join")
                {
                }
                field("Date Of Leaving"; Rec."Date Of Leaving")
                {
                }
                field("Company E-Mail"; Rec."Company E-Mail")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control2; Links)
            {
                Visible = false;
            }
            systempart(Control1; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(ExportEmployeeImportantDates)
            {
                Caption = 'Export Employee Data';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Process;
                //RunObject = XMLport "Export Employee Data";
                Visible = false;

                trigger OnAction()
                begin
                    /*Filename:='';
                    HumanResourcesSetup.GET;
                    Filename:= HumanResourcesSetup."Path to Save Employee Data"+'EmployeeImportantDates.csv';
                    
                    EmployeeImportantDatesFile.CREATE(Filename);
                    EmployeeImportantDatesFile.CREATEOUTSTREAM(EmployeeImportantDatesFileStream);
                    XMLPORT.EXPORT(50001,EmployeeImportantDatesFileStream);
                    EmployeeImportantDatesFile.CLOSE; */

                end;
            }
            action(ImportEmployeeImportantDates)
            {
                Caption = 'Export/Import Employee Data';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                //RunObject = XMLport "Import Employee Data";
                RunObject = Report "Export Import Employee Data";
                Enabled = CanExportImportData;

                trigger OnAction()
                begin
                    /*Filename:='';
                    HumanResourcesSetup.GET;
                    Filename:= HumanResourcesSetup."Path to Save Employee Data"+'EmployeeImportantDates.csv';
                    
                    EmployeeImportantDatesFile.CREATE(Filename);
                    EmployeeImportantDatesFile.CREATEOUTSTREAM(EmployeeImportantDatesFileStream);
                    XMLPORT.EXPORT(50001,EmployeeImportantDatesFileStream);
                    EmployeeImportantDatesFile.CLOSE; */

                end;
            }
            action(ImportMovementImportantDates)
            {
                Caption = 'Export/Import Movement Data';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Export Import Movement Data";
            }
            action("Update Movement")
            {
                ApplicationArea = All;
                Caption = 'Create Initial Staff Movement';
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                //PromotedIsBig = true;
                //PromotedOnly = true;
                //Visible = false;
                ToolTip = 'Creates the initial entry in the staff movement table';
                Enabled = CanExportImportData;

                trigger OnAction()
                var
                    ExistingMovements: Record "Internal Employement History";
                    MovementInit: Record "Internal Employement History";
                    Emps: Record Employee;
                    Window: Dialog;
                    AssignmentMatrix: Record "Assignment Matrix";
                //PayPeriods: Record pa
                begin
                    Emps.Reset();
                    if Emps.FindSet() then begin
                        Window.OPEN('Processing staff movement data for Employee No. #######1');
                        repeat
                            Window.Update(1, Emps."No.");
                            ExistingMovements.Reset();
                            ExistingMovements.SetRange("Emp No.", Emps."No.");
                            if not ExistingMovements.FindFirst() then begin
                                MovementInit.Reset();
                                MovementInit.Init();
                                MovementInit."Emp No." := Emps."No.";
                                //MovementInit.Validate("Emp No.");
                                MovementInit."Employee Name" := Emps."First Name" + ' ' + Emps."Middle Name" + ' ' + Emps."Last Name";
                                MovementInit."Position Code" := Emps.Position;
                                MovementInit."Job Title" := Emps."Job Title";
                                MovementInit."Dept Code" := Emps."Responsibility Center";
                                MovementInit."Department Name" := Emps."Responsibility Center Name";
                                MovementInit."Section Code" := Emps."Sub Responsibility Center";
                                MovementInit.Validate("Section Code");
                                MovementInit."Station Code" := Emps.Station;
                                MovementInit.Validate("Station Code");
                                MovementInit."Workstation Country" := Emps."Workstation Country";
                                MovementInit."Payroll Country" := Emps."Payroll Country";
                                MovementInit."Payroll Currency" := Emps."Payroll Currency";
                                MovementInit.Type := MovementInit.Type::Initial;
                                MovementInit."Contractual Amount Currency" := Emps."Contractual Amount Currency";
                                MovementInit."Contractual Amount Type" := Emps."Contractual Amount Type";
                                MovementInit."Contractual Amount Value" := Emps."Assigned Gross Pay";
                                MovementInit."Apply Paye Multiplier" := Emps."Apply Paye Multiplier";
                                MovementInit."Paye Multiplier" := Emps."Paye Multiplier";
                                if Emps."Date Of Join" = 0D then begin
                                    Emps."Date Of Join" := Emps."Date of Appointment";
                                end;
                                MovementInit."First Date" := Emps."Date Of Join";
                                if MovementInit."First Date" = 0D then
                                    MovementInit."First Date" := 19000101D;
                                if Emps."Date Of Leaving" = 0D then
                                    Emps."Date Of Leaving" := Emps."Retirement Date";
                                MovementInit."Last Date" := Emps."Date Of Leaving";
                                if MovementInit."Last Date" = 0D then
                                    MovementInit."Last Date" := 20501231D;
                                MovementInit.Status := MovementInit.Status::Current;
                                MovementInit.Insert(true);
                            end else begin
                                if ((ExistingMovements.Type = ExistingMovements.Type::Initial) and (ExistingMovements.Status = ExistingMovements.Status::Current)) then begin
                                    //ExistingMovements.Validate("Emp No.");
                                    ExistingMovements."Employee Name" := Emps."First Name" + ' ' + Emps."Middle Name" + ' ' + Emps."Last Name";
                                    ExistingMovements."Position Code" := Emps.Position;
                                    ExistingMovements."Job Title" := Emps."Job Title";
                                    ExistingMovements."Dept Code" := Emps."Responsibility Center";
                                    ExistingMovements."Department Name" := Emps."Responsibility Center Name";
                                    ExistingMovements."Section Code" := Emps."Sub Responsibility Center";
                                    ExistingMovements.Validate("Section Code");
                                    ExistingMovements."Station Code" := Emps.Station;
                                    ExistingMovements.Validate("Station Code");
                                    ExistingMovements."Workstation Country" := Emps."Workstation Country";
                                    ExistingMovements."Payroll Country" := Emps."Payroll Country";
                                    ExistingMovements."Payroll Currency" := Emps."Payroll Currency";
                                    ExistingMovements."Contractual Amount Currency" := Emps."Contractual Amount Currency";
                                    ExistingMovements."Contractual Amount Type" := Emps."Contractual Amount Type";
                                    ExistingMovements."Contractual Amount Value" := Emps."Assigned Gross Pay";
                                    if Emps."Date Of Join" = 0D then begin
                                        Emps."Date Of Join" := Emps."Date of Appointment";
                                    end;
                                    ExistingMovements."First Date" := Emps."Date Of Join";
                                    if ExistingMovements."First Date" = 0D then
                                        ExistingMovements."First Date" := 19000101D;
                                    if Emps."Date Of Leaving" = 0D then
                                        Emps."Date Of Leaving" := Emps."Retirement Date";
                                    ExistingMovements."Last Date" := Emps."Date Of Leaving";
                                    if ExistingMovements."Last Date" = 0D then
                                        ExistingMovements."Last Date" := 20501231D;
                                    ExistingMovements."Apply Paye Multiplier" := Emps."Apply Paye Multiplier";
                                    ExistingMovements."Paye Multiplier" := Emps."Paye Multiplier";
                                    ExistingMovements.Modify(true);
                                end;
                            end;

                            //Update assignment matrix temporarily to capture the is flat amount
                            /*AssignmentMatrix.Reset();
                            AssignmentMatrix.SetRange("Employee No", Emps."No.");
                            AssignmentMatrix.SetRange("Payroll Period", 20230801D);
                            if AssignmentMatrix.FindSet() then
                                repeat
                                    AssignmentMatrix.Validate("Payroll Period");
                                    AssignmentMatrix.Modify();
                                until AssignmentMatrix.Next() = 0;*/
                            //Emps.Validate("Payroll Country");
                            Emps.Validate("No.");
                            Emps.Modify();
                        until Emps.Next() = 0;
                        Window.Close();
                        Message('Done');
                    end;

                end;
            }

        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Is Permanent" := true;
    end;

    trigger OnOpenPage()
    begin
        /*Perm.Reset;
        Perm.SetRange(Perm."USER ID", UserId);
        Perm.SetRange(Perm."View Payroll", true);
        if not Perm.Find('-') then
            Error('You Do Not Have Permission to View HR.');*/

        CanExportImportData := false;
        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        UserSetup.SetRange("Can Edit Emp Card", true);
        if UserSetup.FindFirst() then
            CanExportImportData := true;
    end;

    trigger OnAfterGetRecord()
    begin
        StyleText := 'None';
        if Rec.Status = Rec.Status::Inactive then
            StyleText := 'Attention';
    end;


    var
        //Perm: Record "Status Change Permission";
        EmployeeImportantDatesFile: File;
        EmployeeImportantDatesFileStream: OutStream;
        HumanResourcesSetup: Record "Human Resources Setup";
        Filename: Text;
        StyleText: Text[250];
        UserSetup: Record "User Setup";
        CanExportImportData: Boolean;
}