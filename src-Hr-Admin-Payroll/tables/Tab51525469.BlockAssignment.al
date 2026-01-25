table 51525469 "Block Assignment"
{
    fields
    {
        field(1; "Employee No"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Payment,Deduction,Saving Scheme,Loan,Informational';
            OptionMembers = Payment,Deduction,"Saving Scheme",Loan,Informational;
        }
        field(3; "Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST(Payment)) Earnings
            ELSE
            IF (Type = CONST(Deduction)) Deductions
            ELSE
            IF (Type = CONST(Loan)) "Loan Application"."Loan No" WHERE("Employee No" = FIELD("Employee No"));

            trigger OnValidate()
            begin
                if Type = Type::Payment then begin
                    if Earn.Get(Code) then
                        Description := Earn.Description;
                end;
                if Type = Type::Deduction then begin
                    if Ded.Get(Code) then
                        Description := Ded.Description;
                end;
            end;
        }
        field(4; Description; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Block; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Employee No", Type, "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Earn: Record Earnings;
        Ded: Record Deductions;
}