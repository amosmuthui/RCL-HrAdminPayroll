report 51525370 "Peer Appraisal 360 Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/PeerAppraisal360Report.rdlc';

    dataset
    {
        dataitem("Peer Appraisal Header"; "Peer Appraisal Header")
        {
            column(No_PeerAppraisalHeader; "Peer Appraisal Header".No)
            {
            }
            column(Description_PeerAppraisalHeader; "Peer Appraisal Header".Description)
            {
            }
            column(Period_PeerAppraisalHeader; "Peer Appraisal Header".Period)
            {
            }
            column(StaffNo_PeerAppraisalHeader; "Peer Appraisal Header"."Staff No")
            {
            }
            column(PeerAppraiser1_PeerAppraisalHeader; "Peer Appraisal Header"."Peer Appraiser 1")
            {
            }
            column(PeerAppraiser2_PeerAppraisalHeader; "Peer Appraisal Header"."Peer Appraiser 2")
            {
            }
            column(PeerAppraiser3_PeerAppraisalHeader; "Peer Appraisal Header"."Peer Appraiser 3")
            {
            }
            column(CreatedBy_PeerAppraisalHeader; "Peer Appraisal Header"."Created By")
            {
            }
            column(CreatedOn_PeerAppraisalHeader; "Peer Appraisal Header"."Created On")
            {
            }
            column(Status_PeerAppraisalHeader; "Peer Appraisal Header".Status)
            {
            }
            column(Directorate_PeerAppraisalHeader; "Peer Appraisal Header".Directorate)
            {
            }
            column(Department_PeerAppraisalHeader; "Peer Appraisal Header".Department)
            {
            }
            column(Supervisor_PeerAppraisalHeader; "Peer Appraisal Header".Supervisor)
            {
            }
            column(SupervisorName_PeerAppraisalHeader; "Peer Appraisal Header"."Supervisor Name")
            {
            }
            column(Designation_PeerAppraisalHeader; "Peer Appraisal Header".Designation)
            {
            }
            column(Levelofinteraction_PeerAppraisalHeader; "Peer Appraisal Header"."Level of interaction")
            {
            }
            column(CompName; CompInfo.Name)
            {
            }
            column(CompPict; CompInfo.Picture)
            {
            }
            column(StaffName; StaffName)
            {
            }
            column(AssessorNo; AssessorNo)
            {
            }
            column(AssessorName; AssessorName)
            {
            }
            column(StaffSignature; StaffUserSetup.Signature)
            {
            }
            column(AssessorSignature; AssessorUserSetup.Signature)
            {
            }
            column(StaffJobTitle; StaffJobTitle)
            {
            }
            column(AssessorJobTitle; AssessorJobTitle)
            {
            }
            column(AssessorDepartment; AssessorDepartment)
            {
            }
            column(AssesserLocation; AssesserLocation)
            {
            }
            dataitem("Peer Appraisal Lines"; "Peer Appraisal Lines")
            {
                DataItemLink = "Doc No" = FIELD(No), "Staff No" = FIELD("Staff No");
                column(DocNo_PeerAppraisalLines; "Peer Appraisal Lines"."Doc No")
                {
                }
                column(EntryNo_PeerAppraisalLines; "Peer Appraisal Lines"."Entry No")
                {
                }
                column(Type_PeerAppraisalLines; "Peer Appraisal Lines".Type)
                {
                }
                column(SectionNo_PeerAppraisalLines; "Peer Appraisal Lines"."Section No")
                {
                }
                column(PeerLevel_PeerAppraisalLines; "Peer Appraisal Lines"."Peer Level")
                {
                }
                column(Remarks_PeerAppraisalLines; "Peer Appraisal Lines".Remarks)
                {
                }
                column(V1stAppraiser_PeerAppraisalLines; "Peer Appraisal Lines"."1st Appraiser")
                {
                }

                trigger OnPreDataItem()
                begin
                    "Peer Appraisal Lines".SetRange(Appraiser, AssessorNo);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //Identify this peer - whether 1,2, or 3
                //AssessorNo := '';
                StaffJobTitle := '';
                AssessorJobTitle := '';
                AssessorDepartment := '';
                AssesserLocation := '';


                if CurrUserIsSupervisor then begin
                    if SelectedPeerLevel = SelectedPeerLevel::First then
                        AssessorNo := "Peer Appraisal Header"."Peer Appraiser 1";
                    if SelectedPeerLevel = SelectedPeerLevel::Second then
                        AssessorNo := "Peer Appraisal Header"."Peer Appraiser 2";
                    if SelectedPeerLevel = SelectedPeerLevel::Third then
                        AssessorNo := "Peer Appraisal Header"."Peer Appraiser 3";
                end;



                Employee.Reset;
                Employee.SetRange("No.", AssessorNo);
                //Employee.SETRANGE("User ID",'UMSOMIHVKENYA\AAKINYI');//USERID 'UMSOMIHVKENYA\DTOBON' 'UMSOMIHVKENYA\AAKINYI'
                //Employee.SETFILTER("No.",'%1|%2|%3',"Peer Appraisal Header"."Peer Appraiser 1","Peer Appraisal Header"."Peer Appraiser 2","Peer Appraisal Header"."Peer Appraiser 3");
                if Employee.FindFirst then begin
                    //AssessorNo := Employee."No.";
                    AssessorJobTitle := Employee."Job Title";
                    AssessorName := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";

                    DimVal.Reset;
                    DimVal.SetRange(Code, Employee."Global Dimension 2 Code");
                    if DimVal.FindFirst then
                        AssessorDepartment := DimVal.Name;

                    Locations.Reset;
                    Locations.SetRange(Code, Employee."Location Code");
                    if Locations.FindFirst then
                        AssesserLocation := Locations.Name;
                end;

                if AssessorNo = '' then
                    Error('You do not exist as an employee!');//CurrReport.SKIP; //Only the peer can print

                if not (AssessorNo in ["Peer Appraisal Header"."Peer Appraiser 1", "Peer Appraisal Header"."Peer Appraiser 2", "Peer Appraisal Header"."Peer Appraiser 3"]) then
                    Error('You must be one of the selected peers');

                StaffUserSetup.Reset;
                StaffUserSetup.SetRange("Employee No.", "Peer Appraisal Header"."Staff No");
                if StaffUserSetup.FindFirst then
                    StaffUserSetup.CalcFields(Signature);

                AssessorUserSetup.Reset;
                AssessorUserSetup.SetRange("Employee No.", AssessorNo);
                if AssessorUserSetup.FindFirst then
                    AssessorUserSetup.CalcFields(Signature);

                Employee.Reset;
                Employee.SetRange("No.", "Peer Appraisal Header"."Staff No");
                //Employee.SETFILTER("No.",'%1|%2',"Peer Appraisal Header"."Staff No",AssessorNo);
                if Employee.FindFirst/*.FINDSET*/ then begin
                    StaffJobTitle := Employee."Job Title";
                    StaffName := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                    /*REPEAT
                      IF Employee."No." = "Peer Appraisal Header"."Staff No" THEN BEGIN
                        StaffJobTitle := Employee."Job Title";
                        StaffName := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                      END;
                      IF Employee."No." = AssessorNo THEN BEGIN
                        AssessorJobTitle := Employee."Job Title";
                        AssessorName := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                
                        DimVal.RESET;
                        DimVal.SETRANGE(Code,Employee."Global Dimension 2 Code");
                        IF DimVal.FINDFIRST THEN
                          AssessorDepartment := DimVal.Name;
                      END;
                    UNTIL Employee.NEXT = 0;*/
                end;

            end;

            trigger OnPreDataItem()
            begin
                "Peer Appraisal Header".SetRange(No, ApprDocNo);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(SelectedPeerLevel; SelectedPeerLevel)
                {
                    Caption = 'Select Peer Level';
                    Visible = true;
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
        /*CompInfo.GET();
        CompInfo.CALCFIELDS(Picture);
        
        Employee.RESET;
        Employee.SETRANGE("User ID", 'UMSOMIHVKENYA\NLANGAT');//USERID UMSOMIHVKENYA\DTOBON UMSOMIHVKENYA\AAKINYI  UMSOMIHVKENYA\NLANGAT
        IF Employee.FIND('-') THEN
          BEGIN
              IF Employee."No." = Supervisor THEN BEGIN
                IsSupervisor := TRUE;
              END;
          END;*/
        /*IF CurrUserIsSupervisor THEN
            ShowRequestPage := TRUE;*/

    end;

    var
        CompInfo: Record "Company Information";
        StaffName: Text[100];
        AssessorNo: Code[30];
        AssessorName: Text[100];
        StaffUserSetup: Record "User Setup";
        AssessorUserSetup: Record "User Setup";
        StaffJobTitle: Text[50];
        AssessorJobTitle: Text[50];
        Employee: Record Employee;
        AssessorDepartment: Text[100];
        DimVal: Record "Dimension Value";
        CurrUserIsSupervisor: Boolean;
        ShowRequestPage: Boolean;
        SelectedPeerLevel: Option First,Second,Third;
        ApprDocNo: Code[30];
        AssesserLocation: Text[100];
        Locations: Record Location;

    procedure SetFilters(DocNo: Code[30]; AppraiserNo: Code[30]; IsSupervisor: Boolean)
    begin
        ApprDocNo := DocNo;
        AssessorNo := AppraiserNo;
        CurrUserIsSupervisor := IsSupervisor;
        //ShowRequestPage := IsSupervisor;
    end;
}