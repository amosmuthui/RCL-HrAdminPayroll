table 51525560 "Shift Line"
{

    DataClassification = CustomerContent;

    fields
    {
        field(1; "Shift No."; Code[20]) { }
        field(2; "Line No."; Integer) { }
        field(3; "Employee No."; Code[20]) { TableRelation = Employee; }

        field(4; "Employee Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Full Name" where("No." = field("Employee No.")));
        }
        field(5; "Shift Type"; Enum "Shift Type") { }
        field(6; "Task Assigned"; Text[100]) { }
        field(7; "Meal Order"; Code[100])
        {
            TableRelation = "Meal Order".Code;
        }
        field(8; "Night Shift"; Boolean) { }
        field(9; "Is Public Holiday"; Boolean) { }
        field(10; "Leave Allocated"; Boolean) { }
        field(11; "Shift Date"; Date) { }
        field(12; "Meal Order Description"; Text[300])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Meal Order"."Meal Orders" where("Meal Orders" = field("Meal Order")));

        }
        field(13; "Shift Start Time"; Time) { }
        field(14; "Shift End Time"; Time) { }
    }


    keys
    {
        key(PK; "Shift No.", "Line No.") { Clustered = true; }
    }

    local procedure ValidateNightShift(EmployeeNo: Code[20]; ShiftDate: Date)
    var
        ShiftLine: Record "Shift Line";
        WeekStart: Date;
        WeekEnd: Date;
    begin
        WeekStart := CalcDate('<-CW>', ShiftDate);
        WeekEnd := CalcDate('<+6D>', WeekStart);

        ShiftLine.SetRange("Employee No.", EmployeeNo);
        ShiftLine.SetRange("Shift Type", "Shift Type"::Night);
        ShiftLine.SetRange("Shift Date", WeekStart, WeekEnd);

        if ShiftLine.Count >= 3 then
            Error(
              'Employee %1 cannot be assigned more than 3 night shifts in a week.',
              EmployeeNo
            );
    end;

    trigger OnInsert()
    begin
        HandlePublicHoliday();
    end;

    trigger OnModify()
    begin
        HandlePublicHoliday();
    end;



    local procedure HandlePublicHoliday()
    begin
        if IsPublicHoliday("Employee No.", "Shift Date") then begin
            "Is Public Holiday" := true;
            "Leave Allocated" := true;
        end else begin
            "Is Public Holiday" := false;
            "Leave Allocated" := false;
        end;
    end;

    local procedure IsPublicHoliday(EmployeeNo: Code[20]; ShiftDate: Date): Boolean
    var
        CalendarMgmt: Codeunit "Calendar Management";
        CustomCalChange: Record "Customized Calendar Change" temporary;
        EmployeeRec: Record Employee;
        SourceVariant: Variant;
    begin
        if not EmployeeRec.Get(EmployeeNo) then
            exit(false);

        SourceVariant := EmployeeRec;
        CalendarMgmt.SetSource(SourceVariant, CustomCalChange);

        exit(CalendarMgmt.IsNonworkingDay(ShiftDate, CustomCalChange));
    end;
}

