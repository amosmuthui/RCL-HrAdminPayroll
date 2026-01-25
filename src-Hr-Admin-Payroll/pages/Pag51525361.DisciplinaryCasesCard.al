page 51525361 "Disciplinary Cases Card"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "Disciplinary Cases";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Case No"; Rec."Case No")
                {
                    Editable = false;
                }
                field("Offense Type"; Rec."Offense Type")
                {
                }
                field("Offense Name"; Rec."Offense Name")
                {
                    Editable = false;
                }
                field("Case Description"; Rec."Case Description")
                {
                }
                field("Date of the Case"; Rec."Date of the Case")
                {
                }
                field("Employee No"; Rec."Employee No")
                {
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                }
                field("Previous Disciplinary Case"; Rec."Previous Disciplinary Case")
                {
                    Editable = false;
                }
                field("Levels of Discipline"; Rec."Levels of Discipline")
                {
                    Editable = true;
                    Visible = false;
                }
                field("Case Status"; Rec."Case Status")
                {
                    Editable = false;
                }
                field("HOD Name"; Rec."HOD Name")
                {
                    Caption = ' Supervisor Name';
                    Editable = false;
                }
                group(Control48)
                {
                    Editable = SupEdit;
                    ShowCaption = false;
                    field("HOD Recommendation"; Rec."HOD Recommendation")
                    {
                        Caption = 'Supervisor Recommendation';
                        Editable = Hredit;
                        MultiLine = true;
                    }
                }
                group(Control43)
                {
                    Editable = Hredit;
                    ShowCaption = false;
                    Visible = ongoingbl;
                    field("HR Recommendation"; Rec."HR Recommendation")
                    {
                        MultiLine = true;
                    }
                }
                group(Control46)
                {
                    Editable = CommEdit;
                    ShowCaption = false;
                    Visible = commttbl;
                    field("Commitee Recommendation"; Rec."Commitee Recommendation")
                    {
                        MultiLine = true;
                        Visible = ongoingbl;
                    }
                }
                group(Control44)
                {
                    Editable = Ceoedit;
                    ShowCaption = false;
                    Visible = atceobl;
                    field("CEO Recommendation"; Rec."CEO Recommendation")
                    {
                        MultiLine = true;
                    }
                }
                group(Control45)
                {
                    ShowCaption = false;
                    Visible = boardbl;
                    field("Board Recommendation"; Rec."Board Recommendation")
                    {
                        MultiLine = true;
                    }
                }
                group(Control52)
                {
                    Editable = AppealEdit;
                    ShowCaption = false;
                    Visible = appealedbl;
                    field("Appeal Comments"; Rec."Appeal Comments")
                    {
                        MultiLine = true;
                    }
                    field("Appeal Descision"; Rec."Appeal Descision")
                    {
                    }
                }
                group(Control47)
                {
                    ShowCaption = false;
                    Visible = closedbl;
                    field(Appealed; Rec.Appealed)
                    {
                        Visible = false;
                    }
                    field("Committee Recon After Appeal"; Rec."Committee Recon After Appeal")
                    {
                        Caption = 'Board-Finance & HR Committe Recomendation';
                        Visible = appealedbl;
                    }
                    field("No. of Appeals"; Rec."No. of Appeals")
                    {
                        Visible = closedbl;
                    }
                    field("Court's Decision"; Rec."Court's Decision")
                    {
                        Visible = courtbl;
                    }
                }
                field("Action Taken"; Rec."Action Taken")
                {
                    Visible = ongoingbl;

                    trigger OnValidate()
                    begin
                        // IF "Action Taken File Path" = '' THEN
                        //  BEGIN
                        //    ERROR(Txt0001);
                        //  END;
                    end;
                }
            }
            part(Control42; "Previous Cases")
            {
                Editable = false;
                SubPageLink = "Employee No" = FIELD("Employee No");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Proceed To Ongoing")
            {
                Image = OutboundEntry;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Openvs;

                trigger OnAction()
                begin
                    /*IF "HOD Recommendation"='' THEN BEGIN
                       ERROR('HOD Recommendation is Empty');
                    END;
                    IF "HR Recommendation"='' THEN BEGIN
                       ERROR('HR Recommendation is Empty');
                    END;
                    */
                    Rec."Case Status" := Rec."Case Status"::Ongoing;
                    Message('Moved to Ongoing Cases Menu...');
                    CurrPage.Close;

                end;
            }
            /*action("Attach HOD Recommendation")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Openvs;

                trigger OnAction()
                begin
                    filename := FileCU.OpenFileDialog('Select  File', '', '');
                    if filename <> '' then begin
                        HRsetup.Reset;
                        HRsetup.Get;
                        filename2 := Format(CurrentDateTime) + '_' + UserId;
                        filename2 := ConvertStr(filename2, '/', '_');
                        filename2 := ConvertStr(filename2, '\', '_');
                        filename2 := ConvertStr(filename2, ':', '_');
                        filename2 := ConvertStr(filename2, '.', '_');
                        filename2 := ConvertStr(filename2, ',', '_');
                        filename2 := ConvertStr(filename2, ' ', '_');
                        filename2 := ConvertStr(filename2, ' ', '_');
                        FileCU.CopyClientFile(filename, HRsetup."Disciplinary Cases File" + FileCU.GetFileName(filename), true);
                        "HOD File Path" := HRsetup."Disciplinary Cases File" + FileCU.GetFileName(filename);
                        Message('File Attached Successfully');
                    end;
                end;
            }
            action("Attach HR Recommendation")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Ongoingvs;

                trigger OnAction()
                begin
                    filename := FileCU.OpenFileDialog('Select  File', '', '');
                    if filename <> '' then begin
                        HRsetup.Reset;
                        HRsetup.Get;
                        filename2 := Format(CurrentDateTime) + '_' + UserId;
                        filename2 := ConvertStr(filename2, '/', '_');
                        filename2 := ConvertStr(filename2, '\', '_');
                        filename2 := ConvertStr(filename2, ':', '_');
                        filename2 := ConvertStr(filename2, '.', '_');
                        filename2 := ConvertStr(filename2, ',', '_');
                        filename2 := ConvertStr(filename2, ' ', '_');
                        filename2 := ConvertStr(filename2, ' ', '_');
                        FileCU.CopyClientFile(filename, HRsetup."Disciplinary Cases File" + FileCU.GetFileName(filename), true);
                        "HR File Path" := HRsetup."Disciplinary Cases File" + FileCU.GetFileName(filename);
                        Message('File Attached Successfully');
                    end;
                end;
            }
            action("Attach Commitee Recommendation")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Commvs;

                trigger OnAction()
                begin
                    filename := FileCU.OpenFileDialog('Select  File', '', '');
                    if filename <> '' then begin
                        HRsetup.Reset;
                        HRsetup.Get;
                        filename2 := Format(CurrentDateTime) + '_' + UserId;
                        filename2 := ConvertStr(filename2, '/', '_');
                        filename2 := ConvertStr(filename2, '\', '_');
                        filename2 := ConvertStr(filename2, ':', '_');
                        filename2 := ConvertStr(filename2, '.', '_');
                        filename2 := ConvertStr(filename2, ',', '_');
                        filename2 := ConvertStr(filename2, ' ', '_');
                        filename2 := ConvertStr(filename2, ' ', '_');
                        FileCU.CopyClientFile(filename, HRsetup."Disciplinary Cases File" + FileCU.GetFileName(filename), true);
                        "Committe File Path" := HRsetup."Disciplinary Cases File" + FileCU.GetFileName(filename);
                        Message('File Attached Successfully');
                    end;
                end;
            }
            action("Attach File After Appeal")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Appealvs;

                trigger OnAction()
                begin
                    filename := FileCU.OpenFileDialog('Select  File', '', '');
                    if filename <> '' then begin
                        HRsetup.Reset;
                        HRsetup.Get;
                        filename2 := Format(CurrentDateTime) + '_' + UserId;
                        filename2 := ConvertStr(filename2, '/', '_');
                        filename2 := ConvertStr(filename2, '\', '_');
                        filename2 := ConvertStr(filename2, ':', '_');
                        filename2 := ConvertStr(filename2, '.', '_');
                        filename2 := ConvertStr(filename2, ',', '_');
                        filename2 := ConvertStr(filename2, ' ', '_');
                        filename2 := ConvertStr(filename2, ' ', '_');
                        FileCU.CopyClientFile(filename, HRsetup."Disciplinary Cases File" + FileCU.GetFileName(filename), true);
                        "Committee File-After Appeal" := HRsetup."Disciplinary Cases File" + FileCU.GetFileName(filename);
                        Message('File Attached Successfully');
                    end;
                end;
            }
            action("Attach File For Action Taken")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    filename := FileCU.OpenFileDialog('Select  File', '', '');
                    if filename <> '' then begin
                        HRsetup.Reset;
                        HRsetup.Get;
                        filename2 := Format(CurrentDateTime) + '_' + UserId;
                        filename2 := ConvertStr(filename2, '/', '_');
                        filename2 := ConvertStr(filename2, '\', '_');
                        filename2 := ConvertStr(filename2, ':', '_');
                        filename2 := ConvertStr(filename2, '.', '_');
                        filename2 := ConvertStr(filename2, ',', '_');
                        filename2 := ConvertStr(filename2, ' ', '_');
                        filename2 := ConvertStr(filename2, ' ', '_');
                        FileCU.CopyClientFile(filename, HRsetup."Disciplinary Cases File" + FileCU.GetFileName(filename), false);
                        "Action Taken File Path" := HRsetup."Disciplinary Cases File" + FileCU.GetFileName(filename);
                        Message('File Attached Successfully');
                    end;
                end;
            }*/
            action("Open Attached Supervisor  File")
            {
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowAttach;

                trigger OnAction()
                begin
                    if Rec."HOD File Path" <> '' then begin
                        HyperLink(Rec."HOD File Path");
                    end;
                end;
            }
            action("Open File For Action Taken")
            {
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowAttach;

                trigger OnAction()
                begin
                    if Rec."Action Taken File Path" <> '' then begin
                        HyperLink(Rec."Action Taken File Path");
                    end;
                end;
            }
            action("Open Attached HR File")
            {
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowAttach;

                trigger OnAction()
                begin
                    if Rec."HR File Path" <> '' then begin
                        HyperLink(Rec."HR File Path");
                    end;
                end;
            }
            action("Open Attached Commitee File")
            {
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowAttach;

                trigger OnAction()
                begin
                    if Rec."Committe File Path" <> '' then begin
                        HyperLink(Rec."Committe File Path");
                    end;
                end;
            }
            action("Open File After Appeal")
            {
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowAttach;

                trigger OnAction()
                begin
                    if Rec."Committee File-After Appeal" <> '' then begin
                        HyperLink(Rec."Committee File-After Appeal");
                    end;
                end;
            }
            action("Close Case")
            {
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec."Action Taken" = '' then begin
                        Error('Fill Action Taken!!');
                    end;
                    if Rec."Commitee Recommendation" = '' then begin
                        Error('Please Fill Commitee Recomendation!!');
                    end;

                    if Rec."Action Taken" <> '' then begin
                        Rec."Case Status" := Rec."Case Status"::Closed;
                    end;

                    Message('Taken to Closed Cases');

                    CurrPage.Close;
                end;
            }
            action("Appeal Case")
            {
                Image = EmployeeAgreement;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Appealvs;

                trigger OnAction()
                var
                    ans: Boolean;
                begin
                    ans := Confirm('Are you sure you want to Appeal this case?');
                    if Format(ans) = 'Yes' then begin
                        Rec."Case Status" := Rec."Case Status"::Appealed;
                    end;
                    Rec."No. of Appeals" += 1;
                    CurrPage.Close;
                end;
            }
            action("Close Case After Appeal")
            {
                Image = ClosePeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowAppeal;

                trigger OnAction()
                begin
                    if Rec."Committee Recon After Appeal" = '' then begin
                        Error('Please Fill Commitee Recommendation After Appeal!!!');
                    end;
                    Rec."Case Status" := Rec."Case Status"::Closed;
                    Message('Case moved to Closed Cases');
                    CurrPage.Close;
                end;
            }
            action("HR Close Case")
            {
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Ongoingvs;

                trigger OnAction()
                begin
                    if Rec."HR Recommendation" = '' then begin
                        Error('Fill HR Recommenation!!');
                    end;

                    //IF "Action Taken"<>'' THEN BEGIN
                    Rec."Case Status" := Rec."Case Status"::Closed;
                    //END;

                    Message('Taken to Closed Cases');

                    CurrPage.Close;
                end;
            }
            action("Move to Court")
            {
                Image = EmployeeAgreement;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = NotOnNew;

                trigger OnAction()
                var
                    ans: Boolean;
                begin
                    ans := Confirm('Are you sure you want to move this case to court?');
                    if Format(ans) = 'Yes' then begin
                        Rec."Case Status" := Rec."Case Status"::Court;
                    end;
                    //`"No. of Appeals"+=1;
                    CurrPage.Close;
                end;
            }
            action("Close Case2")
            {
                Caption = 'Close Case';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = NotOnNew;

                trigger OnAction()
                begin
                    if Rec."Court's Decision" = '' then begin
                        Error('Please Fill Courts Decision"!!');
                    end;
                    Rec."Case Status" := Rec."Case Status"::Closed;

                    Message('Taken to Closed Cases');

                    CurrPage.Close;
                end;
            }
            action("Move to Disciplinary Committee")
            {
                Image = ChangeTo;
                Visible = Ongoingvs;

                trigger OnAction()
                begin
                    Rec.TestField("HR Recommendation");
                    ans := Confirm('Are you sure you want to move this case to disciplinary committee?');
                    if Format(ans) = 'Yes' then begin
                        Rec."Case Status" := Rec."Case Status"::Committee;
                    end;

                    CurrPage.Close;
                end;
            }
            action("Move to CEO")
            {
                Image = CreateMovement;
                Visible = Commvs;

                trigger OnAction()
                begin
                    Rec.TestField("HR Recommendation");
                    ans := Confirm('Are you sure you want to move this case to CEO?');
                    if Format(ans) = 'Yes' then begin
                        Rec."Case Status" := Rec."Case Status"::Ceo;
                    end;

                    CurrPage.Close;
                end;
            }
            action("Move to Board")
            {
                Image = MoveUp;
                Visible = Boardvs;

                trigger OnAction()
                begin
                    Rec.TestField("HR Recommendation");
                    ans := Confirm('Are you sure you want to move this case to board?');
                    if Format(ans) = 'Yes' then begin
                        Rec."Case Status" := Rec."Case Status"::Board;
                    end;

                    CurrPage.Close;
                end;
            }
            /*action("Attach Board Descision")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    filename := FileCU.OpenFileDialog('Select  File', '', '');
                    if filename <> '' then begin
                        HRsetup.Reset;
                        HRsetup.Get;
                        filename2 := Format(CurrentDateTime) + '_' + UserId;
                        filename2 := ConvertStr(filename2, '/', '_');
                        filename2 := ConvertStr(filename2, '\', '_');
                        filename2 := ConvertStr(filename2, ':', '_');
                        filename2 := ConvertStr(filename2, '.', '_');
                        filename2 := ConvertStr(filename2, ',', '_');
                        filename2 := ConvertStr(filename2, ' ', '_');
                        filename2 := ConvertStr(filename2, ' ', '_');
                        FileCU.CopyClientFile(filename, HRsetup."Disciplinary Cases File" + FileCU.GetFileName(filename), false);
                        "Action Taken File Path" := HRsetup."Disciplinary Cases File" + FileCU.GetFileName(filename);
                        Message('File Attached Successfully');
                    end;
                end;
            }*/
            action("Open Board Descision File")
            {
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowAttach;

                trigger OnAction()
                begin
                    if Rec."HOD File Path" <> '' then begin
                        HyperLink(Rec."HOD File Path");
                    end;
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec."Case Status" <> Rec."Case Status"::New then begin
            Error('You cannot Create a new Record at this level. Create it in New Cases Tab');
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec."Case Status" <> Rec."Case Status"::New then begin
            Error('You cannot Create a new Record at this level. Create it in New Cases Tab');
        end;
    end;

    trigger OnOpenPage()
    begin
        openbl := false;
        ongoingbl := false;
        appealedbl := false;
        closedbl := false;
        boardbl := false;
        atceobl := false;
        courtbl := false;
        Openvs := false;
        Ongoingvs := false;
        Commvs := false;
        Ceovs := false;
        Boardvs := false;
        Closedvs := false;
        Appealvs := false;
        Courtvs := false;
        ShowAttach := false;
        ShowClose := false;
        NotOnNew := false;
        ShowAppeal := false;
        Hredit := true;
        CommEdit := true;
        CeoEdit := true;
        Boardedit := true;
        SupEdit := true;
        AppealEdit := true;

        if Rec."Case Status" = Rec."Case Status"::New then begin
            openbl := true;
            Openvs := true;
        end;


        if Rec."Case Status" = Rec."Case Status"::Ongoing then begin
            ongoingbl := true;
            Ongoingvs := true;
            //Commvs:=TRUE;
            Ceovs := true;
            Boardvs := true;
            SupEdit := false;
        end;
        if Rec."Case Status" = Rec."Case Status"::Appealed then begin
            appealedbl := true;

        end;
        if Rec."Case Status" = Rec."Case Status"::Closed then begin
            closedbl := true;
        end;
        if Rec."Case Status" = Rec."Case Status"::Committee then begin
            commttbl := true;
            Commvs := true;
            Ceovs := true;
            Boardvs := true;
            ongoingbl := true;
            Hredit := false;
            SupEdit := false;
        end;
        if Rec."Case Status" = Rec."Case Status"::Ceo then begin
            commttbl := true;
            //Commvs:=TRUE;
            Ceovs := true;
            atceobl := true;
            Boardvs := true;
            ongoingbl := true;
            Hredit := false;
            CommEdit := false;
            SupEdit := false;
        end;
        if Rec."Case Status" = Rec."Case Status"::Board then begin
            commttbl := true;
            //Commvs:=TRUE;
            Ceovs := true;
            atceobl := true;
            Boardvs := false;
            ongoingbl := true;
            Hredit := false;
            boardbl := true;
            CommEdit := false;
            SupEdit := false;
            CeoEdit := false;
        end;

        if ((Rec."Case Status" = Rec."Case Status"::Appealed) or (Rec."Case Status" = Rec."Case Status"::Closed)) then begin
            Appealvs := true;
            commttbl := true;
            //Commvs:=TRUE;
            Ceovs := true;
            atceobl := true;
            Boardvs := false;
            ongoingbl := true;
            Hredit := false;
            boardbl := true;
            CommEdit := false;
            SupEdit := false;
            CeoEdit := false;
            Boardedit := false;
        end;
        if ((Rec."Case Status" = Rec."Case Status"::Closed) or (Rec."Case Status" = Rec."Case Status"::Court)) then begin
            NotOnNew := true;
            commttbl := true;
            //Commvs:=TRUE;
            Ceovs := true;
            atceobl := true;
            Boardvs := false;
            ongoingbl := true;
            Hredit := false;
            boardbl := true;
            CommEdit := false;
            CeoEdit := false;
            SupEdit := false;
            Boardedit := false;
        end;
    end;

    var
        ongoingbl: Boolean;
        appealedbl: Boolean;
        closedbl: Boolean;
        openbl: Boolean;
        FileCU: Codeunit "File Management";
        filename: Text;
        HRsetup: Record "Human Resources Setup";
        filename2: Text;
        appealclosebl: Boolean;
        courtbl: Boolean;
        Txt0001: Label 'Please attach evidence of action taken before inserting the action taken reson.';
        atceobl: Boolean;
        boardbl: Boolean;
        commttbl: Boolean;
        Openvs: Boolean;
        Ongoingvs: Boolean;
        Commvs: Boolean;
        Ceovs: Boolean;
        Boardvs: Boolean;
        Closedvs: Boolean;
        Appealvs: Boolean;
        Courtvs: Boolean;
        ShowAttach: Boolean;
        ShowClose: Boolean;
        NotOnNew: Boolean;
        ShowAppeal: Boolean;
        ans: Boolean;
        Hredit: Boolean;
        CommEdit: Boolean;
        CeoEdit: Boolean;
        Boardedit: Boolean;
        SupEdit: Boolean;
        AppealEdit: Boolean;
}