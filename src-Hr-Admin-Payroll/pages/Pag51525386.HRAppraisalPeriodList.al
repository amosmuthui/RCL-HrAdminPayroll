page 51525386 "HR Appraisal Period List"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    PromotedActionCategories = 'New,Process,Reports,Periodic Activities';
    SourceTable = "HR Appraisal Periods";
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Period Start Date"; Rec."Period Start Date")
                {
                }
                field("Mid Year Review Date"; Rec."Mid Year Review Date")
                {
                }
                field("Period End Date"; Rec."Period End Date")
                {
                }
                field("Allow Edits From"; Rec."Allow Edits From")
                {
                }
                field("Allow Edits To"; Rec."Allow Edits To")
                {
                }
                field(Open; Rec.Open)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000007; Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Move Appraisals to Mid Year")
            {
                Image = MoveToNextPeriod;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category4;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;

                trigger OnAction()
                begin

                    if Confirm('Do you wish to move all appraisal to Mid Year evaluation', false) = false then Error('Process aborted');
                end;
            }
            action("Move Appraisals to End Year")
            {
                Image = MakeAgreement;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category4;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Do you wish to move all appraisal to End Year evaluation', false) = false then Error('Process aborted');
                end;
            }
        }
    }

    var
        HRAppraisalHeader: Record "HR Appraisal Header";
}