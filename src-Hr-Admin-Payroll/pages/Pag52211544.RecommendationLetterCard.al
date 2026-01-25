page 52211544 "Recommendation Letter Card"
{
    ApplicationArea = All;
    Caption = 'Recommendation Letter Card';
    PageType = Card;
    SourceTable = "Recommendation Letters";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Emp No."; Rec."Emp No.")
                {
                    ToolTip = 'Specifies the value of the Emp No. field.', Comment = '%';
                }
                field("Emp Name"; Rec."Emp Name")
                {
                    ToolTip = 'Specifies the value of the Emp Name field.', Comment = '%';
                }
                field("Position Code"; Rec."Position Code")
                {
                    ToolTip = 'Specifies the value of the Position Code field.', Comment = '%';
                }
                field("Position Title"; Rec."Position Title")
                {
                    ToolTip = 'Specifies the value of the Position Title field.', Comment = '%';
                }
                field("Country Code"; Rec."Country Code")
                {
                    ToolTip = 'Specifies the value of the Country Code field.', Comment = '%';
                }
                field(Nationality; Rec.Nationality)
                {
                    ToolTip = 'Specifies the value of the Nationality field.', Comment = '%';
                }
                field("Travel Details"; Rec."Travel Details")
                {
                    ToolTip = 'Specifies the value of the Travel Details field.', Comment = '%';
                    MultiLine = true;
                }
                field("Template No"; Rec."Template No")
                {
                    ToolTip = 'Specifies the value of the Template No field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(GenerateLetter)
            {
                Caption = 'Generate Letter';
                Image = DepositSlip;

                trigger OnAction()
                var
                    RecommendationLetters: Record "Recommendation Letters";
                    ReportLayoutSelection: Record "Report Layout Selection";
                    LetterTemplates: Record "Letter Templates";
                    RecommLetterRpt: Report "Recommendation Letter";
                begin
                    if Rec."Template No" = 0 then
                        Error('You must select the Template to be used by this letter.');
                    RecommendationLetters.Reset;
                    RecommendationLetters.SetRange("Entry No.", Rec."Entry No.");
                    if RecommendationLetters.Find('-') then begin
                        //Update layout first
                        if LetterTemplates.Get(Rec."Template No") then begin
                            ReportLayoutSelection.Reset();
                            ReportLayoutSelection.SetRange("Report ID", Report::"Recommendation Letter");
                            ReportLayoutSelection.SetRange("Company Name", CompanyName);
                            if ReportLayoutSelection.FindFirst() then begin
                                ReportLayoutSelection."Custom Report Layout Code" := LetterTemplates."Custom Layout Code";
                                ReportLayoutSelection.SetTempLayoutSelected(LetterTemplates."Custom Layout Code");
                                ReportLayoutSelection.Modify();
                            end else begin
                                ReportLayoutSelection.Init();
                                ReportLayoutSelection."Report ID" := Report::"Recommendation Letter";
                                ReportLayoutSelection.Validate(Type, ReportLayoutSelection.Type::"Custom Layout");
                                ReportLayoutSelection."Company Name" := CompanyName;
                                ReportLayoutSelection."Custom Report Layout Code" := LetterTemplates."Custom Layout Code";
                                ReportLayoutSelection.SetTempLayoutSelected(LetterTemplates."Custom Layout Code");
                                ReportLayoutSelection.Insert();
                            end;
                            Commit();
                            REPORT.Run(Report::"Recommendation Letter", true, true, RecommendationLetters);
                        end else
                            Error('Template not found!');
                    end;
                end;
            }
        }


        area(Promoted)
        {
            group(Home)
            {
                actionref("GenerateLetterPromoted"; GenerateLetter) { }
            }
        }
    }

}
