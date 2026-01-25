page 51525432 "Salary Scales List"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Salary Scales";
    Caption = 'Salary Grades';

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Scale; Rec.Scale)
                {
                }
                field("Seniority Percent (%)"; Rec."Seniority Percent (%)")
                { }
                field("Minimum Pointer"; Rec."Minimum Pointer")
                {
                }
                field("Maximum Pointer"; Rec."Maximum Pointer")
                {
                }
                field("Medical Cover Category"; Rec."Medical Cover Category")
                {
                    Visible = false;
                }
                field("In Patient Limit"; Rec."In Patient Limit")
                {
                    Visible = false;
                }
                field("Out Patient Limit"; Rec."Out Patient Limit")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Pointers)
            {
                Caption = 'Notches';
                action(Action1000000015)
                {
                    Caption = 'Notches';
                    Image = DepositLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Scale Benefits";
                    RunPageLink = "Salary Scale" = FIELD(Scale);
                    RunPageView = SORTING("Salary Scale", "Salary Pointer", "ED Code");
                }
            }
        }
    }
}