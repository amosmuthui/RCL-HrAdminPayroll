page 51525410 "Additional Instructors"
{
    ApplicationArea = All;
    Caption = 'Additional Instructors';
    PageType = List;
    SourceTable = "Additional Instructors";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field(Category; Rec.Category)
                {
                    trigger OnValidate()
                    begin
                        if Rec."Entry No." = 0 then begin
                            Rec.Validate("Class No.");
                            Rec.Insert();
                        end;
                    end;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';

                    trigger OnDrillDown()
                    begin
                        if Rec."Entry No." = 0 then begin
                            Rec.Validate("Class No.");
                            Rec.Insert();
                        end;
                    end;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field(Allowance; Rec.Allowance)
                {
                    ToolTip = 'Specifies the value of the Allowance field.', Comment = '%';
                }
            }
        }
    }
}