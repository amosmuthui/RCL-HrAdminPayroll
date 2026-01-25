table 51525345 "Training Participants"
{
    fields
    {
        field(1; Participant; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Training Request"; Code[20])
        {
            Editable = false;
        }
        field(3; "Employee No"; Code[10])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if empl.Get("Employee No") then begin
                    "Employee Name" := empl."First Name" + ' ' + empl."Middle Name" + ' ' + empl."Last Name";
                    Department := empl."Global Dimension 2 Code";
                    Directorate := empl."Global Dimension 1 Code";
                    Designation := empl."Job Title";
                    Glsetup.Get;
                    //"Current Budget" := Glsetup."Current Budget";
                end;
            end;
        }
        field(4; "Employee Name"; Text[50])
        {
            Editable = true;
        }
        field(5; Department; Code[20])
        {
            Editable = false;
        }
        field(6; Designation; Text[100])
        {
            Editable = false;
        }
        field(7; "Submitted Report"; Boolean)
        {
        }
        field(8; "Need Source"; Option)
        {
            OptionCaption = ' ,Appraisal,Employee,HOD';
            OptionMembers = " ",Appraisal,Employee,HOD;

            trigger OnValidate()
            begin
                /*
                 IF "Need Source"<>"Need Source"::Appraisal THEN BEGIN
                 AppraisalTrainingNeeds.RESET;
                 AppraisalTrainingNeeds.SETRANGE(AppraisalTrainingNeeds."Development Need","Training Need Description")
                 IF AppraisalTrainingNeeds.FIND('-') THEN
                  "Employee No":=HODTrainingNeeds."Employee No";

                END ELSE BEGIN
                 HODTrainingNeeds.RESET;
                 HODTrainingNeeds.SETRANGE(HODTrainingNeeds.Description,"Training Need Description");
                 IF HODTrainingNeeds.FIND('-') THEN
                  "Employee No":=HODTrainingNeeds."Employee No";
                END;
                */

            end;
        }
        field(9; "Training Course"; Text[250])
        {
            Editable = true;

            trigger OnValidate()
            begin
                /*Train.Reset;
                Train.SetRange("Employee No.", Rec."Employee No");
                Train.SetRange("Current Budget", Rec."Current Budget");
                if Train.Find('-') then begin
                    "Per Diem" := Train."Per Diem";
                    "Ground Transport" := Train."Ground Transport";
                    "Air Ticket" := Train."Air Fare";
                    "Total Cost" := Train."Total Cost";
                    "Tuition Fee" := Train."Training Cost";
                    Venue := Train.Venue;
                    Trainer := Train.Trainers;
                end;*/
            end;
        }
        field(10; "Training  Description"; Text[250])
        {
            Editable = false;
        }
        field(11; Directorate; Code[20])
        {
        }
        field(12; "End Date"; Date)
        {
        }
        field(13; Attendance; Option)
        {
            OptionCaption = 'Attended,Not Attended';
            OptionMembers = Attended,"Not Attended";
        }
        field(14; "Per Diem"; Decimal)
        {
            trigger OnValidate()
            begin
                Validate("Total Cost");
            end;
        }
        field(15; "Tuition Fee"; Decimal)
        {
            trigger OnValidate()
            begin
                Validate("Total Cost");
            end;
        }
        field(16; "Air Ticket"; Decimal)
        {
            trigger OnValidate()
            begin
                Validate("Total Cost");
            end;
        }
        field(17; "Total Cost"; Decimal)
        {
            Editable = false;
            trigger OnValidate()
            begin
                "Total Cost" := "Per Diem" + "Tuition Fee" + "Air Ticket" + "Travel Docs Fees" + "Ground Transport";
            end;
        }
        field(18; "Travel Docs Fees"; Decimal)
        {
            trigger OnValidate()
            begin
                Validate("Total Cost");
            end;
        }
        field(19; "Ground Transport"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Validate("Total Cost");
            end;
        }
        field(20; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(21; Venue; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(22; Trainer; Text[150])
        {
            Caption = 'Trainer Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(23; "Current Budget"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Course Code"; Code[50])
        {
            TableRelation = "Training Master Plan Header"."No.";

            trigger OnValidate()
            var
                Course: Record "Training Master Plan Header";
            begin
                "Training Course" := '';
                "Training  Description" := '';
                if "Course Code" <> '' then begin
                    Course.Reset();
                    Course.SetRange("No.", "Course Code");
                    if Course.FindFirst() then begin
                        "Training Course" := Course.Title;
                        "Training  Description" := Course.Description;
                    end;
                end;
            end;
        }
        field(25; "Trainer Category"; Option)
        {
            OptionMembers = "Internal",Supplier;
        }
        field(26; "Trainer No."; Code[100])
        {
            TableRelation = IF ("Trainer Category" = CONST("Internal")) "Employee"
            ELSE
            IF ("Trainer Category" = CONST(Supplier)) "External Trainers";

            trigger OnValidate()
            var
                ExtTrainer: Record "External Trainers";
                InternalTrainer: Record Employee;
            begin
                Trainer := '';
                if "Trainer No." <> '' then begin
                    if "Trainer Category" = "Trainer Category"::"Internal" then begin
                        InternalTrainer.Reset();
                        InternalTrainer.SetRange("No.", "Trainer No.");
                        if InternalTrainer.FindFirst() then
                            Trainer := InternalTrainer."First Name" + ' ' + InternalTrainer."Middle Name" + ' ' + InternalTrainer."Last Name";
                    end;
                    if "Trainer Category" = "Trainer Category"::Supplier then begin
                        ExtTrainer.Reset();
                        ExtTrainer.SetRange("No.", "Trainer No.");
                        if ExtTrainer.FindFirst() then
                            Trainer := ExtTrainer.Name;
                    end;
                end;
            end;
        }
    }

    keys
    {
        key(Key1; Participant, "Training Request"/*"End Date"*/)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        empl: Record Employee;
        //HODTrainingNeeds: Record "HR Organisation";
        AppraisalTrainingNeeds: Record "Appraisal Development Needs";
        Glsetup: Record "General Ledger Setup";
    //Train: Record "Human Capital Development";
}