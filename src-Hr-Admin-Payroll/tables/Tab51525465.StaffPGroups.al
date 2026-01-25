table 51525465 "Staff PGroups"
{
    fields
    {
        field(1; "Posting Group"; Code[10])
        {
            TableRelation = "Staff Posting Group";
        }
        field(2; "Code"; Code[10])
        {
            TableRelation = IF (Type = CONST(Earning)) Earnings
            ELSE
            IF (Type = CONST(Deduction)) Deductions;

            trigger OnValidate()
            begin
                if Type = Type::Earning then begin
                    if Get(Code) then begin
                        Description := EarningRec.Description;
                    end;
                end;

                if Type = Type::Deduction then begin
                    if Deduction.Get(Code) then begin
                        Description := Deduction.Description;
                    end;
                end;
            end;
        }
        field(3; "G/L Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(4; Description; Text[30])
        {
        }
        field(5; Type; Option)
        {
            OptionMembers = Earning,Deduction;
        }
        field(6; "GL Account Employer"; Code[10])
        {
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1; "Posting Group", "Code", Type)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        EarningRec: Record Earnings;
        Deduction: Record Deductions;
}