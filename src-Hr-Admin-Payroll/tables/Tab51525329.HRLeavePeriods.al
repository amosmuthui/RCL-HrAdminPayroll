table 51525329 "HR Leave Periods"
{
    Caption = 'Leave Periods';
    DrillDownPageID = "HR Leave Period List";
    LookupPageID = "HR Leave Period List";

    fields
    {
        field(1; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            NotBlank = true;

            trigger OnValidate()
            begin
                //"Period Description" := FORMAT("Starting Date",0,Text000);
                if "Starting Date" <> 0D then
                    "End Date" := CalcDate('1Y', "Starting Date");
                Validate("End Date");
            end;
        }
        field(2; "Period Description"; Text[100])
        {
            Caption = 'Name';
            Editable = true;
        }
        field(3; "New Fiscal Year"; Boolean)
        {
            Caption = 'New Fiscal Year';

            trigger OnValidate()
            begin
                //TESTFIELD("Date Locked",FALSE);
            end;
        }
        field(4; Closed; Boolean)
        {
            Caption = 'Closed';
            Editable = true;
        }
        field(5; "Date Locked"; Boolean)
        {
            Caption = 'Date Locked';
            Editable = false;
        }
        field(6; "Reimbursement Closing Date"; Boolean)
        {
        }
        field(8; "Period Code"; Code[10])
        {
        }
        field(9; "Date Time Closed"; DateTime)
        {
            Editable = false;
        }
        field(10; "Closed By"; Code[50])
        {
            Editable = false;
        }
        field(11; "End Date"; Date)
        {
            trigger OnValidate()
            begin
                if ("Starting Date" <> 0D) and ("End Date" <> 0D) and ("End Date" < "Starting Date") then
                    Error('End date should be later than start date');
            end;
        }
    }

    keys
    {
        key(Key1; "Starting Date", "Period Code")
        {
            Clustered = true;
        }
        key(Key2; "New Fiscal Year", "Date Locked")
        {
        }
        key(Key3; Closed)
        {
        }
        key(Key4; "Period Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //TESTFIELD(Description,FALSE);
        //UpdateAvgItems(3);
    end;

    trigger OnInsert()
    begin
        /*
        AccountingPeriod2 := Rec;
        IF AccountingPeriod2.FIND('>') THEN
          AccountingPeriod2.TESTFIELD(Description,FALSE);
        //UpdateAvgItems(1);
        */

    end;

    trigger OnModify()
    begin
        //UpdateAvgItems(2);
    end;

    trigger OnRename()
    begin
        /*
        TESTFIELD(Description,FALSE);
        AccountingPeriod2 := Rec;
        IF AccountingPeriod2.FIND('>') THEN
          AccountingPeriod2.TESTFIELD(Description,FALSE);
        //UpdateAvgItems(4);
        */

    end;

    var
        Text000: Label '<Month Text>';
        AccountingPeriod2: Record "Salary Scales";
    //InvtSetup: Record "Inventory Setuup";


    procedure UpdateAvgItems()
    begin
    end;
}