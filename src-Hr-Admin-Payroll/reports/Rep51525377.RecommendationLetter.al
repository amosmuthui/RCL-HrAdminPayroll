report 51525377 "Recommendation Letter"
{
    ApplicationArea = All;
    Caption = 'Recommendation Letter';
    UsageCategory = None;
    DefaultLayout = Word;
    WordLayout = './src/reports/layouts/BuiltInRecommendationLetter.docx';
    dataset
    {
        dataitem(RecommendationLetters; "Recommendation Letters")
        {
            column(EmpNo; "Emp No.")
            {
            }
            column(EmpName; "Emp Name")
            {
            }
            column(PositionTitle; "Position Title")
            {
            }
            column(Nationality; Nationality)
            {
            }
            column(TravelDetails; "Travel Details")
            {
            }
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
}
