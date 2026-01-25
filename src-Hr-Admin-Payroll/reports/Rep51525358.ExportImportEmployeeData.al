report 51525358 "Export Import Employee Data"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Emp; Employee)
        {
            RequestFilterFields = "No.", Position, "Payroll Country", "Responsibility Center", "Sub Responsibility Center", "Sub Section";
            trigger OnAfterGetRecord()
            begin
                Window.Update(1, Emp."No.");

                if not HeadingsCaptured then begin
                    ExcelBuffer.NewRow;
                    ExcelBuffer.AddColumn(Emp.FieldCaption("No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("First Name"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Middle Name"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Last Name"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("ID Number"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Date Of Join"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Date of Appointment"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Date Of Birth"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption(Gender), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("PIN Number"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("NSSF No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("NHIF No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Bank Code"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Bank Name"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Bank Branch Code"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Bank Brach Name"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Bank Account No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Contractual Amount Type"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Contractual Amount Currency"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Assigned Gross Pay"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Payment/Bank Currency"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption(Position), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Job Title"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("E-Mail"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Company E-Mail"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Responsibility Center"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Sub Responsibility Center"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption(Station), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Pays tax"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Manager No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption(Status), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Contract Start Date"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Workstation Country"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Date Of Leaving"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Payroll Country"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Payment/Bank Country"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("SWIFT Code"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption(IBAN), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Sort Code"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption(Indicatif), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Code B.I.C."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Sub Section"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Salary Scale"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Phone No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Mobile Phone No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption(Address), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption(City), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Emp.FieldCaption("Post Code"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

                    HeadingsCaptured := true;
                end;

                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn(Emp."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."First Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Middle Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Last Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."ID Number", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Date Of Join", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Date of Appointment", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Date Of Birth", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp.Gender, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."PIN Number", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."NSSF No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."NHIF No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Bank Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Bank Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Bank Branch Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Bank Brach Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Bank Account No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Contractual Amount Type", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Contractual Amount Currency", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Assigned Gross Pay", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Payment/Bank Currency", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp.Position, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Job Title", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."E-Mail", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Company E-Mail", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Responsibility Center", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Sub Responsibility Center", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp.Station, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Pays tax", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Manager No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp.Status, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Contract Start Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Workstation Country", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Date Of Leaving", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Payroll Country", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Payment/Bank Country", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."SWIFT Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp.IBAN, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Sort Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp.Indicatif, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Code B.I.C.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Sub Section", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Salary Scale", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Next Seniority Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Phone No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Mobile Phone No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp.Address, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp.City, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Emp."Post Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            end;

            trigger OnPostDataItem()
            var
                HelperFunctions: Codeunit "Custom Helper Functions Base";
            begin
                if Direction = Direction::Export then begin
                    Window.Close;
                    ExcelBuffer.SetFriendlyFilename('Employee Data as at ' + Format(Today, 0, '<Month Text> <Day,2> <Year4>'));
                    HelperFunctions.CreateBookAndOpenExcel(ExcelBuffer, 'Employee Data as at ' + Format(Today, 0, '<Month Text> <Day,2>, <Year4>'), '');
                end;
            end;

            trigger OnPreDataItem()
            begin
                if Direction = Direction::Export then begin
                    Window.Open('Preparing employee export data for #######1');
                    ExcelBuffer.DeleteAll;
                end;

                if Direction = Direction::Import then begin
                    Window.Open('Preparing employee import data for #######1');
                    ExcelBuffer.DeleteAll;

                    Emp.SetRange("No.", 'XYZXYZ'); //When importing, don't fetch any employee, just pick it from the excel

                    UploadIntoStream('Please choose an excel file', '', '', FromFile, IStream);
                    if FromFile <> '' then begin
                        FileName := FileMgt.GetFileName(FromFile);
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

                    for RowNo := 2 to MaxRowNo do begin
                        for ColNo := 1 to MaxColNo do begin
                            Amount := 0;
                            Evaluate(DateOfJoin, GetValueAtCell(ExcelBuffer, RowNo, 6));
                            Evaluate(DateOfAppointment, GetValueAtCell(ExcelBuffer, RowNo, 7));
                            Evaluate(DateOfBirth, GetValueAtCell(ExcelBuffer, RowNo, 8));
                            Evaluate(ContractStartDate, GetValueAtCell(ExcelBuffer, RowNo, 32));
                            Evaluate(DateOfLeaving, GetValueAtCell(ExcelBuffer, RowNo, 34));
                            Evaluate(NextSeniorityDate, GetValueAtCell(ExcelBuffer, RowNo, 44));

                            //Evaluate(Amount, GetValueAtCell(ExcelBuffer, RowNo, 20));//Assigned Gross Pay
                            if GetValueAtCell(ExcelBuffer, RowNo, 20) = '' then
                                Amount := 0
                            else
                                Evaluate(Amount, GetValueAtCell(ExcelBuffer, RowNo, 20));

                            Window.Update(1, GetValueAtCell(ExcelBuffer, RowNo, 1));

                            EmpRec.Reset;
                            EmpRec.SetRange("No.", GetValueAtCell(ExcelBuffer, RowNo, 1));
                            if EmpRec.FindFirst then begin
                                EmpRec."No." := GetValueAtCell(ExcelBuffer, RowNo, 1);
                                EmpRec."First Name" := GetValueAtCell(ExcelBuffer, RowNo, 2);
                                EmpRec."Middle Name" := GetValueAtCell(ExcelBuffer, RowNo, 3);
                                EmpRec."Last Name" := GetValueAtCell(ExcelBuffer, RowNo, 4);
                                EmpRec."ID Number" := GetValueAtCell(ExcelBuffer, RowNo, 5);
                                EmpRec."Date Of Join" := DateOfJoin;
                                EmpRec."Date of Appointment" := DateOfAppointment;
                                EmpRec."Date Of Birth" := DateOfBirth;
                                EmpRec.Gender := EmpRec.Gender::" ";
                                if GetValueAtCell(ExcelBuffer, RowNo, 9) = 'Male' then
                                    EmpRec.Gender := EmpRec.Gender::Male;
                                if GetValueAtCell(ExcelBuffer, RowNo, 9) = 'Female' then
                                    EmpRec.Gender := EmpRec.Gender::Female;
                                EmpRec."PIN Number" := GetValueAtCell(ExcelBuffer, RowNo, 10);
                                EmpRec."NSSF No." := GetValueAtCell(ExcelBuffer, RowNo, 11);
                                EmpRec."NHIF No." := GetValueAtCell(ExcelBuffer, RowNo, 12);
                                EmpRec."Bank Code" := GetValueAtCell(ExcelBuffer, RowNo, 13);
                                EmpRec."Bank Name" := GetValueAtCell(ExcelBuffer, RowNo, 14);
                                EmpRec."Bank Branch Code" := GetValueAtCell(ExcelBuffer, RowNo, 15);
                                EmpRec."Bank Brach Name" := GetValueAtCell(ExcelBuffer, RowNo, 16);
                                EmpRec."Bank Account No." := GetValueAtCell(ExcelBuffer, RowNo, 17);
                                if GetValueAtCell(ExcelBuffer, RowNo, 18) = 'Basic Pay' then
                                    EmpRec."Contractual Amount Type" := EmpRec."Contractual Amount Type"::"Basic Pay";
                                if GetValueAtCell(ExcelBuffer, RowNo, 18) = 'Gross Pay' then
                                    EmpRec."Contractual Amount Type" := EmpRec."Contractual Amount Type"::"Gross Pay";
                                if GetValueAtCell(ExcelBuffer, RowNo, 18) = 'Net Pay' then
                                    EmpRec."Contractual Amount Type" := EmpRec."Contractual Amount Type"::"Net Pay";
                                EmpRec."Contractual Amount Currency" := GetValueAtCell(ExcelBuffer, RowNo, 19);
                                EmpRec."Assigned Gross Pay" := Amount;//20
                                EmpRec."Payment/Bank Currency" := GetValueAtCell(ExcelBuffer, RowNo, 21);
                                EmpRec.Position := GetValueAtCell(ExcelBuffer, RowNo, 22);
                                EmpRec."Job Title" := GetValueAtCell(ExcelBuffer, RowNo, 23);
                                EmpRec."E-Mail" := GetValueAtCell(ExcelBuffer, RowNo, 24);
                                EmpRec."Company E-Mail" := GetValueAtCell(ExcelBuffer, RowNo, 25);
                                EmpRec."Responsibility Center" := GetValueAtCell(ExcelBuffer, RowNo, 26);
                                EmpRec."Sub Responsibility Center" := GetValueAtCell(ExcelBuffer, RowNo, 27);
                                EmpRec.Station := GetValueAtCell(ExcelBuffer, RowNo, 28);
                                if GetValueAtCell(ExcelBuffer, RowNo, 29) = 'Yes' then
                                    EmpRec."Pays tax" := true;
                                if GetValueAtCell(ExcelBuffer, RowNo, 29) = 'No' then
                                    EmpRec."Pays tax" := false;
                                EmpRec."Manager No." := GetValueAtCell(ExcelBuffer, RowNo, 30);
                                if GetValueAtCell(ExcelBuffer, RowNo, 31) = 'Active' then
                                    EmpRec.Status := EmpRec.Status::Active;
                                if GetValueAtCell(ExcelBuffer, RowNo, 31) = 'Inactive' then
                                    EmpRec.Status := EmpRec.Status::Inactive;
                                EmpRec."Contract Start Date" := ContractStartDate;
                                EmpRec."Workstation Country" := GetValueAtCell(ExcelBuffer, RowNo, 33);
                                EmpRec."Date Of Leaving" := DateOfLeaving;
                                if (not ((EmpRec."Payroll Country" <> '') and (GetValueAtCell(ExcelBuffer, RowNo, 35) = ''))) then //Don't blank this field
                                    EmpRec."Payroll Country" := GetValueAtCell(ExcelBuffer, RowNo, 35);
                                EmpRec."Payment/Bank Country" := GetValueAtCell(ExcelBuffer, RowNo, 36);
                                if (EmpRec."Payment/Bank Country" = '') and (EmpRec."Payroll Country" <> '') then
                                    EmpRec."Payment/Bank Country" := EmpRec."Payroll Country";
                                MovementTable.Reset();
                                MovementTable.SetRange("Emp No.", EmpRec."No.");
                                MovementTable.SetRange(Status, MovementTable.Status::Current);
                                if MovementTable.FindFirst() then begin
                                    MovementTable."Payroll Country" := EmpRec."Payroll Country";
                                    MovementTable."Contractual Amount Currency" := EmpRec."Contractual Amount Currency";
                                    MovementTable."Contractual Amount Type" := EmpRec."Contractual Amount Type";
                                    MovementTable."Contractual Amount Value" := EmpRec."Assigned Gross Pay";
                                    MovementTable.Modify(false);
                                end;
                                EmpRec."SWIFT Code" := GetValueAtCell(ExcelBuffer, RowNo, 37);
                                EmpRec.IBAN := GetValueAtCell(ExcelBuffer, RowNo, 38);
                                EmpRec."Sort Code" := GetValueAtCell(ExcelBuffer, RowNo, 39);
                                EmpRec.Indicatif := GetValueAtCell(ExcelBuffer, RowNo, 40);
                                EmpRec."Code B.I.C." := GetValueAtCell(ExcelBuffer, RowNo, 41);
                                EmpRec."Sub Section" := GetValueAtCell(ExcelBuffer, RowNo, 42);
                                EmpRec."Salary Scale" := GetValueAtCell(ExcelBuffer, RowNo, 43);
                                EmpRec."Next Seniority Date" := NextSeniorityDate;
                                EmpRec."Phone No." := GetValueAtCell(ExcelBuffer, RowNo, 45);
                                EmpRec."Mobile Phone No." := GetValueAtCell(ExcelBuffer, RowNo, 46);
                                EmpRec.Address := GetValueAtCell(ExcelBuffer, RowNo, 47);
                                EmpRec.City := GetValueAtCell(ExcelBuffer, RowNo, 48);
                                EmpRec."Post Code" := GetValueAtCell(ExcelBuffer, RowNo, 49);

                                EmpRec.Modify;
                            end else begin
                                InsertEmp.Reset;
                                InsertEmp.Init;
                                InsertEmp."No." := GetValueAtCell(ExcelBuffer, RowNo, 1);
                                InsertEmp."First Name" := GetValueAtCell(ExcelBuffer, RowNo, 2);
                                InsertEmp."Middle Name" := GetValueAtCell(ExcelBuffer, RowNo, 3);
                                InsertEmp."Last Name" := GetValueAtCell(ExcelBuffer, RowNo, 4);
                                InsertEmp."ID Number" := GetValueAtCell(ExcelBuffer, RowNo, 5);
                                InsertEmp."Date Of Join" := DateOfJoin;
                                InsertEmp."Date of Appointment" := DateOfAppointment;
                                InsertEmp."Date Of Birth" := DateOfBirth;
                                InsertEmp.Gender := InsertEmp.Gender::" ";
                                if GetValueAtCell(ExcelBuffer, RowNo, 9) = 'Male' then
                                    InsertEmp.Gender := InsertEmp.Gender::Male;
                                if GetValueAtCell(ExcelBuffer, RowNo, 9) = 'Female' then
                                    InsertEmp.Gender := InsertEmp.Gender::Female;
                                InsertEmp."PIN Number" := GetValueAtCell(ExcelBuffer, RowNo, 10);
                                InsertEmp."NSSF No." := GetValueAtCell(ExcelBuffer, RowNo, 11);
                                InsertEmp."NHIF No." := GetValueAtCell(ExcelBuffer, RowNo, 12);
                                InsertEmp."Bank Code" := GetValueAtCell(ExcelBuffer, RowNo, 13);
                                InsertEmp."Bank Name" := GetValueAtCell(ExcelBuffer, RowNo, 14);
                                InsertEmp."Bank Branch Code" := GetValueAtCell(ExcelBuffer, RowNo, 15);
                                InsertEmp."Bank Brach Name" := GetValueAtCell(ExcelBuffer, RowNo, 16);
                                InsertEmp."Bank Account No." := GetValueAtCell(ExcelBuffer, RowNo, 17);
                                if GetValueAtCell(ExcelBuffer, RowNo, 18) = 'Basic Pay' then
                                    EmpRec."Contractual Amount Type" := EmpRec."Contractual Amount Type"::"Basic Pay";
                                if GetValueAtCell(ExcelBuffer, RowNo, 18) = 'Gross Pay' then
                                    EmpRec."Contractual Amount Type" := EmpRec."Contractual Amount Type"::"Gross Pay";
                                if GetValueAtCell(ExcelBuffer, RowNo, 18) = 'Net Pay' then
                                    EmpRec."Contractual Amount Type" := EmpRec."Contractual Amount Type"::"Net Pay";
                                InsertEmp."Contractual Amount Currency" := GetValueAtCell(ExcelBuffer, RowNo, 19);
                                InsertEmp."Assigned Gross Pay" := Amount;
                                InsertEmp."Payment/Bank Currency" := GetValueAtCell(ExcelBuffer, RowNo, 21);
                                InsertEmp.Position := GetValueAtCell(ExcelBuffer, RowNo, 22);
                                InsertEmp."Job Title" := GetValueAtCell(ExcelBuffer, RowNo, 23);
                                InsertEmp."E-Mail" := GetValueAtCell(ExcelBuffer, RowNo, 24);
                                InsertEmp."Company E-Mail" := GetValueAtCell(ExcelBuffer, RowNo, 25);
                                InsertEmp."Responsibility Center" := GetValueAtCell(ExcelBuffer, RowNo, 26);
                                InsertEmp."Sub Responsibility Center" := GetValueAtCell(ExcelBuffer, RowNo, 27);
                                InsertEmp.Station := GetValueAtCell(ExcelBuffer, RowNo, 28);
                                if GetValueAtCell(ExcelBuffer, RowNo, 29) = 'Yes' then
                                    InsertEmp."Pays tax" := true;
                                if GetValueAtCell(ExcelBuffer, RowNo, 29) = 'No' then
                                    InsertEmp."Pays tax" := false;
                                InsertEmp."Manager No." := GetValueAtCell(ExcelBuffer, RowNo, 30);
                                if GetValueAtCell(ExcelBuffer, RowNo, 31) = 'Active' then
                                    InsertEmp.Status := InsertEmp.Status::Active;
                                if GetValueAtCell(ExcelBuffer, RowNo, 31) = 'Inactive' then
                                    InsertEmp.Status := InsertEmp.Status::Inactive;
                                InsertEmp."Contract Start Date" := ContractStartDate;
                                InsertEmp."Workstation Country" := GetValueAtCell(ExcelBuffer, RowNo, 33);
                                InsertEmp."Date Of Leaving" := DateOfLeaving;
                                InsertEmp."Payroll Country" := GetValueAtCell(ExcelBuffer, RowNo, 35);
                                InsertEmp."Payment/Bank Country" := GetValueAtCell(ExcelBuffer, RowNo, 36);
                                if (InsertEmp."Payment/Bank Country" = '') and (InsertEmp."Payroll Country" <> '') then
                                    InsertEmp."Payment/Bank Country" := InsertEmp."Payroll Country";
                                InsertEmp."SWIFT Code" := GetValueAtCell(ExcelBuffer, RowNo, 37);
                                InsertEmp.IBAN := GetValueAtCell(ExcelBuffer, RowNo, 38);
                                InsertEmp."Sort Code" := GetValueAtCell(ExcelBuffer, RowNo, 39);
                                InsertEmp.Indicatif := GetValueAtCell(ExcelBuffer, RowNo, 40);
                                InsertEmp."Code B.I.C." := GetValueAtCell(ExcelBuffer, RowNo, 41);
                                InsertEmp."Sub Section" := GetValueAtCell(ExcelBuffer, RowNo, 42);
                                InsertEmp."Salary Scale" := GetValueAtCell(ExcelBuffer, RowNo, 43);
                                InsertEmp."Next Seniority Date" := NextSeniorityDate;
                                InsertEmp."Phone No." := GetValueAtCell(ExcelBuffer, RowNo, 45);
                                InsertEmp."Mobile Phone No." := GetValueAtCell(ExcelBuffer, RowNo, 46);
                                InsertEmp.Address := GetValueAtCell(ExcelBuffer, RowNo, 47);
                                InsertEmp.City := GetValueAtCell(ExcelBuffer, RowNo, 48);
                                InsertEmp."Post Code" := GetValueAtCell(ExcelBuffer, RowNo, 49);

                                InsertEmp.Insert;
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
        Direction: Option Export,Import;
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

    local procedure GetValueAtCell(var TempExcelBuffer: Record "Excel Buffer" temporary; rowNo: Integer; colNo: Integer): Text
    begin
        TempExcelBuffer.Reset;
        if TempExcelBuffer.Get(rowNo, colNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;
}