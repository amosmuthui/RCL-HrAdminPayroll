page 51525507 "Internal Emp. History Card"
{
    ApplicationArea = All;
    Caption = 'Staff Movement Card';
    PageType = Card;
    SourceTable = "Internal Employement History";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Emp No."; Rec."Emp No.")
                {
                    ToolTip = 'Specifies the value of the Emp No. field.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Change Type field.';
                }
                field("First Date"; Rec."First Date")
                {
                    ToolTip = 'Specifies the value of the First Date field.';
                }
                field("Last Date"; Rec."Last Date")
                {
                    ToolTip = 'Specifies the value of the Last Date field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            group(Job)
            {
                Caption = 'Location and Position Changes';
                field("Workstation Country"; Rec."Workstation Country")
                {
                    ToolTip = 'Specifies the value of the Workstation Country field.';
                }
                field("Station Code"; Rec."Station Code")
                {
                    ToolTip = 'Specifies the value of the Station Name field.';
                }
                field("Station Title"; Rec."Station Title")
                {
                    ToolTip = 'Specifies the value of the Station Description field.';
                }
                field("Dept Code"; Rec."Dept Code")
                {
                    ToolTip = 'Specifies the value of the Dept Code field.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.';
                }
                field("Section Code"; Rec."Section Code")
                {
                    ToolTip = 'Specifies the value of the Section Code field.';
                }
                field("Section Title"; Rec."Section Title")
                {
                    ToolTip = 'Specifies the value of the Section Title field.';
                }
                field("Position Code"; Rec."Position Code")
                {
                    ToolTip = 'Specifies the value of the Position Code field.';
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title field.';
                }
            }
            group("Payroll")
            {
                Caption = 'Payroll Changes';
                Visible = CanEditPaymentInfo;
                field("Salary Scale"; Rec."Salary Scale")
                { }
                field("Next Seniority Date"; Rec."Next Seniority Date")
                { }
                field("Payroll Country"; Rec."Payroll Country")
                {
                    ToolTip = 'Specifies the value of the Payroll Country field.';
                }
                field("Payroll Currency"; Rec."Payroll Currency")
                {
                    ToolTip = 'Specifies the value of the Payroll Currency field.';
                }
                field("Contractual Amount Type"; Rec."Contractual Amount Type")
                {
                    ToolTip = 'Specifies the value of the Contractual Amount Type field.';
                }
                field("Contractual Amount Currency"; Rec."Contractual Amount Currency")
                {
                    ToolTip = 'Specifies the value of the Contractual Amount Currency field.';
                }
                field("Contractual Amount Value"; Rec."Contractual Amount Value")
                {
                    ToolTip = 'Specifies the value of the Contractual Amount Value field.';
                }
                field("No Transport Allowance"; Rec."No Transport Allowance")
                {
                    Tooltip = 'Does not earn transport allowance';
                }
                field("Applicable House Allowance (%)"; Rec."Applicable House Allowance (%)")
                {
                    Tooltip = 'For those who dont earn transport allowance';
                }

                field("Apply Paye Multiplier"; Rec."Apply Paye Multiplier")
                { }
                field("Paye Multiplier"; Rec."Paye Multiplier")
                { }
                field("Terminal Dues"; Rec."Terminal Dues")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Refresh Data")
            {
                //Caption = 'Employee Subscriptions';
                //Image = EmployeeAgreement;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                begin
                    //updateMovementDates();
                    if confirm('Current Key blank fields will be filled with data from Employee card. Do you want to proceed?') then begin
                        updateMovementCard(Rec."Emp No.");
                        if Confirm('Records updated successfully. Do you want to do the same for all active employee records?') then begin
                            Window.Open('Working on employee No. ##');
                            Employees.Reset();
                            Employees.SetRange(Status, Employees.Status::Active);
                            if Employees.FindSet() then
                                repeat
                                    Window.Update(0, Employees."No.");
                                    updateMovementCard(Employees."No.");
                                until Employees.Next() = 0;
                            Window.Close();
                            Message('Records updated successfully!');
                        end;
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        MovementFieldsEditable := true;
        MovementFieldsTooltip := '';

        CanEditCard := false;
        CanEditPaymentInfo := false;
        CanEditLeaveInfo := false;
        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        if UserSetup.FindFirst() then begin
            CanEditCard := UserSetup."Can Edit Emp Card";
            CanEditPaymentInfo := UserSetup."Can Edit Payroll Info";
            CanEditLeaveInfo := UserSetup."Can Edit Leave Entitlement";
        end;
        MovementFieldsEditable := CanEditCard;

        //If has movement entries with one being current, then update these fields there so make them uneditable here
        /*if (Rec."No." <> '') and (CanEditCard) then begin
            MovementRec.Reset();
            MovementRec.SetRange("Emp No.", Rec."No.");
            MovementRec.SetRange(Status, MovementRec.Status::Current);
            if MovementRec.FindFirst() then begin
                MovementFieldsEditable := false;
                MovementFieldsTooltip := 'Update the field on the current/new movement list';
            end;
        end;*/
        Rec.Validate("Position Code");
    end;

    var
        MovementRec: Record "Internal Employement History";
        MovementFieldsEditable: Boolean;
        MovementFieldsTooltip: Text;
        UserSetup: Record "User Setup";
        CanEditCard: Boolean;
        CanEditPaymentInfo: Boolean;
        CanEditLeaveInfo: Boolean;
        EmpRec: Record Employee;
        Employees: Record Employee;
        Window: Dialog;

    procedure updateMovementCard(EmpNo: Code[50])
    var
    begin
        EmpRec.Reset();
        EmpRec.SetRange("No.", EmpNo);
        if EmpRec.FindFirst() then begin
            MovementRec.Reset();
            MovementRec.SetRange("Emp No.", EmpNo);
            MovementRec.SetRange(Status, MovementRec.Status::Current);
            if MovementRec.FindFirst() then begin
                if (MovementRec."Position Code" = '') and (EmpRec.Position <> '') then begin
                    MovementRec."Position Code" := EmpRec.Position;
                    MovementRec.Validate("Position Code");
                end;
                if (MovementRec."Dept Code" = '') and (EmpRec."Responsibility Center" <> '') then begin
                    MovementRec."Dept Code" := EmpRec."Responsibility Center";
                    MovementRec.Validate("Dept Code");
                    MovementRec."Section Code" := EmpRec."Sub Responsibility Center";
                    MovementRec.Validate("Section Code");
                end;
                if (MovementRec."Station Code" = '') and (EmpRec.Station <> '') then begin
                    MovementRec."Station Code" := EmpRec.Station;
                    MovementRec.Validate("Station Code");
                end;
                if (MovementRec."Section Code" = '') and (EmpRec."Sub Responsibility Center" <> '') then begin
                    MovementRec."Dept Code" := EmpRec."Responsibility Center";
                    MovementRec.Validate("Dept Code");

                    MovementRec."Section Code" := EmpRec."Sub Responsibility Center";
                    MovementRec.Validate("Section Code");
                end;
                if (MovementRec."Salary Scale" = '') and (EmpRec."Salary Scale" <> '') then begin
                    MovementRec."Salary Scale" := EmpRec."Salary Scale";
                end;
                if (MovementRec."Next Seniority Date" = 0D) and (EmpRec."Next Seniority Date" <> 0D) then begin
                    MovementRec."Next Seniority Date" := EmpRec."Next Seniority Date";
                end;
                MovementRec.Modify(false);
            end;
        end;
    end;

    procedure updateMovementDates()
    var
        Mvt: Record "Internal Employement History";
        MvtPrev: Record "Internal Employement History";
    begin
        Mvt.Reset();
        Mvt.SetRange(Status, Mvt.Status::Current);
        Mvt.SetRange(Remarks, 'Formula Test');
        if Mvt.FindSet() then
            repeat
                if Mvt."First Date" < 20250101D then
                    Mvt."First Date" := 20250101D; //Any that falls before date 1 to go to date 1
                MvtPrev.Reset();
                MvtPrev.SetCurrentKey("No.");
                MvtPrev.SetRange("Emp No.", Mvt."Emp No.");
                MvtPrev.SetFilter("No.", '<>%1', Mvt."No.");
                MvtPrev.SetAscending("No.", true);
                if MvtPrev.FindLast() then begin
                    MvtPrev."Last Date" := CalcDate('-1D', Mvt."First Date");
                    MvtPrev.Modify();
                end;
                Mvt.Type := Mvt.Type::"Gross Adjustment due to New Pension Rate";
                Mvt.Remarks := 'Gross Adjustment due to New Pension Rate';
                Mvt.Modify(false);
            until Mvt.Next() = 0;
        Message('Adjustments done!');
    end;
}