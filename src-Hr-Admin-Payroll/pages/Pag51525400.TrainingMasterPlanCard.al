page 51525400 "Training Master Plan Card"
{
    ApplicationArea = All;
    Caption = 'Course Card';
    PageType = Card;
    SourceTable = "Training Master Plan Header";
    //DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = EnableEditing;

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.';
                }
                field("Theory/Practical"; Rec."Theory/Practical")
                { }
                field(Category; Rec.Category)
                {
                    Visible = false;

                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    MultiLine = true;
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Course Abbreviation"; Rec."Course Abbreviation")
                { }
                field("Mandatory/Optional"; Rec."Mandatory/Optional")
                {
                    ToolTip = 'Specifies the value of the Mandatory/Optional field.';
                }
                field(Recurrence; Rec.Recurrence)
                {
                    ToolTip = 'Specifies the value of the Recurrence field.';
                }
                field(Frequency; Rec.Frequency)
                {
                    Caption = 'Frequency (H,D,M,Y)';
                    ToolTip = 'Specify a number then letter H for hours, D-days, M-months, Y-years eg 3M';
                }
                field("Approximate Duration"; Rec."Approximate Duration")
                {
                    Caption = 'Approximate Duration (H,D,M,Y)';
                    ToolTip = 'Specify a number then letter H for hours, D-days, M-months, Y-years eg 3M';
                }
                field("Notification Period Notice"; Rec."Notification Period Notice")
                {
                    ToolTip = 'Specifies the value of the Notification Period Notice field.';
                }
                field(Objectives; Rec.Objectives)
                {
                    MultiLine = true;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Legacy Data"; Rec."Legacy Data")
                { }
            }
            part("Applicable Departments"; "Training Master Plan Lines")
            {
                Caption = 'Departments';
                SubPageLink = "No." = FIELD("No.");
                UpdatePropagation = Both;
                Editable = EnableEditing;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Apply to all Departments")
            {
                Caption = 'Apply to all Departments';
                Promoted = true;
                PromotedCategory = Process;
                Enabled = EnableEditing;

                trigger OnAction()
                var
                    TMALines: Record "Training Master Plan Lines";
                    TMALineInit: Record "Training Master Plan Lines";
                    Depts: Record "Responsibility Center";
                    LineNo: Integer;
                begin
                    if not Confirm('Are you sure this training applies to all departments in the organization?') then exit;//\The lines will be populated with all existing departments!
                    LineNo := 0;
                    TMALines.Reset();
                    IF TMALines.FindLast() then
                        LineNo := TMALines."Line No.";

                    Depts.Reset();
                    if Depts.FindSet() then
                        repeat
                            TMALines.Reset();
                            TMALines.SetRange("No.", Rec."No.");
                            TMALines.SetRange("Dept Code", Depts."Code");
                            if not TMALines.FindFirst() then begin
                                LineNo += 1;
                                TMALineInit.Reset();
                                TMALineInit.Init();
                                TMALineInit."Line No." := LineNo;
                                TMALineInit."No." := Rec."No.";
                                TMALineInit."Dept Code" := Depts."Code";
                                TMALineInit.Validate("Dept Code");
                                TMALineInit.Insert()
                            end;
                        until Depts.Next() = 0;
                    Message('Done!');
                end;
            }
            action("Import Legacy Data")
            {
                RunObject = report "Import Legacy Training Data";
            }
        }
    }

    trigger OnOpenPage()
    begin
        //CurrPage.Editable(true);
        EnableEditing := true;
        if Rec.IsAReadOnlyUser() then
            EnableEditing := false;//CurrPage.Editable(false);
    end;

    var
        EnableEditing: Boolean;
}