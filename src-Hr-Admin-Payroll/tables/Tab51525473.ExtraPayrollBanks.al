table 51525473 "Extra Payroll Banks"
{
    Caption = 'Extra Payroll Banks';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Emp No."; Code[100])
        {
            Caption = 'Emp No.';
            Editable = false;

            trigger OnValidate()
            var
                Emp: Record Employee;
            begin
                if "Emp No." <> '' then begin
                    if Emp.Get("Emp No.") then
                        "Employee Name" := Emp."Last Name" + ' ' + Emp."First Name" + ' ' + Emp."Middle Name";
                end;
            end;
        }
        field(2; "Employee Name"; Text[240])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(3; "Payroll Period"; Date)
        {
            Caption = 'Payroll Period';
            Editable = false;
            TableRelation = "Payroll Period";
        }
        field(4; "Bank Country"; Code[100])
        {
            Caption = 'Bank Country';
            TableRelation = "Country/Region";

            trigger OnValidate()
            var
                Country: Record "Country/Region";
            begin
                //Currency := '';
                if ("Bank Country" <> '') and (Currency = '') then begin
                    Country.Reset();
                    Country.SetRange(Code, "Bank Country");
                    if Country.FindFirst() then
                        Currency := Country."Country Currency";
                end;
            end;
        }
        field(5; Currency; Code[100])
        {
            Caption = 'Currency';
            TableRelation = Currency;
            Editable = true;
        }
        field(6; "Bank Code"; Code[100])
        {
            Caption = 'Bank Code';
            TableRelation = "Bank Account";

            trigger OnValidate()
            var
                BankAccount: Record "Bank Account";
            begin
                "Bank Name" := '';
                if "Bank Code" <> '' then begin
                    if BankAccount.Get("Bank Code") then
                        "Bank Name" := BankAccount.Name;
                end;
            end;
        }
        field(7; "Bank Name"; Text[240])
        {
            Caption = 'Bank Name';
            Editable = false;
        }
        field(8; "Bank Account No"; Text[200])
        {
            Caption = 'Bank Account No';
        }
        field(9; "Branch Code"; Code[100])
        {
            Caption = 'Branch Code';
        }
        field(10; "Sort Code"; Text[200])
        {
            Caption = 'Sort Code';
        }
        field(11; Indicatif; Text[200])
        {
            Caption = 'Indicatif';
        }
        field(12; IBAN; Text[200])
        {
            Caption = 'IBAN';
        }
        field(13; "Code B.I.C."; Text[200])
        {
            Caption = 'Code B.I.C.';
        }
        field(14; "SWIFT Code"; Text[200])
        {
            Caption = 'Swift Code';
        }
        field(15; Amount; Decimal)
        { }
        field(16; "Branch Name"; Text[250])
        {
            Caption = 'Branch Name';
        }
    }
    keys
    {
        key(PK; "Emp No.", "Payroll Period", "Bank Code")
        {
            Clustered = true;
        }
    }
}