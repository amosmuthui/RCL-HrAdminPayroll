page 52211560 "Meal Order Setup"
{
    ApplicationArea = All;
    Caption = 'Meal Order Setup';
    PageType = List;
    SourceTable = "Meal Order";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field("task assignments "; Rec."task assignments ")
                {
                    ToolTip = 'Specifies the value of the task assignments field.', Comment = '%';
                }
                field("Meal Orders"; Rec."Meal Orders")
                {
                    ToolTip = 'Specifies the value of the Meal Orders field.', Comment = '%';
                }
            }
        }
    }
}
