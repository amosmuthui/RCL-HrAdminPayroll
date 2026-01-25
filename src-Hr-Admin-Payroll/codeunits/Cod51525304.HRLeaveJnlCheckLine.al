codeunit 51525304 "HR Leave Jnl.- Check Line"
{
    trigger OnRun()
    begin
        /*GLSetup.GET;
        IF "Shortcut Dimension 1 Code" <> '' THEN BEGIN
          TempJnlLineDim."Table ID" := DATABASE::"HR Leave Journal Line";
          TempJnlLineDim."Journal Template Name" := "Journal Template Name";
          TempJnlLineDim."Journal Batch Name" := "Journal Batch Name";
          TempJnlLineDim."Journal Line No." := "Line No.";
          TempJnlLineDim."Dimension Code" := GLSetup."Global Dimension 1 Code";
          TempJnlLineDim."Dimension Value Code" := "Shortcut Dimension 1 Code";
          TempJnlLineDim.INSERT;
        END;
        IF "Shortcut Dimension 2 Code" <> '' THEN BEGIN
          TempJnlLineDim."Table ID" := DATABASE::"HR Leave Journal Line";
          TempJnlLineDim."Journal Template Name" := "Journal Template Name";
          TempJnlLineDim."Journal Batch Name" := "Journal Batch Name";
          TempJnlLineDim."Journal Line No." := "Line No.";
          TempJnlLineDim."Dimension Code" := GLSetup."Global Dimension 2 Code";
          TempJnlLineDim."Dimension Value Code" := "Shortcut Dimension 2 Code";
          TempJnlLineDim.INSERT;
        END;
        RunCheck(Rec,TempJnlLineDim);
        */

    end;

    var
        Text000: Label 'The combination of dimensions used in %1 %2, %3, %4 is blocked. %5';
        Text001: Label 'A dimension used in %1 %2, %3, %4 has caused an error. %5';
        GLSetup: Record "General Ledger Setup";
        FASetup: Record "Human Resources Setup";
        DimMgt: Codeunit DimensionManagement;
        CallNo: Integer;
        Text002: Label 'The Posting Date Must be within the open leave periods';
        Text003: Label 'The Posting Date Must be within the allowed Setup date';
        LeaveEntries: Record "HR Leave Ledger Entries";
        Text004: Label 'The Allocation of Leave days has been done for the period';


    procedure RunCheck(var InsuranceJnlLine: Record "HR Leave Journal Line"; var TempJnlLineDim: Record "Journal Line Dimension2" temporary)
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        with InsuranceJnlLine do begin
            if "Leave Entry Type" = "Leave Entry Type"::Negative then begin
                TestField("Leave Period");
            end;

            TestField("Document No.");
            TestField("Posting Date");
            TestField("Staff No.");
            CallNo := 1;

        end;

        ValidatePostingDate(InsuranceJnlLine);
    end;


    procedure ValidatePostingDate(var InsuranceJnlLine: Record "HR Leave Journal Line")
    begin
        with InsuranceJnlLine do begin
            if "Leave Entry Type" = "Leave Entry Type"::Negative then begin
                TestField("Leave Period");
            end;
            TestField("Document No.");
            TestField("Posting Date");
            TestField("Staff No.");
            /*IF ("Posting Date"<"Leave Period Start Date") OR
               ("Posting Date">"Leave Period End Date")  THEN
               ERROR(FORMAT(Text002));*/

            /*FASetup.GET();
            IF (FASetup."Leave Posting Period[FROM]"<>0D) AND (FASetup."Leave Posting Period[TO]"<>0D) THEN BEGIN
              IF ("Posting Date"<FASetup."Leave Posting Period[FROM]") OR
                 ("Posting Date">FASetup."Leave Posting Period[TO]")  THEN
                 ERROR(FORMAT(Text003));
            END;*/

            /*         LeaveEntries.RESET;
                LeaveEntries.SETRANGE(LeaveEntries."Leave Type","Leave Type");
               IF LeaveEntries.FIND('-') THEN BEGIN
            IF LeaveEntries."Leave Entry Type"=LeaveEntries."Leave Entry Type"::"Leave Allocation" THEN BEGIN
            IF (LeaveEntries."Posting Date"<"Leave Period Start Date") OR
                (LeaveEntries."Posting Date">"Leave Period End Date")  THEN
                ERROR(FORMAT(Text004));
                        END;
              END;
               */
        end;

    end;
}