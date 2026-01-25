codeunit 51525302 "HR Leave Jnl.- Post Batch"
{
    TableNo = "HR Leave Journal Line";

    trigger OnRun()
    begin
        InsuranceJnlLine.Copy(Rec);
        Code;
        Rec := InsuranceJnlLine;
    end;

    var
        Text000: Label 'cannot exceed %1 characters';
        Text001: Label 'Journal Batch Name    #1##########\\';
        Text002: Label 'Checking lines        #2######\';
        Text003: Label 'Posting lines         #3###### @4@@@@@@@@@@@@@';
        Text004: Label 'A maximum of %1 posting number series can be used in each journal.';
        InsuranceJnlLine: Record "HR Leave Journal Line";
        InsuranceJnlTempl: Record "HR Leave Journal Template";
        InsuranceJnlBatch: Record "HR Leave Journal Batch";
        InsuranceReg: Record "HR Leave Register";
        InsCoverageLedgEntry: Record "HR Leave Ledger Entries";
        InsuranceJnlLine2: Record "HR Leave Journal Line";
        InsuranceJnlLine3: Record "HR Leave Journal Line";
        NoSeries: Record "No. Series" temporary;
        FAJnlSetup: Record "Human Resources Setup";
        InsuranceJnlPostLine: Codeunit "HR Leave Jnl.- Post Line";
        InsuranceJnlCheckLine: Codeunit "HR Leave Jnl.- Check Line";
        NoSeriesMgt: Codeunit "No. Series";
        NoSeriesMgt2: array[10] of Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        Window: Dialog;
        LineCount: Integer;
        StartLineNo: Integer;
        NoOfRecords: Integer;
        InsuranceRegNo: Integer;
        LastDocNo: Code[20];
        LastDocNo2: Code[20];
        LastPostedDocNo: Code[20];
        NoOfPostingNoSeries: Integer;
        PostingNoSeriesNo: Integer;

    procedure "Code"()
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
        JnlLineDim: Record "Journal Line Dimension2";
        TempJnlLineDim: Record "Journal Line Dimension2" temporary;
    begin
        with InsuranceJnlLine do begin
            SetRange("Journal Template Name", "Journal Template Name");
            SetRange("Journal Batch Name", "Journal Batch Name");
            if RecordLevelLocking then
                LockTable;
            // MESSAGE("Journal Template Name");
            InsuranceJnlTempl.Get("Journal Template Name");
            InsuranceJnlBatch.Get("Journal Template Name", "Journal Batch Name");
            if StrLen(IncStr(InsuranceJnlBatch.Name)) > MaxStrLen(InsuranceJnlBatch.Name) then
                InsuranceJnlBatch.FieldError(
                  Name,
                  StrSubstNo(
                    Text000,
                    MaxStrLen(InsuranceJnlBatch.Name)));

            if not Find('=><') then begin
                Commit;
                "Line No." := 0;
                exit;
            end;

            Window.Open(
              Text001 +
              Text002 +
              Text003);
            Window.Update(1, "Journal Batch Name");

            // Check lines
            LineCount := 0;
            StartLineNo := "Line No.";
            repeat
                LineCount := LineCount + 1;
                Window.Update(2, LineCount);
                JnlLineDim.SetRange("Table ID", DATABASE::"Insurance Journal Line");
                JnlLineDim.SetRange("Journal Template Name", "Journal Template Name");
                JnlLineDim.SetRange("Journal Batch Name", "Journal Batch Name");
                JnlLineDim.SetRange("Journal Line No.", "Line No.");
                JnlLineDim.SetRange("Allocation Line No.", 0);
                TempJnlLineDim.DeleteAll;
                //Comment
                //DimMgt.GetConsolidatedDimFilterByDimFilter(JnlLineDim,TempJnlLineDim);
                //
                InsuranceJnlCheckLine.RunCheck(InsuranceJnlLine, TempJnlLineDim);
                if Next = 0 then
                    Find('-');
            until "Line No." = StartLineNo;
            NoOfRecords := LineCount;

            //LedgEntryDim.LOCKTABLE;
            InsCoverageLedgEntry.LockTable;
            if RecordLevelLocking then
                if InsCoverageLedgEntry.Find('+') then;
            InsuranceReg.LockTable;
            if InsuranceReg.Find('+') then
                InsuranceRegNo := InsuranceReg."No." + 1
            else
                InsuranceRegNo := 1;

            // Post lines
            LineCount := 0;
            LastDocNo := '';
            LastDocNo2 := '';
            LastPostedDocNo := '';
            Find('-');
            repeat
                LineCount := LineCount + 1;
                Window.Update(3, LineCount);
                if NoOfRecords <> 0 then
                    Window.Update(4, Round(LineCount / NoOfRecords * 10000, 1));
                if not ("Leave Period" = '') and
                   (InsuranceJnlBatch."No. Series" <> '') and
                   ("Document No." <> LastDocNo2)
                then
                    TestField("Document No.", NoSeriesMgt.GetNextNo(InsuranceJnlBatch."No. Series", "Posting Date", false));
                LastDocNo2 := "Document No.";
                if "Posting No. Series" = '' then
                    "Posting No. Series" := InsuranceJnlBatch."No. Series"
                else
                    if not ("Leave Period" = '') then
                        if "Document No." = LastDocNo then
                            "Document No." := LastPostedDocNo
                        else begin
                            if not NoSeries.Get("Posting No. Series") then begin
                                NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                                if NoOfPostingNoSeries > ArrayLen(NoSeriesMgt2) then
                                    Error(
                                      Text004,
                                      ArrayLen(NoSeriesMgt2));
                                NoSeries.Code := "Posting No. Series";
                                NoSeries.Description := Format(NoOfPostingNoSeries);
                                NoSeries.Insert;
                            end;
                            LastDocNo := "Document No.";
                            Evaluate(PostingNoSeriesNo, NoSeries.Description);
                            "Document No." := NoSeriesMgt2[PostingNoSeriesNo].GetNextNo("Posting No. Series", "Posting Date", false);
                            LastPostedDocNo := "Document No.";
                        end;
                JnlLineDim.SetRange("Table ID", DATABASE::"Insurance Journal Line");
                JnlLineDim.SetRange("Journal Template Name", "Journal Template Name");
                JnlLineDim.SetRange("Journal Batch Name", "Journal Batch Name");
                JnlLineDim.SetRange("Journal Line No.", "Line No.");
                JnlLineDim.SetRange("Allocation Line No.", 0);
                TempJnlLineDim.DeleteAll;
                //Comment
                //DimMgt.GetConsolidatedDimFilterByDimFilter(JnlLineDim,TempJnlLineDim);
                InsuranceJnlPostLine.RunWithOutCheck(InsuranceJnlLine, TempJnlLineDim);
            until Next = 0;

            if InsuranceReg.Find('+') then;
            if InsuranceReg."No." <> InsuranceRegNo then
                InsuranceRegNo := 0;

            Init;
            "Line No." := InsuranceRegNo;

            // Update/delete lines
            if InsuranceRegNo <> 0 then begin
                if not RecordLevelLocking then begin
                    JnlLineDim.LockTable(true, true);
                    LockTable(true, true);
                end;
                InsuranceJnlLine2.CopyFilters(InsuranceJnlLine);
                InsuranceJnlLine2.SetFilter("Leave Period", '<>%1', '');
                if InsuranceJnlLine2.Find('+') then; // Remember the last line
                JnlLineDim.SetRange("Table ID", DATABASE::"Insurance Journal Line");
                JnlLineDim.CopyFilter("Journal Template Name", "Journal Template Name");
                JnlLineDim.CopyFilter("Journal Batch Name", "Journal Batch Name");
                JnlLineDim.SetRange("Allocation Line No.", 0);
                InsuranceJnlLine3.Copy(InsuranceJnlLine);
                if InsuranceJnlLine3.Find('-') then
                    repeat
                        JnlLineDim.SetRange("Journal Line No.", InsuranceJnlLine3."Line No.");
                        JnlLineDim.DeleteAll;
                        InsuranceJnlLine3.Delete;
                    until InsuranceJnlLine3.Next = 0;
                InsuranceJnlLine3.Reset;
                InsuranceJnlLine3.SetRange("Journal Template Name", "Journal Template Name");
                InsuranceJnlLine3.SetRange("Journal Batch Name", "Journal Batch Name");
                if not InsuranceJnlLine3.Find('+') then
                    if IncStr("Journal Batch Name") <> '' then begin
                        InsuranceJnlBatch.Get("Journal Template Name", "Journal Batch Name");
                        InsuranceJnlBatch.Delete;
                        //FAJnlSetup.IncInsuranceJnlBatchName(InsuranceJnlBatch);
                        InsuranceJnlBatch.Name := IncStr("Journal Batch Name");
                        if InsuranceJnlBatch.Insert then;
                        "Journal Batch Name" := InsuranceJnlBatch.Name;
                    end;

                InsuranceJnlLine3.SetRange("Journal Batch Name", "Journal Batch Name");
                if (InsuranceJnlBatch."No. Series" = '') and not InsuranceJnlLine3.Find('+') then begin
                    InsuranceJnlLine3.Init;
                    InsuranceJnlLine3."Journal Template Name" := "Journal Template Name";
                    InsuranceJnlLine3."Journal Batch Name" := "Journal Batch Name";
                    InsuranceJnlLine3."Line No." := 10000;
                    InsuranceJnlLine3.Insert;
                    InsuranceJnlLine3.SetUpNewLine(InsuranceJnlLine2);
                    InsuranceJnlLine3.Modify;
                end;
            end;
            //Not applicable in BC270
            /**if InsuranceJnlBatch."No. Series" <> '' then
                NoSeriesMgt.SaveNoSeries;
            if NoSeries.Find('-') then
                repeat
                    Evaluate(PostingNoSeriesNo, NoSeries.Description);
                    NoSeriesMgt2[PostingNoSeriesNo].SaveNoSeries;
                until NoSeries.Next = 0;**/

            Commit;
            Clear(InsuranceJnlCheckLine);
            Clear(InsuranceJnlPostLine);
        end;
        UpdateAnalysisView.UpdateAll(0, true);
        Commit;
    end;
}