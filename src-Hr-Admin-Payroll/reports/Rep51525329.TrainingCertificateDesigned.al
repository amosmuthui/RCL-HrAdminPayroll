report 51525329 "Training Certificate Designed"
{
    ApplicationArea = All;
    Caption = 'Training Certificate';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/TrainingCertificateDesigned.rdlc';
    dataset
    {
        dataitem(TrainingScheduleLines; "Training Schedule Lines")
        {
            column(CompanyPicture; CompanyInformation.Picture)
            {
            }
            column(ScheduleNo; "Schedule No.")
            {
            }
            column(EmpNo; "Emp No.")
            {
            }
            column(EmployeeName; "Employee Name")
            {
            }
            column(CourseName; UpperCase(CourseName))
            { }
            column(CourseType; UpperCase(CourseType))
            { }
            column(Validity; Validity)
            { }
            column(IssueDate; IssueDate)
            { }
            column(Location; Location)
            { }
            column(Signatory1Name; Signatory1Name)
            { }
            column(Signatory2Name; Signatory2Name)
            { }
            column(SerialNo; "Certificate Serial No.")
            { }
            column(signatory1Signature; Signatory1EmpRec."Employee Signature")
            { }
            column(TrainerSignature; EmpRec."Employee Signature"/*TempBlobTable.Blob*/)
            { }

            trigger OnPreDataItem()
            begin
                CompanyInformation.Get;
            end;

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.CalcFields(Picture);

                /*if "Legacy Data" then
                    SerialNo := "Certificate Serial No.";*/
                Class.Reset();
                Class.SetRange("No.", "Schedule No.");
                if Class.FindFirst() then begin
                    if Class."End Date" <> 0D then
                        IssueDate := Format(Class."End Date", 0, '<Day,2> <Month Text> <Year4>');
                    Location := Class."Training Location";
                    CourseName := Class."Training Title"; //As it was called then
                    if Format(Class.Frequency) <> '' then
                        Validity := FinalDuesTable.ConvertDateFormulaToText(Format(Class.Frequency));
                    Signatory1Name := Class."Talent Development Specialist";
                    Signatory2Name := Class."Trainer Name";

                    if Class."Talent Dev. No." <> '' then begin
                        Signatory1EmpRec.Reset();
                        Signatory1EmpRec.SetRange("No.", Class."Talent Dev. No.");
                        if Signatory1EmpRec.FindFirst() then
                            Signatory1EmpRec.CalcFields("Employee Signature");
                    end;

                    IF (Class."Trainer Category" = Class."Trainer Category"::Internal) then begin
                        EmpRec.Reset();
                        EmpRec.SetRange("No.", Class."Trainer No.");
                        if EmpRec.FindFirst() then begin
                            EmpRec.CalcFields("Employee Signature");
                            /*TempBlobTable.Reset();
                            TempBlobTable.Init();
                            TempBlobTable."Primary Key" := TempBlobUniqueKey;
                            TempBlobTable.Blob := EmpRec."Employee Signature";
                            if not TempBlobTable.Insert() then
                                TempBlobTable.Modify();*/
                            /*if EmpRec."Employee Signature".HasValue then begin
                                EmpRec."Employee Signature".CreateInStream(InStr);
                                TempBlobTable.Blob.CreateOutStream(OutStr);
                                CopyStream(OutStr, InStr);
                                TempBlobTable.Insert();
                            end;*/
                            //TrainerSignature := EmpRec."Employee Signature";
                        end;
                    end;

                    //No cert for external classes
                    /*IF (Class."Trainer Category" = Class."Trainer Category"::Supplier) then begin
                        ExternalTrainers.Reset();
                        ExternalTrainers.SetRange("No.", Class."Trainer No.");
                        if ExternalTrainers.FindFirst() then begin
                            ExternalTrainers.CalcFields(Signature);

                            TempBlobTable.Reset();
                            TempBlobTable.Init();
                            TempBlobTable."Primary Key" := TempBlobUniqueKey;
                            TempBlobTable.Blob := ExternalTrainers.Signature;
                            if not TempBlobTable.Insert() then
                                TempBlobTable.Modify();
                            //if ExternalTrainers.Signature.HasValue then begin
                                ExternalTrainers.Signature.CreateInStream(InStr);
                                TempBlobTable.Blob.CreateOutStream(OutStr);
                                CopyStream(OutStr, InStr);
                                TempBlobTable.Insert();
                            end;//
                        end;
                    end;*/
                    /*TempBlobTable.Reset();
                    TempBlobTable.SetRange("Primary Key", TempBlobUniqueKey);
                    if TempBlobTable.Find('-') then
                        TempBlobTable.CalcFields(Blob);*/

                    /*Course.Reset();
                    Course.SetRange("No.", Class."Training No.");
                    if Course.FindFirst() then
                        CourseType := Uppercase(Format(Course.Type));*/
                    //updateParticipantType();
                    CourseType := UpperCase(Format(Type));
                    //CourseType := 'INITIAL';
                    //if same course was done last time (-Frequency) then it has been renewed.
                    /*TrainingScheduleLines.CalcFields("Training No.");
                    PrevScheduleLine.Reset();
                    PrevScheduleLine.SetFilter("Schedule No.", '<>%1', "Schedule No.");
                    PrevScheduleLine.SetRange("Emp No.", "Emp No.");
                    PrevScheduleLine.SetRange("Training No.", "Training No.");
                    PrevScheduleLine.SetFilter("Start Date", '<=%1', "Start Date");
                    if PrevScheduleLine.FindFirst() then
                        CourseType := 'REFRESHER';*/
                end;
            end;

            trigger OnPostDataItem()
            begin
                //TempBlobTable.Reset();
                //TempBlobTable.DeleteAll();  // Ensure TempBlob is cleared
                //Clear(TempBlobTable);       // Extra safety to clear the variable
            end;

        }
    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    trigger OnInitReport()
    begin
        TempBlobUniqueKey := UserId + '-' + Format(CurrentDateTime);
    end;

    trigger OnPostReport()
    begin
        //TempBlobUniqueKey := UserId + '-' + Format(CurrentDateTime);
        TempBlobTable.Reset();
        TempBlobTable.SetRange("Primary Key", TempBlobUniqueKey);
        if TempBlobTable.Find('-') then
            TempBlobTable.Delete();
    end;

    var
        CompanyInformation: Record "Company Information";
        Class: Record "Training Schedules";
        Course: Record "Training Master Plan Header";
        CourseName: Text;
        CourseType: Text;
        Validity: Text;
        IssueDate: Text;
        Location: Text;
        EmpRec: Record Employee;
        Signatory1EmpRec: Record Employee;
        Signatory1Name: Text;
        Signatory2Name: Text;
        SerialNo: Text;
        FinalDuesTable: Record "Terminal Dues Header";
        TempBlobTable: Record "Custom TempBlob";
        TempBlobTableInit: Record "Custom TempBlob";
        ExternalTrainers: Record "External Trainers";
        InStr: InStream;
        OutStr: OutStream;
        TempBlobUniqueKey: Code[250];
        PrevScheduleLine: Record "Training Schedule Lines";
}
