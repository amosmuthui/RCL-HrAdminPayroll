page 51525500 "Employee Relatives Changes"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    Caption = 'Employee Relative Changes';
    DataCaptionFields = "Employee No.";
    PageType = List;
    SourceTable = "Employee Relative Changes";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Relative Code"; Rec."Relative Code")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies a relative code for the employee.';
                }
                field(Relationship; Rec.Relationship)
                { }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the first name of the employee''s relative.';
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the middle name of the employee''s relative.';
                    Visible = false;
                }
                field("Last Name"; Rec."Last Name")
                { }
                field("Birth Date"; Rec."Birth Date")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the relative''s date of birth.';
                }
                field(Gender; Rec.Gender)
                { }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the relative''s telephone number.';
                }
                field("Email Address"; Rec."Email Address")
                { }
                field("Relative's Employee No."; Rec."Relative's Employee No.")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the relative''s employee number, if the relative also works at the company.';
                    Visible = false;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Specifies if a comment was entered for this entry.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Relative")
            {
                Caption = '&Relative';
                Image = Relatives;
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = CONST("Employee Relative"),
                                  "No." = FIELD("Employee No."),
                                  "Table Line No." = FIELD("Line No.");
                    ToolTip = 'View or add comments for the record.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        /*CanEditCard := false;
        CanEditPaymentInfo := false;
        CanEditLeaveInfo := false;
        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        if UserSetup.FindFirst() then begin
            CanEditCard := UserSetup."Can Edit Emp Card";
            CanEditPaymentInfo := UserSetup."Can Edit Payroll Info";
            CanEditLeaveInfo := UserSetup."Can Edit Leave Entitlement";
        end;
        CurrPage.Editable(true);
        if (CanEditCard = false) and (CanEditLeaveInfo = false) then
            CurrPage.Editable(false);*/
    end;

    var
        UserSetup: Record "User Setup";
        CanEditCard: Boolean;
        CanEditPaymentInfo: Boolean;
        CanEditLeaveInfo: Boolean;
}