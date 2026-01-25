table 51525408 "HR Lookup Values"
{
    DrillDownPageID = "HR Lookup Values List";
    LookupPageID = "HR Lookup Values List";

    fields
    {
        field(1; Type; Option)
        {
            OptionCaption = 'Religion,Language,Medical Scheme,Location,Contract Type,Qualification Type,Stages,Scores,Institution,Appraisal Type,Appraisal Period,Urgency,Succession,Security,Disciplinary Case Rating,Disciplinary Case,Disciplinary Action,Next of Kin,County,Grade,Checklist Item,Appraisal Sub Category,Appraisal Group Item,Transport Type,Training Cost Items,Training Category,Dependant,CompetenceValues,ShortListing Criteria,Qualification category,Category,Sub Tribe,Appointments,Allegations,Disability,Appraisal Perspective,Professional Body,Nationality';
            OptionMembers = Religion,Language,"Medical Scheme",Location,"Contract Type","Qualification Type",Stages,Scores,Institution,"Appraisal Type","Appraisal Period",Urgency,Succession,Security,"Disciplinary Case Rating","Disciplinary Case","Disciplinary Action","Next of Kin",County,Grade,"Checklist Item","Appraisal Sub Category","Appraisal Group Item","Transport Type","Training Cost Items","Training Category",Dependant,CompetenceValues,"ShortListing Criteria","Qualification category",Category,"Sub Tribe",Appointments,Allegations,Disability,"Appraisal Perspective","Professional Body",Nationality;
        }
        field(2; "Code"; Code[70])
        {
        }
        field(3; Description; Text[50])
        {
        }
        field(4; Remarks; Text[250])
        {
        }
        field(5; "Notice Period"; Date)
        {
        }
        field(6; Closed; Boolean)
        {
        }
        field(7; "Contract Length"; Integer)
        {
        }
        field(8; "Current Appraisal Period"; Boolean)
        {
        }
        field(9; "Disciplinary Case Rating"; Text[30])
        {
            TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Disciplinary Case Rating"));
        }
        field(10; "Disciplinary Action"; Code[20])
        {
            TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Disciplinary Action"));
        }
        field(14; From; Date)
        {
        }
        field(15; "To"; Date)
        {
        }
        field(16; Score; Decimal)
        {
        }
        field(17; "Basic Salary"; Decimal)
        {
        }
        field(18; "To be cleared by"; Code[10])
        {
            //TableRelation = Table50163.Field1;
        }
        field(50000; "Weight Scores"; Decimal)
        {
        }
        field(50001; "Job Scale"; Code[10])
        {
        }
        field(50002; "Next Period"; Boolean)
        {
        }
        field(50003; "Previous Job Position"; Boolean)
        {
        }
        field(50004; "Previous Job Position Order"; Integer)
        {
        }
        field(50005; "Previous Appraisal Period"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; Subject; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; Section; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'None,Qualification,Experience';
            OptionMembers = "None",Qualification,Experience;
        }
        field(50008; "Qualification Type Code"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Order"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; Dependant; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Type, "Code")
        {
            Clustered = true;
        }
        key(Key2; Description)
        {
        }
        /*key(Key3;'')
        {
            Enabled = false;
        }*/
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }
}