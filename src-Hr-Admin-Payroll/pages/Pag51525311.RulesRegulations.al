page 51525311 "Rules & Regulations"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Rules & Regulations";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                }
                field(Date; Rec.Date)
                {
                }
                field("Rules & Regulations"; Rec."Rules & Regulations")
                {
                }
                field("Document Link"; Rec."Document Link")
                {
                }
                field(Remarks; Rec.Remarks)
                {
                }
                field("Language Code (Default)"; Rec."Language Code (Default)")
                {
                }
                field(Attachement; Rec.Attachement)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            /*group("&Attachment")
            {
                Caption = '&Attachment';
                Image = AnalysisView;
                action(Open)
                {
                    Caption = 'Open';
                    Image = OpenJournal;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Return';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if InteractTemplLanguage.Get(Code, "Language Code (Default)") then
                            InteractTemplLanguage.OpenAttachment;
                    end;
                }
                action(Create)
                {
                    Caption = 'Create';
                    Ellipsis = true;
                    Image = CreateForm;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if not InteractTemplLanguage.Get(Code, "Language Code (Default)") then begin
                            InteractTemplLanguage.Init;
                            InteractTemplLanguage."Interaction Template Code" := Code;
                            InteractTemplLanguage."Language Code" := "Language Code (Default)";
                            InteractTemplLanguage.Description := "Rules & Regulations";
                        end;
                        InteractTemplLanguage.CreateAttachment;
                        CurrPage.Update;
                        Attachement := Attachement::Yes;
                        Rec.Modify;
                    end;
                }
                action("Copy &from")
                {
                    Caption = 'Copy &from';
                    Ellipsis = true;
                    Image = Copy;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if not InteractTemplLanguage.Get(Code, "Language Code (Default)") then begin
                            InteractTemplLanguage.Init;
                            InteractTemplLanguage."Interaction Template Code" := Code;
                            InteractTemplLanguage."Language Code" := "Language Code (Default)";
                            InteractTemplLanguage.Description := "Rules & Regulations";
                            InteractTemplLanguage.Insert;
                            Commit;
                        end;
                        InteractTemplLanguage.CopyFromAttachment;
                        CurrPage.Update;
                        Attachement := Attachement::Yes;
                        Rec.Modify;
                    end;
                }
                action(Import)
                {
                    Caption = 'Import';
                    Ellipsis = true;
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if not InteractTemplLanguage.Get(Code, "Language Code (Default)") then begin
                            InteractTemplLanguage.Init;
                            InteractTemplLanguage."Interaction Template Code" := Code;
                            InteractTemplLanguage."Language Code" := "Language Code (Default)";
                            InteractTemplLanguage.Description := "Rules & Regulations";
                            InteractTemplLanguage.Insert;
                        end;
                        InteractTemplLanguage.ImportAttachment;
                        CurrPage.Update;
                        Attachement := Attachement::Yes;
                        Rec.Modify;
                    end;
                }
                action("E&xport")
                {
                    Caption = 'E&xport';
                    Ellipsis = true;
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if InteractTemplLanguage.Get(Code, "Language Code (Default)") then
                            InteractTemplLanguage.ExportAttachment;
                    end;
                }
                action(Remove)
                {
                    Caption = 'Remove';
                    Ellipsis = true;
                    Image = RemoveContacts;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if InteractTemplLanguage.Get(Code, "Language Code (Default)") then begin
                            InteractTemplLanguage.RemoveAttachment(true);
                            Attachement := Attachement::No;
                            Rec.Modify;
                        end;
                    end;
                }
            }*/
        }
    }
}