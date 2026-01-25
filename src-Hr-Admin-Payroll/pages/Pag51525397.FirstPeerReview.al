page 51525397 "First Peer Review"
{
    ApplicationArea = All;
    CardPageID = "Peer Appraisal Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Peer Appraisal Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Period; Rec.Period)
                {
                }
                field("Staff No"; Rec."Staff No")
                {
                }
                field("Staff Name"; StaffName)
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        ObjEmp.Reset;
        ObjEmp.SetRange("User ID", UserId);//USERID UMSOMIHVKENYA\DTOBON UMSOMIHVKENYA\AAKINYI UMSOMIHVKENYA\NLANGAT
        if ObjEmp.Find('-') then begin
            Rec.SetFilter("Peers Filter", '*' + ObjEmp."No." + '*'); //MESSAGE('%1',ObjEmp."No.");
        end else
            Rec.SetFilter("Peers Filter", 'DisplayNothing');//ERROR('Your employment records have not been found! Kindly liaise with HR.');
    end;

    var
        ObjEmp: Record Employee;
        Emp: Record Employee;
        StaffName: Text[100];
}