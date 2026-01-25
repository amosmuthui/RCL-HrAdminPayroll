codeunit 51525315 "Shift Compliance Mgmt."
{

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