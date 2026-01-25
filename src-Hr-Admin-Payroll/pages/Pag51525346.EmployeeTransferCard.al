page 51525346 "Employee Transfer Card"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "Employee Transfer Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Date Created"; Rec."Date Created")
                {
                    Editable = false;
                }
                field("User Id"; Rec."User Id")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                }
                field("Effective Transfer Date"; Rec."Effective Transfer Date")
                {
                }
            }
            part(Control6; "Employee Transfer Lines")
            {
                SubPageLink = "Transfer No" = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send for Approval")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to send approval request?') = true then begin
                        Rec.TestField("Effective Transfer Date");
                        Rec.TestField(Status, Rec.Status::Open);
                        Rec.Status := Rec.Status::Released;
                        Rec.Modify;


                        ///Update Employee Date of Appointment
                        EmpTransLines.Reset;
                        EmpTransLines.SetRange("Transfer No", Rec."No.");
                        if EmpTransLines.FindFirst then begin
                            repeat
                                EmpTransLines.TestField("Employee No.");
                                EmpTransLines.TestField("New Job Title Code");
                                EmpTransLines.TestField("New Category");
                                EmpTransLines.TestField("New Directorate");
                                EmpTransLines.TestField("New Department");
                                EmpTransLines.TestField("New Location Code");
                                EmpTransLines.TestField("Global Dimension 1 Code");
                                EmpTransLines.TestField("Global Dimension 2 Code");

                                Employees.Reset;
                                Employees.SetRange("No.", EmpTransLines."Employee No.");
                                if Employees.FindFirst then begin
                                    Employees."Date of Appointment" := Rec."Effective Transfer Date";
                                    Employees.Position := EmpTransLines."New Job Title Code";
                                    Employees.Validate(Position);
                                    //Employees.Category := EmpTransLines."New Category";
                                    Employees."Responsibility Center" := EmpTransLines."New Directorate";
                                    Employees.Validate("Responsibility Center");
                                    Employees."Sub Responsibility Center" := EmpTransLines."New Department";
                                    Employees."Global Dimension 1 Code" := EmpTransLines."Global Dimension 1 Code";
                                    Employees.Validate("Global Dimension 1 Code");
                                    Employees."Global Dimension 2 Code" := EmpTransLines."Global Dimension 2 Code";
                                    Employees.Validate("Global Dimension 2 Code");
                                    Employees."Location Code" := EmpTransLines."New Location Code";
                                    Employees.Validate("Location Code");
                                    Employees.Modify;
                                end;
                            until EmpTransLines.Next = 0;

                        end;
                        Message('Transfer completed successfully!');
                        CurrPage.Close;
                    end;
                end;
            }
        }
    }

    var
        Employees: Record Employee;
        EmpTransLines: Record "Employee Transfer Lines";
}