table 51525333 "HR Appraisal Periods"
{

    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Period Start Date"; Date)
        {

            trigger OnValidate()
            begin
                if "Period Start Date" <> 0D then begin
                    "Mid Year Review Date" := CalcDate('6M', "Period Start Date");
                    "Period End Date" := CalcDate('1Y', "Period Start Date") - 1;
                end;
            end;
        }
        field(4; "Period End Date"; Date)
        {
        }
        field(5; Open; Boolean)
        {
        }
        field(6; "Close By"; Code[20])
        {
        }
        field(7; "Opened By"; Code[20])
        {
        }
        field(8; "Mid Year Review Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(9; "Allow Edits From"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Period Start Date" = 0D then Error('You must set the Period Start Date before setting allowable editing period.');
                if "Allow Edits From" < "Period Start Date" then Error('The allowable editing period cannot be earlier than the Period Start Date.');
            end;
        }
        field(10; "Allow Edits To"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Period End Date" = 0D then Error('You must set the Period End Date before setting allowable editing period.');
                if "Allow Edits To" > "Period End Date" then Error('The allowable editing period cannot be later than the Period End Date.');
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; Open)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        HRApp_Header.Reset;
        HRApp_Header.SetRange("Appraisal Period", Code);
        if not HRApp_Header.IsEmpty then begin
            Error('You cannot Delete this Period [ %1 ] because it is already in use in %2 Records',
                  Code, HRApp_Header.Count);
        end;
    end;

    trigger OnInsert()
    begin
        Open := true;
        /*if Code = '' then begin
            HRAppPeriod.Reset();
            if HRAppPeriod.FindLast then begin
                Code := IncStr(HRAppPeriod.Code)
            end else begin
                Code := 'PER-0001';
            end;
        end;*/
    end;

    var
        HRAppPeriod: Record "HR Appraisal Periods";
        HRApp_Header: Record "HR Appraisal Header";
}