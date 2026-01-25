report 51525359 "Export Import Movement Data"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Emp; Employee)
        {
            RequestFilterFields = "No.", Position, "Payroll Country", "Responsibility Center", "Sub Responsibility Center", "Sub Section";
            DataItemTableView = where(Status = const(Active));
            trigger OnAfterGetRecord()
            begin
                Window.Update(1, Emp."No.");

                if not HeadingsCaptured then begin
                    ExcelBuffer.NewRow;
                    ExcelBuffer.AddColumn('WB No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Change Type', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('First Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Last Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Workstation Country', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Station Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Station Title', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Department Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Department Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Section Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Section Title', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Job/Position Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Job/Position Title', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Contractual Amount Type', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Contractual Amount Currency', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Contractual Amount Value', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Payroll Country', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Payroll Currency', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Remarks', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('No Transport Allowance', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Applicable House Allowance', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Salary Grade', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Next Seniority Date', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

                    HeadingsCaptured := true;
                end;

                MovementTable.Reset();
                MovementTable.SetRange("Emp No.", Emp."No.");
                MovementTable.SetRange(Status, MovementTable.Status::Current);
                if MovementTable.FindFirst() then begin
                    ExcelBuffer.NewRow;
                    ExcelBuffer.AddColumn(Emp."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Format(MovementTable.Type), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(MovementTable."First Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(MovementTable."Last Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(MovementTable."Workstation Country", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(MovementTable."Station Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(MovementTable."Station Title", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(MovementTable."Dept Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(MovementTable."Department Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(MovementTable."Section Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(MovementTable."Section Title", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(MovementTable."Position Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(MovementTable."Job Title", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Format(MovementTable."Contractual Amount Type"), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(MovementTable."Contractual Amount Currency", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    if not CanEditPaymentInfo then
                        ExcelBuffer.AddColumn(0, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number)
                    else
                        ExcelBuffer.AddColumn(MovementTable."Contractual Amount Value", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(MovementTable."Payroll Country", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(MovementTable."Payroll Currency", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(MovementTable.Remarks, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(format(MovementTable."No Transport Allowance"), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(MovementTable."Applicable House Allowance (%)", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(format(MovementTable."Salary Scale"), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(format(MovementTable."Next Seniority Date"), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                end;
            end;

            trigger OnPostDataItem()
            var
                HelperFunctions: Codeunit "Custom Helper Functions Base";
            begin
                if Direction = Direction::Export then begin
                    Window.Close;
                    ExcelBuffer.SetFriendlyFilename('Employee Current Movement Data as at ' + Format(CurrentDateTime, 0, '<Month Text> <Day,2> <Year4> <Hours12,2>:<Minutes,2> <AM/PM>'));
                    HelperFunctions.CreateBookAndOpenExcel(ExcelBuffer, 'Employee Current Movement Data as at ' + Format(CurrentDateTime, 0, '<Month Text> <Day,2> <Year4> <Hours12,2>:<Minutes,2> <AM/PM>'), 'Current Movement Data');
                end;
            end;

            trigger OnPreDataItem()
            begin
                UserSetup.Reset();
                UserSetup.SetRange("User ID", UserId);
                if UserSetup.FindFirst() then begin
                    if (not UserSetup."Can Edit Emp Card") and (not UserSetup."Can Edit Payroll Info") then
                        Error('You are not allowed to perform this action!');
                end else
                    Error('You are not allowed to perform this action!');

                if Direction = Direction::Export then begin
                    Window.Open('Preparing employee Movement export data for #######1');
                    ExcelBuffer.DeleteAll;
                end;

                if Direction = Direction::Import then begin
                    Window.Open('Preparing employee Movement import data for #######1');
                    ExcelBuffer.DeleteAll;

                    Emp.SetRange("No.", 'XYZXYZ'); //When importing, don't fetch any record, just pick it from the excel

                    UploadIntoStream('Please choose an excel file', '', '', FromFile, IStream);
                    if FromFile <> '' then begin
                        FileName := FileMgt.GetFileName(FromFile);
                        SheetName := ExcelBuffer.SelectSheetsNameStream(IStream);
                    end else
                        Error('Excel file not found!');

                    //Let's be really sure - double confirm
                    if not Confirm('Are you sure you want to import the movement data to ' + Format(ActionToTake) + ' records?') then exit;
                    if ActionToTake = ActionToTake::"Update Current" then
                        Message('You have chosen to update the current movement records. Note that only existing movements with status "Current" for active staff will be updated.');
                    if ActionToTake = ActionToTake::"Create New" then
                        Message('You have chosen to create new movement entries. Current movement entries will be changed such that status becomes past, and last date becomes 1 day before the new first date. \This only affects active staff.');
                    if not Confirm(/*'But first, ' + UserId + */'Kindly note that this action is not directly reversible. Any mistakes here may need to be corrected one by one. \Are you really sure you want to import the movement data to ' + Format(ActionToTake) + ' records?') then exit;
                    //CONVERTSTR(CopyStr(UserId, StrLen('RWANDAIR\') + 1, MaxStrLen(UserId)), '.', ' ')

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

                    for RowNo := 2 to MaxRowNo do begin
                        //for ColNo := 1 to MaxColNo do begin
                        Amount := 0;
                        ApplicableHouseAllowance := 0;
                        FirstDate := 0D;
                        NextSeniorityDate := 0D;
                        LastDate := 0D;
                        if GetValueAtCell(ExcelBuffer, RowNo, 4) = '' then
                            Error('You must provide start date for all entries');
                        Evaluate(FirstDate, GetValueAtCell(ExcelBuffer, RowNo, 4));
                        Evaluate(LastDate, GetValueAtCell(ExcelBuffer, RowNo, 5));
                        Evaluate(NextSeniorityDate, GetValueAtCell(ExcelBuffer, RowNo, 24));
                        if GetValueAtCell(ExcelBuffer, RowNo, 17) = '' then
                            Amount := 0
                        else
                            Evaluate(Amount, GetValueAtCell(ExcelBuffer, RowNo, 17));

                        if GetValueAtCell(ExcelBuffer, RowNo, 22) <> '' then
                            Evaluate(ApplicableHouseAllowance, GetValueAtCell(ExcelBuffer, RowNo, 22));

                        WBNo := GetValueAtCell(ExcelBuffer, RowNo, 1);
                        ChangeType := GetValueAtCell(ExcelBuffer, RowNo, 3);
                        if ChangeType = '' then
                            Error('Each line must have the change type recorded exactly as is in the system. Check in the movement records!');

                        Window.Update(1, WBNo);

                        if WBNo <> '' then begin
                            EmpRec.SetRange("No.", WBNo);
                            if EmpRec.FindFirst then begin
                                if EmpRec.Status = EmpRec.Status::Inactive then
                                    Error('Employee ' + EmpRec."No." + ' - ' + EmpRec.FullName() + ' is inactive. Kindly remove them from the list then retry!');

                                //Action update current record
                                if ActionToTake = ActionToTake::"Update Current" then begin
                                    MovementTable.Reset;
                                    MovementTable.SetRange("Emp No.", WBNo);
                                    MovementTable.SetRange(Status, MovementTable.Status::Current);
                                    if MovementTable.FindFirst() then begin
                                        if UpperCase(ChangeType) = UpperCase('August 2023') then
                                            MovementTable.Type := MovementTable.Type::"August 2023";
                                        if UpperCase(ChangeType) = UpperCase('Gross Adjustment due to New Pension Rate') then
                                            MovementTable.Type := MovementTable.Type::"Gross Adjustment due to New Pension Rate";
                                        if UpperCase(ChangeType) = UpperCase('Initial') then
                                            MovementTable.Type := MovementTable.Type::Initial;
                                        if UpperCase(ChangeType) = UpperCase('Country') then
                                            MovementTable.Type := MovementTable.Type::Country;
                                        if UpperCase(ChangeType) = UpperCase('Station') then
                                            MovementTable.Type := MovementTable.Type::Station;
                                        if UpperCase(ChangeType) = UpperCase('Department/Section') then
                                            MovementTable.Type := MovementTable.Type::"Department/Section";
                                        if UpperCase(ChangeType) = UpperCase('Change due to Transformation') then
                                            MovementTable.Type := MovementTable.Type::"Change due to Transformation";
                                        if UpperCase(ChangeType) = UpperCase('Promotion') then
                                            MovementTable.Type := MovementTable.Type::Promotion;
                                        if UpperCase(ChangeType) = UpperCase('Demotion') then
                                            MovementTable.Type := MovementTable.Type::Demotion;
                                        if UpperCase(ChangeType) = UpperCase('Salary Adjustment') then
                                            MovementTable.Type := MovementTable.Type::"Salary Adjustment";
                                        if UpperCase(ChangeType) = UpperCase('Salary Alignment') then
                                            MovementTable.Type := MovementTable.Type::"Salary Alignment";
                                        if UpperCase(ChangeType) = UpperCase('Title Change and Responsibilities') then
                                            MovementTable.Type := MovementTable.Type::"Title Change and Responsibilities";
                                        if UpperCase(ChangeType) = UpperCase('Trainee') then
                                            MovementTable.Type := MovementTable.Type::Trainee;
                                        if UpperCase(ChangeType) = UpperCase('Consultant') then
                                            MovementTable.Type := MovementTable.Type::Consultant;
                                        if UpperCase(ChangeType) = UpperCase('Temporary Contract') then
                                            MovementTable.Type := MovementTable.Type::"Temporary Contract";
                                        if UpperCase(ChangeType) = UpperCase('New Appointment') then
                                            MovementTable.Type := MovementTable.Type::"New Appointment";
                                        if UpperCase(ChangeType) = UpperCase('Additional Duties/Responsibility') then
                                            MovementTable.Type := MovementTable.Type::"Additional Duties/Responsibility";
                                        if UpperCase(ChangeType) = UpperCase('Reintegration') then
                                            MovementTable.Type := MovementTable.Type::Reintegration;
                                        if UpperCase(ChangeType) = UpperCase('Temporary Contract Extension') then
                                            MovementTable.Type := MovementTable.Type::"Temporary Contract Extension";
                                        if UpperCase(ChangeType) = UpperCase('Final Call Letter') then
                                            MovementTable.Type := MovementTable.Type::"Final Call Letter";
                                        if UpperCase(ChangeType) = UpperCase('End of additional duties/responsibility') then
                                            MovementTable.Type := MovementTable.Type::"End of additional duties/responsibility";
                                        if UpperCase(ChangeType) = UpperCase('Seniority') then
                                            MovementTable.Type := MovementTable.Type::Seniority;
                                        if UpperCase(ChangeType) = UpperCase('Employment Contract Amendment') then
                                            MovementTable.Type := MovementTable.Type::"Employment Contract Amendment";
                                        if UpperCase(ChangeType) = UpperCase('Reinstatement Letter') then
                                            MovementTable.Type := MovementTable.Type::"Reinstatement Letter";
                                        if UpperCase(ChangeType) = UpperCase('Other') then
                                            MovementTable.Type := MovementTable.Type::Other;
                                        MovementTable."First Date" := FirstDate;
                                        MovementTable.Validate("First Date");
                                        if LastDate <> 0D then
                                            MovementTable."Last Date" := LastDate;
                                        MovementTable."Workstation Country" := GetValueAtCell(ExcelBuffer, RowNo, 6);
                                        MovementTable."Station Code" := GetValueAtCell(ExcelBuffer, RowNo, 7);
                                        MovementTable.Validate("Station Code");
                                        MovementTable."Dept Code" := GetValueAtCell(ExcelBuffer, RowNo, 9);
                                        MovementTable.Validate("Dept Code");
                                        MovementTable."Section Code" := GetValueAtCell(ExcelBuffer, RowNo, 11);
                                        MovementTable.Validate("Section Code");
                                        MovementTable."Position Code" := GetValueAtCell(ExcelBuffer, RowNo, 13);
                                        MovementTable.Validate("Position Code");
                                        //"Gross Pay","Basic Pay","Net Pay"
                                        MovementTable."Contractual Amount Type" := MovementTable."Contractual Amount Type"::"Gross Pay";
                                        if UpperCase(GetValueAtCell(ExcelBuffer, RowNo, 15)) = UpperCase('Gross Pay') then
                                            MovementTable."Contractual Amount Type" := MovementTable."Contractual Amount Type"::"Gross Pay";
                                        if UpperCase(GetValueAtCell(ExcelBuffer, RowNo, 15)) = UpperCase('Basic Pay') then
                                            MovementTable."Contractual Amount Type" := MovementTable."Contractual Amount Type"::"Basic Pay";
                                        if UpperCase(GetValueAtCell(ExcelBuffer, RowNo, 15)) = UpperCase('Net Pay') then
                                            MovementTable."Contractual Amount Type" := MovementTable."Contractual Amount Type"::"Net Pay";
                                        MovementTable."Contractual Amount Currency" := GetValueAtCell(ExcelBuffer, RowNo, 16);
                                        if CanEditPaymentInfo then
                                            MovementTable."Contractual Amount Value" := Amount;
                                        MovementTable."Payroll Country" := GetValueAtCell(ExcelBuffer, RowNo, 18);
                                        MovementTable."Payroll Currency" := GetValueAtCell(ExcelBuffer, RowNo, 19);
                                        MovementTable.Remarks := GetValueAtCell(ExcelBuffer, RowNo, 20);
                                        MovementTable."No Transport Allowance" := false;
                                        if UpperCase(GetValueAtCell(ExcelBuffer, RowNo, 21)) = 'YES' then
                                            MovementTable."No Transport Allowance" := true;
                                        MovementTable."Applicable House Allowance (%)" := ApplicableHouseAllowance;
                                        MovementTable."Salary Scale" := GetValueAtCell(ExcelBuffer, RowNo, 23);
                                        MovementTable."Next Seniority Date" := NextSeniorityDate;
                                        MovementTable.Modify(true);
                                    end else
                                        Error('There is no movement record with status "Current" for employee ' + EmpRec."No." + ' - ' + EmpRec.FullName() + '.\Kindly check then retry!');
                                end;

                                //Action create new record
                                if ActionToTake = ActionToTake::"Create New" then begin
                                    //If there's an existing current movement, close it
                                    MovementTable.Reset;
                                    MovementTable.SetRange("Emp No.", WBNo);
                                    MovementTable.SetRange(Status, MovementTable.Status::Current);
                                    if MovementTable.FindFirst() then begin
                                        MovementTable."Last Date" := CalcDate('-1D', FirstDate);
                                        MovementTable.Status := MovementTable.Status::Past;
                                        MovementTable.Modify();
                                    end;

                                    MovementTableInsert.Reset();
                                    MovementTableInsert.Init();
                                    MovementTableInsert."No." := '';
                                    MovementTableInsert."Emp No." := WBNo;
                                    if UpperCase(ChangeType) = UpperCase('August 2023') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::"August 2023";
                                    if UpperCase(ChangeType) = UpperCase('Gross Adjustment due to New Pension Rate') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::"Gross Adjustment due to New Pension Rate";
                                    if UpperCase(ChangeType) = UpperCase('Initial') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::Initial;
                                    if UpperCase(ChangeType) = UpperCase('Country') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::Country;
                                    if UpperCase(ChangeType) = UpperCase('Station') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::Station;
                                    if UpperCase(ChangeType) = UpperCase('Department/Section') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::"Department/Section";
                                    if UpperCase(ChangeType) = UpperCase('Change due to Transformation') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::"Change due to Transformation";
                                    if UpperCase(ChangeType) = UpperCase('Promotion') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::Promotion;
                                    if UpperCase(ChangeType) = UpperCase('Demotion') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::Demotion;
                                    if UpperCase(ChangeType) = UpperCase('Salary Adjustment') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::"Salary Adjustment";
                                    if UpperCase(ChangeType) = UpperCase('Salary Alignment') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::"Salary Alignment";
                                    if UpperCase(ChangeType) = UpperCase('Title Change and Responsibilities') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::"Title Change and Responsibilities";
                                    if UpperCase(ChangeType) = UpperCase('Trainee') then
                                        MovementTableInsert.Type := MovementTable.Type::Trainee;
                                    if UpperCase(ChangeType) = UpperCase('Consultant') then
                                        MovementTableInsert.Type := MovementTable.Type::Consultant;
                                    if UpperCase(ChangeType) = UpperCase('Temporary Contract') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::"Temporary Contract";
                                    if UpperCase(ChangeType) = UpperCase('New Appointment') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::"New Appointment";
                                    if UpperCase(ChangeType) = UpperCase('Additional Duties/Responsibility') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::"Additional Duties/Responsibility";
                                    if UpperCase(ChangeType) = UpperCase('Reintegration') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::Reintegration;
                                    if UpperCase(ChangeType) = UpperCase('Temporary Contract Extension') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::"Temporary Contract Extension";
                                    if UpperCase(ChangeType) = UpperCase('Final Call Letter') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::"Final Call Letter";
                                    if UpperCase(ChangeType) = UpperCase('End of additional duties/responsibility') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::"End of additional duties/responsibility";
                                    if UpperCase(ChangeType) = UpperCase('Seniority') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::Seniority;
                                    if UpperCase(ChangeType) = UpperCase('Employment Contract Amendment') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::"Employment Contract Amendment";
                                    if UpperCase(ChangeType) = UpperCase('Reinstatement Letter') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::"Reinstatement Letter";
                                    if UpperCase(ChangeType) = UpperCase('Other') then
                                        MovementTableInsert.Type := MovementTableInsert.Type::Other;
                                    MovementTableInsert."First Date" := FirstDate;
                                    MovementTableInsert.Validate("First Date");
                                    if LastDate <> 0D then
                                        MovementTableInsert."Last Date" := LastDate;
                                    MovementTableInsert."Workstation Country" := GetValueAtCell(ExcelBuffer, RowNo, 6);
                                    MovementTableInsert."Station Code" := GetValueAtCell(ExcelBuffer, RowNo, 7);
                                    MovementTableInsert.Validate("Station Code");
                                    MovementTableInsert."Dept Code" := GetValueAtCell(ExcelBuffer, RowNo, 9);
                                    MovementTableInsert.Validate("Dept Code");
                                    MovementTableInsert."Section Code" := GetValueAtCell(ExcelBuffer, RowNo, 11);
                                    MovementTableInsert.Validate("Section Code");
                                    MovementTableInsert."Position Code" := GetValueAtCell(ExcelBuffer, RowNo, 13);
                                    MovementTableInsert.Validate("Position Code");
                                    //"Gross Pay","Basic Pay","Net Pay"
                                    MovementTableInsert."Contractual Amount Type" := MovementTableInsert."Contractual Amount Type"::"Gross Pay";
                                    if UpperCase(GetValueAtCell(ExcelBuffer, RowNo, 15)) = UpperCase('Gross Pay') then
                                        MovementTableInsert."Contractual Amount Type" := MovementTableInsert."Contractual Amount Type"::"Gross Pay";
                                    if UpperCase(GetValueAtCell(ExcelBuffer, RowNo, 15)) = UpperCase('Basic Pay') then
                                        MovementTableInsert."Contractual Amount Type" := MovementTableInsert."Contractual Amount Type"::"Basic Pay";
                                    if UpperCase(GetValueAtCell(ExcelBuffer, RowNo, 15)) = UpperCase('Net Pay') then
                                        MovementTableInsert."Contractual Amount Type" := MovementTableInsert."Contractual Amount Type"::"Net Pay";
                                    MovementTableInsert."Contractual Amount Currency" := GetValueAtCell(ExcelBuffer, RowNo, 16);
                                    if CanEditPaymentInfo then
                                        MovementTableInsert."Contractual Amount Value" := Amount;
                                    MovementTableInsert."Payroll Country" := GetValueAtCell(ExcelBuffer, RowNo, 18);
                                    MovementTableInsert."Payroll Currency" := GetValueAtCell(ExcelBuffer, RowNo, 19);
                                    MovementTableInsert.Remarks := GetValueAtCell(ExcelBuffer, RowNo, 20);
                                    MovementTableInsert.Status := MovementTableInsert.Status::Current;
                                    MovementTableInsert."No Transport Allowance" := false;
                                    if UpperCase(GetValueAtCell(ExcelBuffer, RowNo, 21)) = 'YES' then
                                        MovementTableInsert."No Transport Allowance" := true;
                                    MovementTableInsert."Applicable House Allowance (%)" := ApplicableHouseAllowance;
                                    MovementTableInsert."Salary Scale" := GetValueAtCell(ExcelBuffer, RowNo, 23);
                                    MovementTableInsert."Next Seniority Date" := NextSeniorityDate;
                                    MovementTableInsert.Insert(true);
                                    /*end else
                                        Error('There is already an existing movement record with status "Current" for employee ' + EmpRec."No." + ' - ' + EmpRec.FullName() + '.\Kindly check then retry!');*/
                                end;
                            end;
                        end;
                    end;
                    Message('Import successful!');
                    Window.Close;
                end;

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
                field("Action to Take"; ActionToTake)
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

    trigger OnInitReport()
    begin
        CanEditPaymentInfo := false;
        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        if UserSetup.FindFirst() then
            CanEditPaymentInfo := UserSetup."Can Edit Payroll Info";
    end;

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        Earnings: Record Earnings;
        Deductions: Record Deductions;
        Employee: Record Employee;
        AssignmentMatrix: Record "Assignment Matrix";
        Amount: Decimal;
        ApplicableHouseAllowance: Decimal;
        Window: Dialog;
        AccessibleCompanies: Text;
        LineNo: Integer;
        Direction: Option Export,Import;
        ActionToTake: Option "Update Current","Create New";
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
        FirstDate: Date;
        LastDate: Date;
        NextSeniorityDate: Date;
        DateOfBirth: Date;
        ContractStartDate: Date;
        DateOfLeaving: Date;
        EmpRec: Record Employee;
        MovementTable: Record "Internal Employement History";
        MovementTableInsert: Record "Internal Employement History";
        WBNo: Code[50];
        ChangeType: Code[100];
        UserSetup: Record "User Setup";
        CanEditPaymentInfo: Boolean;

    local procedure GetValueAtCell(var TempExcelBuffer: Record "Excel Buffer" temporary; rowNo: Integer; colNo: Integer): Text
    begin
        TempExcelBuffer.Reset;
        if TempExcelBuffer.Get(rowNo, colNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;
}