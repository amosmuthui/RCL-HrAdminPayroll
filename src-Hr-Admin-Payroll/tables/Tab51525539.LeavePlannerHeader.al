table 51525539 "Leave Planner Header"
{
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Employee.Get("Employee No.") then begin
                    "Employee Name" := Employee."Last Name" + ' ' + Employee."First Name" + ' ' + Employee."Middle Name";
                    "Job No." := Employee."Job No.";
                    "Job Grade" := Employee."Job Grade";
                    "Job Title" := Employee."Job Title";
                    "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                    /*"Shortcut Dimension 3 Code":=Employee."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code":=Employee."Shortcut Dimension 4 Code";
                    "Shortcut Dimension 5 Code":=Employee."Shortcut Dimension 5 Code";
                    "Shortcut Dimension 6 Code":=Employee."Shortcut Dimension 6 Code";
                    "Shortcut Dimension 7 Code":=Employee."Shortcut Dimension 7 Code";
                    "Shortcut Dimension 8 Code":=Employee."Shortcut Dimension 8 Code";*/
                    HRLeavePeriod.Reset;
                    HRLeavePeriod.SetRange(HRLeavePeriod.Closed, false);
                    if HRLeavePeriod.FindFirst then begin
                        "Leave Period" := HRLeavePeriod."Period Code";
                    end;
                end else begin
                    "Employee Name" := '';
                    "Job No." := '';
                    "Job Title" := '';
                    "Job Grade" := '';
                    "Job Description" := '';
                    "Leave Period" := '';
                    "Global Dimension 1 Code" := '';
                    "Global Dimension 2 Code" := '';
                    "Shortcut Dimension 3 Code" := '';
                    "Shortcut Dimension 4 Code" := '';
                    "Shortcut Dimension 5 Code" := '';
                    "Shortcut Dimension 6 Code" := '';
                    "Shortcut Dimension 7 Code" := '';
                    "Shortcut Dimension 8 Code" := '';
                end;

            end;
        }
        field(3; "Employee Name"; Text[150])
        {
            Caption = 'Employee Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Job Title"; Code[50])
        {
            Caption = 'Job Title';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Job Description"; Text[100])
        {
            Caption = 'Job Description';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Job Grade"; Code[20])
        {
            Caption = 'Job Grade';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; "Leave Type"; Code[50])
        {
            Caption = 'Leave Type';
            DataClassification = ToBeClassified;
        }
        field(21; "Leave Period"; Code[20])
        {
            Caption = 'Leave Period';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(49; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Description := UpperCase(Description);
            end;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(52; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(53; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(54; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(55; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(56; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(57; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(58; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center".Code;
        }
        field(70; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Released,Rejected';
            OptionMembers = Open,"Pending Approval",Released,Rejected;
        }
        field(99; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                Employee.Reset;
                Employee.SetRange(Employee."User ID", "User ID");
                if Employee.FindFirst then begin
                    Employee.TestField("Global Dimension 1 Code");
                    Employee.TestField("Global Dimension 2 Code");
                    "Employee No." := Employee."No.";
                    "Employee Name" := Employee."Last Name" + ' ' + Employee."Middle Name" + ' ' + Employee."First Name";
                    "Job No." := Employee."Job No.";
                    "Job Title" := Employee.Title;
                    "Job Grade" := Employee."Job Grade";
                    "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                    "Shortcut Dimension 3 Code" := Employee."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code" := Employee."Shortcut Dimension 4 Code";
                    "Shortcut Dimension 5 Code" := Employee."Shortcut Dimension 5 Code";
                    "Shortcut Dimension 6 Code" := Employee."Shortcut Dimension 6 Code";
                    "Shortcut Dimension 7 Code" := Employee."Shortcut Dimension 7 Code";
                    "Shortcut Dimension 8 Code" := Employee."Shortcut Dimension 8 Code";
                    HRLeavePeriod.Reset;
                    HRLeavePeriod.SetRange(HRLeavePeriod.Closed, false);
                    if HRLeavePeriod.FindFirst then begin
                        "Leave Period" := HRLeavePeriod."Period Code";
                    end;
                end;
            end;
        }
        field(100; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
        field(102; "Incoming Document Entry No."; Integer)
        {
            Caption = 'Incoming Document Entry No.';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record Employee;
        //LeaveAllowanceTable: Record "Leave Allowance Table";
        HRLeavePeriod: Record "HR Leave Periods";
}