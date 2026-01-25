report 51525366 "Send Payslips"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/SendPayslips.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                TempBlob: Codeunit "Temp Blob";
                RecRef: RecordRef;
                OutStr: OutStream;
                inStr: InStream;
            begin
                Error('Kindly consult the system administrators!');
                CompanyInfo.Get();
                SenderAddress := '';//SmtpRec."User ID";

                SenderName := CompanyName;

                Payslips.Reset;
                Payslips.SetRange("Employee No", Employee."No.");
                Payslips.SetRange("Payroll Period", PayPeriod);
                if not Payslips.Find('-') then begin

                    Subject := StrSubstNo('Payslip');
                    Body := StrSubstNo('Dear ' + Employee."Last Name" + ' ' + Employee."First Name" + ',' + '<p>Please find attached your Payslip statement for the period ' + Format(PayPeriod, 0, '<Month Text> <Year4>'));
                    Body := Body + '<p> Kind Regards,<br> Payroll Manager';
                    PyslipCapt := 'Payslip ' + Format(PayPeriod, 0, '<Month Text> <Year4>') + '.pdf';
                    Emp.Reset;
                    Emp.SetRange(Emp."No.", "No.");
                    Emp.SetRange(Emp."Pay Period Filter", PayPeriod);
                    if Emp.Find('-') then begin
                        Emp.CalcFields("Total Allowances", "Total Deductions");
                        if Emp."Total Allowances" > 0 then begin

                            TempBlob.CreateOutStream(OutStr, TEXTENCODING::UTF8);
                            RecRef.GetTable(Emp);
                            REPORT.SAVEAS(REPORT::"New Payslip", '', REPORTFORMAT::Pdf, OutStr, RecRef);
                            TempBlob.CreateInStream(inStr);
                            EmailMessage.AddAttachment(PyslipCapt, 'application/pdf', inStr);

                            pdfPassword := Employee."National ID";
                            //Message('Nat ID %1 Filename %2', Employee."National ID", FileName);
                            if pdfPassword <> '' then begin
                                //pdfmanage:=pdfmanage.Class1;
                                Pathcode := '';//pdfmanage.pdfManage(FileName, pdfPassword);
                            end;

                            if Emp."E-Mail" <> '' then begin
                                Recipients := Emp."E-Mail";//'denniskitui@gmail.com';
                                                           //Recipients :='onchuruivan@gmail.com';
                                EmailMessage.Create(Recipients, Subject, Body, true);

                                Email.Send(EmailMessage, Enum::"Email Scenario"::Default);

                                //Update Log
                                /*   PayPeriods.RESET;
                                   PayPeriods.SETRANGE(Closed,FALSE);
                                   IF PayPeriods.FINDFIRST THEN BEGIN
                                     Payslips.INIT;
                                     Payslips."Employee No":=Employee."No.";
                                     Payslips."Payroll Period":=PayPeriod;
                                     Payslips.Sent:=TRUE;
                                     Payslips."Date Sent":=CREATEDATETIME(TODAY,TIME);
                                     Payslips.INSERT;
                                     END;*/


                            end;
                        end;
                        //END;
                    end;
                end;

            end;

            trigger OnPreDataItem()
            begin
                if PayPeriod = 0D then
                    Error('You must provide a valid payroll period to use this function');

                Employee.SetRange("Pay Period Filter", PayPeriod);
                CompanyInfo.Get();

                //IF CompanyInfo."Payslip Mail"='' THEN
                // ERROR('Payslip Email cannot be blank on Company information. Update it to continue');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PayPeriod; PayPeriod)
                {
                    Caption = 'Payroll Period';
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
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email message";
        CompanyInfo: Record "Company Information";
        UserSetup: Record "User Setup";
        SenderAddress: Text[80];
        Recipients: Text[80];
        SenderName: Text[50];
        Body: Text[250];
        Subject: Text[80];
        FileName: Text[250];
        FileMangement: Codeunit "File Management";
        HRSetup: Record "Human Resources Setup";
        PayPeriod: Date;
        Posting: Record "Staff Posting Group";
        Emp: Record Employee;
        StaffType: Code[20];
        PyslipCapt: Text;
        Payslips: Record "Sent Payslips";
        PayPeriods: Record "Payroll Period";
        pdfPassword: Text;
        pwd: Integer;
        //pdfmanage: DotNet Class1;
        Pathcode: Text;
}