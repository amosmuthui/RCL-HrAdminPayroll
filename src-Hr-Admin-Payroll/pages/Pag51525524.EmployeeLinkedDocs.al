page 51525524 "Employee Linked Docs"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = Employee;
    SourceTableView = WHERE(Status = CONST(Active));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field("No."; Rec."No.")
                {
                }
                field("First Name"; Rec."First Name")
                {
                }
                field("Middle Name"; Rec."Middle Name")
                {
                }
                field("Last Name"; Rec."Last Name")
                {
                }
                field(Initials; Rec.Initials)
                {
                }
                field("ID Number"; Rec."ID Number")
                {
                }
                field(Gender; Rec.Gender)
                {
                }
                field(Position; Rec.Position)
                {
                }
                field("Contract Type"; Rec."Contract Type")
                {
                }
                field("Date Of Join"; Rec."Date Of Join")
                {
                }
            }
            label(Control1000000030)
            {
                CaptionClass = Text19034836;
                ShowCaption = false;
                Style = Strong;
                StyleExpr = TRUE;
            }
            part(DocLink; "Document Link")
            {
                SubPageLink = "Employee No" = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Attachment")
            {
                Caption = '&Attachment';
                action(Open)
                {
                    Caption = 'Open';
                    ShortCutKey = 'Return';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if DocLink.Get(Rec."No.", CurrPage.DocLink.PAGE.GetDocument) then begin
                            if InteractTemplLanguage.Get(CurrPage.DocLink.PAGE.GetDocument, DocLink."Language Code (Default)") then
                                InteractTemplLanguage.OpenAttachment;
                        end;
                    end;
                }
                action(Create)
                {
                    Caption = 'Create';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if DocLink.Get(Rec."No.", CurrPage.DocLink.PAGE.GetDocument) then begin
                            if not InteractTemplLanguage.Get(CurrPage.DocLink.PAGE.GetDocument, DocLink."Language Code (Default)") then begin
                                InteractTemplLanguage.Init;
                                InteractTemplLanguage."Interaction Template Code" := CurrPage.DocLink.PAGE.GetDocument;
                                InteractTemplLanguage."Language Code" := DocLink."Language Code (Default)";
                                InteractTemplLanguage.Description := CurrPage.DocLink.PAGE.GetDocument;
                            end;
                            InteractTemplLanguage.CreateAttachment;
                            CurrPage.Update;
                            DocLink.Attachement := DocLink.Attachement::Yes;
                            DocLink.Modify;
                        end;
                    end;
                }
                action("Copy &from")
                {
                    Caption = 'Copy &from';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if DocLink.Get(Rec."No.", CurrPage.DocLink.PAGE.GetDocument) then begin
                            if not InteractTemplLanguage.Get(DocLink."Document Description", DocLink."Language Code (Default)") then begin
                                InteractTemplLanguage.Init;
                                InteractTemplLanguage."Interaction Template Code" := DocLink."Document Description";
                                InteractTemplLanguage."Language Code" := DocLink."Language Code (Default)";
                                InteractTemplLanguage.Description := DocLink."Document Description";
                                InteractTemplLanguage.Insert;
                                Commit;
                            end;
                            InteractTemplLanguage.CopyFromAttachment;
                            CurrPage.Update;
                            DocLink.Attachement := DocLink.Attachement::Yes;
                            DocLink.Modify;
                        end;
                    end;
                }
                action(Import)
                {
                    Caption = 'Import';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if DocLink.Get(Rec."No.", CurrPage.DocLink.PAGE.GetDocument) then begin
                            if not InteractTemplLanguage.Get(DocLink."Document Description", DocLink."Language Code (Default)") then begin
                                InteractTemplLanguage.Init;
                                InteractTemplLanguage."Interaction Template Code" := DocLink."Document Description";
                                InteractTemplLanguage."Language Code" := DocLink."Language Code (Default)";
                                InteractTemplLanguage.Description := DocLink."Document Description";
                                InteractTemplLanguage.Insert;
                            end;
                            InteractTemplLanguage.ImportAttachment;
                            CurrPage.Update;
                            DocLink.Attachement := DocLink.Attachement::Yes;
                            DocLink.Modify;
                        end;
                    end;
                }
                action("E&xport")
                {
                    Caption = 'E&xport';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if DocLink.Get(Rec."No.", CurrPage.DocLink.PAGE.GetDocument) then begin
                            if InteractTemplLanguage.Get(DocLink."Document Description", DocLink."Language Code (Default)") then
                                InteractTemplLanguage.ExportAttachment;
                        end;
                    end;
                }
                action(Remove)
                {
                    Caption = 'Remove';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if DocLink.Get(Rec."No.", CurrPage.DocLink.PAGE.GetDocument) then begin
                            if InteractTemplLanguage.Get(DocLink."Document Description", DocLink."Language Code (Default)") then begin
                                InteractTemplLanguage.RemoveAttachment(true);
                                DocLink.Attachement := DocLink.Attachement::No;
                                DocLink.Modify;
                            end;
                        end;
                    end;
                }
            }
        }
    }

    var
        InteractTemplLanguage: Record "Interaction Tmpl. Language";
        DocLink: Record "Document Link";
        Text19034836: Label 'Employee Linked Documents';
}