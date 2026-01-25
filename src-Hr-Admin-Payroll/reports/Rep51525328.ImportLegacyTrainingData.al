report 51525328 "Import Legacy Training Data"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Course; "Training Master Plan Header")
        {
            trigger OnAfterGetRecord()
            begin
            end;

            trigger OnPostDataItem()
            var
                ExcelBuffer: Record "Excel Buffer" temporary;
            begin
                if Direction = Direction::Export then begin
                    Window.Close;
                    // ExcelBuffer.SetFriendlyFilename('Employee Data as at ' + Format(Today, 0, '<Month Text> <Day,2> <Year4>'));
                    // ExcelBuffer.CreateBookAndOpenExcel('', 'Employee Data as at ' + Format(Today, 0, '<Month Text> <Day,2>, <Year4>'), '', '', UserId);


                    // Define columns
                    ExcelBuffer.AddColumn('Employee Data as at', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Employee Data as at ', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

                    // Row 1
                    ExcelBuffer.CreateNewBook('Training Master Plan Header');
                    ExcelBuffer.WriteSheet('Training Master Plan Header', CompanyName, UserId);
                    ExcelBuffer.CloseBook();
                    ExcelBuffer.OpenExcel();




                end;
            end;

            trigger OnPreDataItem()
            var
                Courses: Record "Training Master Plan Header";
                CourseInit: Record "Training Master Plan Header";
                CourseNo: Code[100];
                EventTitle: Text;
                EventDescription: Text[2000];
                EventCategory: Text;
                Classes: Record "Training Schedules";
                ClassInit: Record "Training Schedules";
                ClassNo: Code[100];
                ScheduledDate: Date;
                CompletedDate: Date;
                TrLocation: Text;
                TrainingLocations: Record "Training Locations";
                TrainingLocationInit: Record "Training Locations";
                TrLocationLineNo: Integer;
                LineNo: Integer;
                Trainer: Text;
                ExternalTrainers: Record "External Trainers";
                ExternalTrainersInit: Record "External Trainers";
                TrainerNo: Code[100];
                Renewable: Boolean;
                RenewablePeriod: Text;
                Objectives: Text[2000];
                ClassDuration: Text;
                AttendeeTitle: Text;
                AttendeeName: Text;
                AttendeeEmpNo: Code[30];
                AttendeeDept: Text;
                AttendeeCertNo: Text;
                AttendeeCertFilePath: Text;
                RenewByDate: Date;
                EvalCompletedDate: Date;
                EvaluationComments: Text;
                Participants: Record "Training Schedule Lines";
                ParticipantsInit: Record "Training Schedule Lines";
                ParticipantsCheckByName: Record "Training Schedule Lines";
                PartNo: Code[30];
            begin
                if Direction = Direction::Import then begin
                    Window.Open('Preparing training data import for #######1');
                    ExcelBuffer.DeleteAll;

                    Course.SetRange("No.", 'XYZXYZ'); //When importing, don't fetch any employee, just pick it from the excel

                    UploadIntoStream('Please choose an excel file', '', '', FromFile, IStream);
                    if FromFile <> '' then begin
                        FileName := FileMgt.GetFileName(FromFile);
                        Commit();
                        SheetName := ExcelBuffer.SelectSheetsNameStream(IStream);
                    end else
                        Error('Excel file not found!');

                    ExcelBuffer.Reset;
                    ExcelBuffer.DeleteAll;
                    ExcelBuffer.OpenBookStream(IStream, SheetName);
                    ExcelBuffer.ReadSheet;

                    RowNo := 0;
                    ColNo := 0;
                    MaxRowNo := 0;
                    MaxColNo := 0;
                    LineNo := 0;

                    ExcelBuffer.Reset;
                    if ExcelBuffer.FindLast then begin
                        MaxRowNo := ExcelBuffer."Row No.";
                        MaxColNo := ExcelBuffer."Column No.";
                    end;


                    PartNo := '';
                    if HrSetup.Get() then
                        PartNo := HrSetup."Last PartNo";
                    if PartNo = '' then
                        PartNo := 'PART-0000';

                    for RowNo := 2 to MaxRowNo do begin
                        EventTitle := GetValueAtCell(ExcelBuffer, RowNo, 1);
                        EventCategory := GetValueAtCell(ExcelBuffer, RowNo, 2);
                        EventDescription := CopyStr(GetValueAtCell(ExcelBuffer, RowNo, 3), 1, 2000);
                        Evaluate(ScheduledDate, GetValueAtCell(ExcelBuffer, RowNo, 4));
                        Evaluate(CompletedDate, GetValueAtCell(ExcelBuffer, RowNo, 5));
                        TrLocation := GetValueAtCell(ExcelBuffer, RowNo, 6);
                        Trainer := GetValueAtCell(ExcelBuffer, RowNo, 7);
                        Renewable := false;
                        if GetValueAtCell(ExcelBuffer, RowNo, 8) = 'Yes' then
                            Renewable := true;
                        RenewablePeriod := GetValueAtCell(ExcelBuffer, RowNo, 9);
                        Objectives := CopyStr(GetValueAtCell(ExcelBuffer, RowNo, 10), 1, 2000);
                        ClassDuration := GetValueAtCell(ExcelBuffer, RowNo, 17);
                        AttendeeTitle := GetValueAtCell(ExcelBuffer, RowNo, 24);
                        AttendeeName := GetValueAtCell(ExcelBuffer, RowNo, 25);
                        AttendeeEmpNo := GetValueAtCell(ExcelBuffer, RowNo, 26);
                        AttendeeDept := GetValueAtCell(ExcelBuffer, RowNo, 27);
                        AttendeeCertNo := GetValueAtCell(ExcelBuffer, RowNo, 28);
                        AttendeeCertFilePath := GetValueAtCell(ExcelBuffer, RowNo, 29);
                        Evaluate(RenewByDate, GetValueAtCell(ExcelBuffer, RowNo, 31));
                        Evaluate(EvalCompletedDate, GetValueAtCell(ExcelBuffer, RowNo, 32));
                        EvaluationComments := CopyStr(GetValueAtCell(ExcelBuffer, RowNo, 33), 1, 250);

                        Window.Update(1, EventTitle);

                        CourseNo := '';
                        Courses.Reset();
                        Courses.SetRange(Title, EventTitle);
                        if Courses.FindFirst() then
                            CourseNo := Courses."No."
                        else begin
                            CourseInit.Init();
                            CourseInit.Title := EventTitle;
                            CourseInit.Description := EventDescription;
                            CourseInit.Objectives := Objectives;
                            if Renewable then begin
                                CourseInit.Recurrence := CourseInit.Recurrence::Recurs;
                                CourseInit.Type := CourseInit.Type::General;
                                if RenewablePeriod in ['1 Year(s)', '3 Year(s)', '2 Year(s)'] then
                                    CourseInit.Frequency := format(CopyStr(RenewablePeriod, 1, 1)) + 'Y';
                                if RenewablePeriod in ['12 Month(s)', '12 Month(s)'] then
                                    CourseInit.Frequency := format(CopyStr(RenewablePeriod, 1, 2)) + 'M';
                                if RenewablePeriod in ['3 Month(s)'] then
                                    CourseInit.Frequency := '3Y';
                            end;
                            if ClassDuration in ['5 Week(s)', '1 Week(s)', '4 Week(s)', '2 Week(s)', '3 Week(s)'] then
                                CourseInit."Approximate Duration" := format(CopyStr(ClassDuration, 1, 1)) + 'W';
                            if ClassDuration in ['6 Month(s)', '1 Month(s)', '3 Month(s)'] then
                                CourseInit."Approximate Duration" := format(CopyStr(ClassDuration, 1, 1)) + 'M';
                            if ClassDuration in ['4 Day(s)', '8 Day(s)', '5 Day(s)', '7 Day(s)', '2 Day(s)', '1 Day(s)', '3 Day(s)'] then
                                CourseInit."Approximate Duration" := format(CopyStr(ClassDuration, 1, 1)) + 'D';
                            if ClassDuration in ['14 Day(s)', '40 Day(s)'] then
                                CourseInit."Approximate Duration" := format(CopyStr(ClassDuration, 1, 2)) + 'D';
                            if ClassDuration in ['208 Day(s)'] then
                                CourseInit."Approximate Duration" := format(CopyStr(ClassDuration, 1, 3)) + 'D';
                            if ClassDuration in ['8 Year(s)', '1 Year(s)'] then
                                CourseInit."Approximate Duration" := format(CopyStr(ClassDuration, 1, 1)) + 'Y';
                            if ClassDuration in ['45 Year(s)', '13 Year(s)'] then
                                CourseInit."Approximate Duration" := format(CopyStr(ClassDuration, 1, 2)) + 'Y';
                            CourseInit."Legacy Data" := true;
                            CourseInit."No." := '';
                            CourseInit.Insert(true);
                            CourseNo := CourseInit."No.";
                        end;

                        ClassNo := '';
                        Classes.Reset();
                        Classes.SetRange("Training No.", CourseNo);
                        if Classes.FindFirst() then
                            ClassNo := Classes."No."
                        else begin
                            ClassInit.Init();
                            ClassInit."Training No." := CourseNo;
                            ClassInit.Validate("Training No.");
                            ClassInit.Department := EventCategory;
                            if EventCategory = '' then
                                ClassInit.Department := 'Unclassified';
                            ClassInit."Start Date" := ScheduledDate;
                            ClassInit."End Date" := CompletedDate;

                            if ClassInit."End Date" < Today() then
                                ClassInit.Status := ClassInit.Status::Done;
                            if ClassInit."End Date" >= Today() then
                                ClassInit.Status := ClassInit.Status::Ongoing;
                            if ClassInit."Start Date" > Today() then
                                ClassInit.Status := ClassInit.Status::Pending;

                            LineNo := 0;
                            TrainingLocations.Reset();
                            TrainingLocations.SetRange(Location, TrLocation);
                            if not TrainingLocations.FindFirst() then begin
                                TrainingLocationInit.Reset();
                                if TrainingLocationInit.FindLast() then
                                    LineNo := TrainingLocationInit."Line No.";

                                LineNo += 1;
                                TrainingLocationInit.Reset();
                                TrainingLocationInit.Init();
                                TrainingLocationInit."Line No." := LineNo;
                                TrainingLocationInit.Location := TrLocation;
                                TrainingLocationInit.Insert();
                            end;
                            ClassInit."Training Location" := TrLocation;

                            //Set all trainers as external. Let them adjust accordingly
                            if Trainer <> '' then begin
                                TrainerNo := '';
                                ExternalTrainers.Reset();
                                ExternalTrainers.SetRange(Name, Trainer);
                                if ExternalTrainers.FindFirst() then
                                    TrainerNo := ExternalTrainers."No."
                                else begin
                                    ExternalTrainers.Init();
                                    ExternalTrainers."No." := '';
                                    ExternalTrainers.Name := Trainer;
                                    ExternalTrainers.Insert(true);
                                    TrainerNo := ExternalTrainers."No.";
                                end;
                                ClassInit."Trainer Category" := ClassInit."Trainer Category"::Supplier;
                                ClassInit."Trainer No." := TrainerNo;
                                ClassInit.Validate("Trainer No.");
                            end;
                            ClassInit."Legacy Data" := true;
                            ClassInit."No." := '';
                            ClassInit.Insert(true);
                            ClassNo := ClassInit."No.";
                        end;

                        //Participants
                        if (AttendeeName <> '') and (AttendeeEmpNo = '') then //If name exists, force some number
                            begin
                            PartNo := IncStr(PartNo);
                            AttendeeEmpNo := PartNo;
                        end;
                        Participants.Reset();
                        Participants.SetRange("Schedule No.", ClassNo);
                        Participants.SetRange("Emp No.", AttendeeEmpNo);
                        if not Participants.FindFirst() then begin
                            ParticipantsInit.Init();
                            ParticipantsInit."Emp No." := AttendeeEmpNo;
                            ParticipantsInit."Schedule No." := ClassNo;
                            ParticipantsInit."Employee Name" := /*AttendeeTitle + ' ' + */AttendeeName;
                            ParticipantsInit."Training Report" := EvaluationComments;
                            ParticipantsInit."Certificate Serial No." := AttendeeCertNo;
                            ParticipantsInit."Legacy Data" := true;
                            ParticipantsInit."Certificate Link" := '';
                            if AttendeeCertFilePath <> '' then
                                ParticipantsInit."Certificate Link" := 'https://ess.rwandair.com/NEWERPDocuments/' + ReplaceString(AttendeeCertFilePath, '\', '/');
                            ParticipantsInit."Renew By" := RenewByDate;
                            ParticipantsInit.Insert(true);
                        end else begin
                            //Can update missing staff
                            if Participants."Legacy Data" then begin
                                if (Participants."Employee Name" = '') and (AttendeeName <> '') then
                                    Participants."Employee Name" := AttendeeName;
                                if (Participants."Training Report" = '') and (EvaluationComments <> '') then
                                    Participants."Training Report" := EvaluationComments;
                                if (Participants."Certificate Serial No." = '') and (AttendeeCertNo <> '') then
                                    Participants."Certificate Serial No." := AttendeeCertNo;
                                if (Participants."Certificate Link" = '') and (AttendeeCertFilePath <> '') then
                                    Participants."Certificate Link" := 'https://ess.rwandair.com/NEWERPDocuments/' + ReplaceString(AttendeeCertFilePath, '\', '/');
                                if (Participants."Renew By" = 0D) and (RenewByDate <> 0D) then
                                    Participants."Renew By" := RenewByDate;
                            end;
                            Participants.Modify();
                        end;
                    end;
                end;
                Message('Import successful!');
                Window.Close;

                HeadingsCaptured := false;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Direction; Direction)
                {
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        Earnings: Record Earnings;
        Deductions: Record Deductions;
        Employee: Record Employee;
        AssignmentMatrix: Record "Assignment Matrix";
        Amount: Decimal;
        Window: Dialog;
        AccessibleCompanies: Text;
        LineNo: Integer;
        Direction: Option Import,Export;
        HeadingsCaptured: Boolean;
        FromFile: Text[200];
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FileName: Text[200];
        SheetName: Text[200];
        RowNo: Integer;
        ColNo: Integer;
        MaxRowNo: Integer;
        MaxColNo: Integer;
        InsertEmp: Record Employee;
        DateOfJoin: Date;
        DateOfAppointment: Date;
        DateOfBirth: Date;
        ContractStartDate: Date;
        DateOfLeaving: Date;
        NextSeniorityDate: Date;
        EmpRec: Record Employee;
        MovementTable: Record "Internal Employement History";
        HrSetup: Record "Human Resources Setup";

    local procedure GetValueAtCell(var TempExcelBuffer: Record "Excel Buffer" temporary; rowNo: Integer; colNo: Integer): Text
    begin
        TempExcelBuffer.Reset;
        if TempExcelBuffer.Get(rowNo, colNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    procedure ReplaceString(String: Text; FindWhat: Text; ReplaceWith: Text) NewString: Text
    begin
        WHILE STRPOS(String, FindWhat) > 0 DO
            String := DELSTR(String, STRPOS(String, FindWhat)) + ReplaceWith + COPYSTR(String, STRPOS(String, FindWhat) + STRLEN(FindWhat));
        NewString := String;
    end;
}