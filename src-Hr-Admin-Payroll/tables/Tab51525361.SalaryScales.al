table 51525361 "Salary Scales"
{
    DrillDownPageID = "Salary Scales List";
    LookupPageID = "Salary Scales List";

    fields
    {
        field(1; Scale; Code[10])
        {
        }
        field(2; "Minimum Pointer"; Code[10])
        {
            Caption = 'Minimum Notch';
            TableRelation = "Salary Pointers"."Salary Pointer";
        }
        field(3; "Maximum Pointer"; Code[10])
        {
            Caption = 'Maximum Notch';
            TableRelation = "Salary Pointers"."Salary Pointer";
        }
        field(4; "Responsibility Allowance"; Decimal)
        {
        }
        field(5; "Commuter Allowance"; Decimal)
        {
        }
        field(6; "In Patient Limit"; Decimal)
        {
            Editable = false;
        }
        field(7; "Out Patient Limit"; Decimal)
        {
            Editable = false;
        }
        field(8; "Grade Identifier"; Code[20])
        {
            TableRelation = "Grade Identifier Tables";
        }
        field(9; "Medical Cover Category"; Code[10])
        {
            TableRelation = "Medical Cover Category";

            trigger OnValidate()
            begin
                if MedCat.Get("Medical Cover Category") then begin
                    "In Patient Limit" := MedCat.Inpatient;
                    "Out Patient Limit" := MedCat.Outpatient;
                end else begin
                    "In Patient Limit" := MedCat.Inpatient;
                    "Out Patient Limit" := MedCat.Outpatient;

                end;
            end;
        }
        field(50001; "Basic Pay int"; Integer)
        {
        }
        field(50002; "Basic Pay"; Decimal)
        {
        }
        field(50003; "Seniority Percent (%)"; Decimal)
        {

        }
    }

    keys
    {
        key(Key1; Scale)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Scale, "Minimum Pointer", "Maximum Pointer")
        {
        }
    }

    var
        MedCat: Record "Medical Cover Category";
}