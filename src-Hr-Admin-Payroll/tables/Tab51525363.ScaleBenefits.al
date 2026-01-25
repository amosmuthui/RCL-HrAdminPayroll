table 51525363 "Scale Benefits"
{
    fields
    {
        field(1; "Salary Scale"; Code[10])
        {
            Caption = 'Grade/Scale';
            TableRelation = "Salary Scales";
        }
        field(2; "Salary Pointer"; Code[10])
        {
            Caption = 'Notch';
            TableRelation = "Salary Pointers";
        }
        field(3; "ED Code"; Code[10])
        {
            NotBlank = true;
            TableRelation = Earnings;

            trigger OnValidate()
            begin
                if EarningRec.Get("ED Code") then begin
                    "ED Description" := EarningRec.Description;
                end;
            end;
        }
        field(4; Amount; Decimal)
        {
        }
        field(5; "ED Description"; Text[30])
        {
        }
        field(6; "G/L Account"; Code[20])
        {
        }
        field(7; "Payroll Country"; Code[200])
        {
            TableRelation = "Country/Region";
        }
        field(8; Currency; Code[50])
        {
            TableRelation = Currency;
        }
    }

    keys
    {
        key(Key1; "Salary Scale", "Salary Pointer"/*, "Payroll Country"/*"ED Code"*/)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Salary Pointer", "ED Code", "ED Description", Amount)
        {
        }
    }

    var
        EarningRec: Record Earnings;
}