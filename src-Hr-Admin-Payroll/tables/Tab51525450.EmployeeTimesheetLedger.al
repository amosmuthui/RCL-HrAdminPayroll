table 51525450 "Employee Timesheet Ledger"
{
    fields
    {
        field(1; "TS  No"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Employee No."; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(4; "Ledger No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(5; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Month; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; Year; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; Date; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                EmpTSLines.Reset;
                EmpTSLines.SetRange("TS  No", "TS  No");
                EmpTSLines.SetRange("Line No.", "Line No.");
                if EmpTSLines.FindFirst then begin
                    "Employee No." := EmpTSLines."Employee No.";
                    Month := EmpTSLines.Month;
                    Year := EmpTSLines.Year;
                    Description := Format(EmpTSLines."Global Dimension 2 Code");

                end;

                if "Non-Working Day" = false then begin
                    //**************UpdateTimesheetLeaveDays****************
                    HRLeaveLedger.Reset;
                    HRLeaveLedger.SetRange("Staff No.", "Employee No.");
                    HRLeaveLedger.SetRange("Leave Entry Type", HRLeaveLedger."Leave Entry Type"::Negative);
                    if HRLeaveLedger.FindFirst then begin
                        LStartDate := HRLeaveLedger."Leave Start Date";
                        LEndDate := HRLeaveLedger."Leave End Date";
                        //MESSAGE(FORMAT(LStartDate)+' and '+FORMAT(LEndDate));
                        if ((LStartDate <= Date) and (LEndDate >= Date)) = true then begin
                            Description := Format(HRLeaveLedger."Leave Type");
                            "Day Type" := "Day Type"::Leave;
                        end;
                    end;
                end;
            end;
        }
        field(9; Hours; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Non-Working Day"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Day Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Working Day,Weekend,Holiday,Leave,Other';
            OptionMembers = "Working Day",Weekend,Holiday,Leave,Other;
        }
        field(12; Day; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; Tasks; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(14; Balance; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Employee,Supervisor,Approved';
            OptionMembers = Employee,Supervisor,Approved;
        }
        field(16; "Apprv Status"; Option)
        {
            CalcFormula = Lookup("Employee Timesheet Lines"."Approval Status" WHERE("Line No." = FIELD("Line No."),
                                                                                     "TS  No" = FIELD("TS  No"),
                                                                                     "Employee No." = FIELD("Employee No.")));
            FieldClass = FlowField;
            OptionCaption = 'Employee,Supervisor,Approved';
            OptionMembers = Employee,Supervisor,Approved;
        }
        field(50000; "Processed for One Employee"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "TS  No", "Line No.", "Ledger No.", "Employee No.")
        {
            Clustered = true;
        }
        key(Key2; Date)
        {
        }
    }

    fieldgroups
    {
    }

    var
        EmployeeRec: Record Employee;
        DimensionValueRec: Record "Dimension Value";
        ResponsibilityCenter: Record "Responsibility Center";
        DimMgt: Codeunit DimensionManagement;
        Locations: Record Location;
        CompanyJobsRec: Record "Company Jobs";
        EmpTSLines: Record "Employee Timesheet Lines";
        HRLeaveLedger: Record "HR Leave Ledger Entries";
        //HRTimesheetCU: Codeunit "HR Employee Timesheet PS";
        LStartDate: Date;
        LEndDate: Date;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Employee, "Employee No.", FieldNumber, ShortcutDimCode);
        Rec.Modify;
    end;
}