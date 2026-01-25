table 51525359 "Training Allowance Batches"
{
    Caption = 'Training Allowance Batches';
    DataClassification = ToBeClassified;
    LookupPageId = "Training Allowance Batches";
    DrillDownPageId = "Training Allowance Batches";

    fields
    {
        field(1; "Payroll Period"; Date)
        {
            Editable = false;
            TableRelation = "Payroll Period";
            Caption = 'Payroll Period';
        }
        field(2; "Batch Name"; Code[50])
        {
            Editable = false;
            Caption = 'Batch Name';
        }
        field(3; Description; Text[250])
        {
            Editable = false;
            Caption = 'Description';
        }
        field(4; Status; Option)
        {
            Editable = false;
            Caption = 'Processing Status';
            OptionMembers = Open,"Sent to Payroll","Pending Amendment",Processing,Posted,Processed;
        }
        field(5; "Classes/Instructors"; Integer)
        {
            Editable = false;
            Caption = 'Classes/Instructors';
            FieldClass = FlowField;
            CalcFormula = count("Training Allowance Entries" where("Payroll Period" = field("Payroll Period")));
        }
        field(6; "Submitted By"; Code[200])
        {
            Editable = false;
            TableRelation = User;
        }
        field(7; "Submitted On"; DateTime)
        {
            Editable = false;
        }
        field(8; "Amendment Instructions"; Text[500])
        { }
        field(9; "Previous Amendments"; Text[1000])
        {
            Editable = false;
        }
        field(10; "Approval Status"; Option)
        {
            Caption = 'Approval Status';
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Rejected,Released';
            OptionMembers = Open,"Pending Approval",Rejected,Released;

        }
    }
    keys
    {
        key(PK; "Payroll Period")
        {
            Clustered = true;
        }
    }
}