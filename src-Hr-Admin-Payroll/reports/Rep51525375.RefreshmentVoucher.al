report 51525375 "Refreshment Voucher"
{
    ApplicationArea = All;
    Caption = 'Refreshment Voucher';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/RefreshmentVoucher.rdlc';
    dataset
    {
        dataitem(RefreshmentRequests; "Refreshment Requests")
        {
            RequestFilterHeading = 'Request';
            RequestFilterFields = "No.";

            column(CompanyName; CompanyInformation.Name)
            {
            }
            column(CompanyAddress; CompanyInformation.Address)
            {
            }
            column(CompanyCity; CompanyInformation.City)
            {
            }
            column(CompanyPhone; CompanyInformation."Phone No.")
            {
            }
            column(CompanyPicture; CompanyInformation.Picture)
            {
            }
            column(CompanyPIN; CompanyInformation."P.I.N")
            {
            }
            column(CompanyPostCode; CompanyInformation."Post Code")
            {
            }
            column(CompanyAddress2; CompanyInformation."Address 2")
            {
            }
            column(ComapnyEmail; CompanyInformation."E-Mail")
            {
            }
            column(CompanyHomePage; CompanyInformation."Home Page")
            {
            }
            column(ReportTitle; ReportTitle)
            {
            }
            column(No; "No.")
            {
            }
            column(RequestedByEmpNo; "Requested By Emp No.")
            {
            }
            column(RequestedByEmpName; "Requested By Emp Name")
            {
            }
            column(Purpose; Purpose)
            {
            }
            column(DateRequired; Format("Date Required", 0, '<Day,2> <Month Text> <Year4>'))
            {
            }
            column(ApprovalStatus; "Approval Status")
            {
            }
            column(App1Name; App1Name)
            {
            }
            column(App1Date; App1Date)
            {
            }
            column(App1Signature; App1Signature.Signature)
            {
            }
            column(App2Name; App2Name)
            {
            }
            column(App2Date; App2Date)
            {
            }
            column(App2Signature; App2Signature.Signature)
            {
            }
            column(App3Name; App3Name)
            {
            }
            column(App3Date; App3Date)
            {
            }
            column(App3Signature; App3Signature.Signature)
            {
            }
            column(App4Name; App4Name)
            {
            }
            column(App4Date; App4Date)
            {
            }
            column(App4Signature; App4Signature.Signature)
            {
            }
            column(App5Name; App5Name)
            {
            }
            column(App5Date; App5Date)
            {
            }
            column(App5Signature; App5Signature.Signature)
            {
            }
            dataitem("Refreshment Details"; "Refreshment Details")
            {
                DataItemLink = "Request No." = field("No.");
                column(Entry_No_; "Entry No.")
                { }
                column(Type_Code; "Type Code")
                { }
                column(Type_Description; "Type Description")
                { }
                column(Additional_Info; "Additional Info")
                { }
                column(Quantity; Quantity)
                { }
            }

            trigger OnAfterGetRecord()
            begin
                if not ComapnyInfoCaptured then begin
                    CompanyInformation.CalcFields(Picture);
                    ReportTitle := 'REFRESHMENT VOUCHER';
                end;

                //Approvers
                if not ApprovalEntriesCaptured then begin
                    ApprovalEntriesCaptured := true;
                    ApprovalEntries.Reset();
                    ApprovalEntries.SetRange("Document Type", ApprovalEntries."Document Type"::"Refreshment Request");
                    ApprovalEntries.SetRange("Document No.", "No.");
                    ApprovalEntries.SetRange(Status, ApprovalEntries.Status::Approved);
                    if ApprovalEntries.FindSet() then
                        repeat
                            EmpRec.Reset();
                            EmpRec.SetRange("User ID", ApprovalEntries."Approver ID");
                            if EmpRec.FindFirst() then begin
                                EmpRec.Validate(Position);
                                if ApprovalEntries."Sequence No." = 1 then begin
                                    Emp.Reset();
                                    Emp.SetRange("User ID", ApprovalEntries."Sender ID");
                                    if Emp.FindFirst() then begin
                                        App1Name := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name" + '(' + EmpRec."Job Title" + ')';
                                        App1Date := Format(ApprovalEntries."Date-Time Sent for Approval", 0, '<Day,2>/<Month,2>/<Year4>');

                                        App1Signature.Reset();
                                        App1Signature.SetRange("User ID", ApprovalEntries."Sender ID");
                                        if App1Signature.FindFirst() then
                                            App1Signature.CalcFields(Signature);
                                    end;

                                    App2Name := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name" + '(' + EmpRec."Job Title" + ')';
                                    App2Date := Format(ApprovalEntries."Last Date-Time Modified", 0, '<Day,2>/<Month,2>/<Year4>');
                                    App2Signature.Reset();
                                    App2Signature.SetRange("User ID", ApprovalEntries."Approver ID");
                                    if App2Signature.FindFirst() then
                                        App2Signature.CalcFields(Signature);
                                end;
                                if ApprovalEntries."Sequence No." = 2 then begin
                                    App3Name := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name" + '(' + EmpRec."Job Title" + ')';
                                    App3Date := Format(ApprovalEntries."Last Date-Time Modified", 0, '<Day,2>/<Month,2>/<Year4>');
                                    App3Signature.Reset();
                                    App3Signature.SetRange("User ID", ApprovalEntries."Approver ID");
                                    if App3Signature.FindFirst() then
                                        App3Signature.CalcFields(Signature);
                                end;
                                if ApprovalEntries."Sequence No." = 3 then begin
                                    App4Name := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name" + '(' + EmpRec."Job Title" + ')';
                                    App4Date := Format(ApprovalEntries."Last Date-Time Modified", 0, '<Day,2>/<Month,2>/<Year4>');
                                    App4Signature.Reset();
                                    App4Signature.SetRange("User ID", ApprovalEntries."Approver ID");
                                    if App4Signature.FindFirst() then
                                        App4Signature.CalcFields(Signature);
                                end;
                                if ApprovalEntries."Sequence No." = 4 then begin
                                    App5Name := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name" + '(' + EmpRec."Job Title" + ')';
                                    App5Date := Format(ApprovalEntries."Last Date-Time Modified", 0, '<Day,2>/<Month,2>/<Year4>');
                                    App5Signature.Reset();
                                    App5Signature.SetRange("User ID", ApprovalEntries."Approver ID");
                                    if App5Signature.FindFirst() then
                                        App5Signature.CalcFields(Signature);
                                end;
                            end;
                        until ApprovalEntries.Next() = 0;
                end;
            end;


            trigger OnPreDataItem()
            begin
                CompanyInformation.Get;
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
    var
        CompanyInformation: Record "Company Information";
        ComapnyInfoCaptured: Boolean;
        ReportTitle: Text;
        ApprovalEntriesCaptured: Boolean;
        ApprovalEntries: Record "Approval Entry";
        UserSetup: Record "User Setup";
        App1Name: Text[250];
        App1Date: Text[30];
        App1Signature: Record "User Setup";
        App2Name: Text[250];
        App2Date: Text[30];
        App2Signature: Record "User Setup";
        App3Name: Text[250];
        App3Date: Text[30];
        App3Signature: Record "User Setup";
        App4Name: Text[250];
        App4Date: Text[30];
        App4Signature: Record "User Setup";
        App5Name: Text[250];
        App5Date: Text[30];
        App5Signature: Record "User Setup";
        EmpRec: Record Employee;
        Emp: Record Employee;
}
