codeunit 51525316 "Attendance Processo"
{
    procedure ProcessAttendance()
    var
        Staging: Record "Attendance Staging";
        Ledger: Record "Attendance Ledger";
    begin
        Staging.SetRange(Processed, false);

        if Staging.FindSet() then
            repeat
                CreateOrUpdateLedger(Staging);
                Staging.Processed := true;
                Staging.Modify();
            until Staging.Next() = 0;
    end;

    local procedure CreateOrUpdateLedger(Staging: Record "Attendance Staging")
    var
        Ledger: Record "Attendance Ledger";
    begin
        if not Ledger.Get(Staging."Employee No.", Staging."Log Date") then begin
            Ledger.Init();
            Ledger."Employee No." := Staging."Employee No.";
            Ledger."Attendance Date" := Staging."Log Date";
            Ledger."First In Time" := Staging."Log In Time";
            Ledger."Last Out Time" := Staging."Log Out Time";
            Ledger.Insert();
        end else begin
            if (Ledger."First In Time" = 0T) or
               (Staging."Log In Time" < Ledger."First In Time") then
                Ledger."First In Time" := Staging."Log In Time";

            if (Ledger."Last Out Time" = 0T) or
               (Staging."Log Out Time" > Ledger."Last Out Time") then
                Ledger."Last Out Time" := Staging."Log Out Time";

            Ledger.Modify();
        end;

        Ledger."Worked Hours" :=
            (Ledger."Last Out Time" - Ledger."First In Time") / 3600000;

        Ledger.Source := Ledger.Source::Biometric;
        Ledger.Status := EvaluateStatus(Ledger);
    end;


    local procedure EvaluateStatus(Ledger: Record "Attendance Ledger"): Enum "Attendance Status"
    begin
        if Ledger."Worked Hours" = 0 then
            exit("Attendance Status"::Absent);

        if Ledger."First In Time" > 090000T then
            exit("Attendance Status"::Late);

        exit("Attendance Status"::Present);
    end;
}
