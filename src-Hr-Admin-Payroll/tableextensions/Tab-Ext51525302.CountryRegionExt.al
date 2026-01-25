tableextension 51525302 "Country/Region Ext" extends "Country/Region"
{
    fields
    {
        field(51525300; "Country Currency"; Code[20])
        {
            Caption = 'Currency';
            TableRelation = "Currency";

            trigger OnValidate()
            var
                Employees: Record "Employee";
            begin
                Employees.reset;
                Employees.setrange("Payroll Country", "Code");
                Employees.ModifyAll("Payroll Currency", "Country Currency");
            end;
        }
        field(51525301; "Contractual Amount Type"; Option)
        {
            OptionCaption = 'Gross Pay,Basic Pay,Net Pay';
            OptionMembers = "Gross Pay","Basic Pay","Net Pay";

            trigger OnValidate()
            var
                Employees: Record "Employee";
            begin
                Employees.reset;
                Employees.setrange("Payroll Country", "Code");
                Employees.ModifyAll("Contractual Amount Type", "Contractual Amount Type");
            end;
        }
        field(51525302; "Is Payroll Country"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Internal Employement History" WHERE("Payroll Country" = FIELD(Code)));
        }

        field(51525303; "Retirement Benefit Table"; Code[50])
        {
            TableRelation = "Bracket Tables";
        }
    }

}
