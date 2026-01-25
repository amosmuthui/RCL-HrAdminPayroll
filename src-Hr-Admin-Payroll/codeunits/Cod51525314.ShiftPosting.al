codeunit 51525314 "Shift Posting"
{
    procedure PostShift(ShiftNo: Code[20])
    var
        ShiftLine: Record "Shift Line";
    begin
        ShiftLine.SetRange("Shift No.", ShiftNo);
        if ShiftLine.IsEmpty then
            Error('You cannot post a shift without employees.');

        // Other cross-record validations here
    end;
}
