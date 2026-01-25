table 51525300 "HR Cues"
{
    fields
    {
        field(1; "Primary Key"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Active Emplooyees"; Integer)
        {
            Caption = 'Active Employees';
            CalcFormula = Count(Employee WHERE(Status = FILTER(Active)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Released Leave Applications"; Integer)
        {
            CalcFormula = Count("Employee Leave Application" WHERE(Status = FILTER(Released)));
            FieldClass = FlowField;
        }
        /*field(4; "Approved Store Requisitions"; Integer)
        {
            CalcFormula = Count("Requisition Header" WHERE(Status = FILTER(Released)));
            FieldClass = FlowField;
        }*/
        field(5; "Fixed Assets"; Integer)
        {
            CalcFormula = Count("Fixed Asset");
            FieldClass = FlowField;
        }
        field(6; "Requests To Approve"; Integer)
        {
            CalcFormula = Count("Approval Entry");// WHERE("Approver ID" = FILTER(UserId)));
            FieldClass = FlowField;
        }
        field(7; Items; Integer)
        {
            CalcFormula = Count(Item);
            FieldClass = FlowField;
        }
        /*field(8; "Bid Analysis Pending Approval"; Integer)
        {
            CalcFormula = Count("Bid Analysis Header" WHERE(Status = FILTER("Pending Approval")));
            FieldClass = FlowField;
        }
        field(9; "Purchase Requisitions Pending"; Integer)
        {
            CalcFormula = Count("Requisition Header" WHERE("Document Type" = FILTER("Purchase Requisition"),
                                                            Status = FILTER("Pending Approval")));
            FieldClass = FlowField;
        }*/
        field(10; Countries; Integer)
        {
            CalcFormula = Count("Country/Region" where("Is Payroll Country" = const(true)));
            FieldClass = FlowField;
        }
        field(11; Currencies; Integer)
        {
            CalcFormula = Count(Currency);
            FieldClass = FlowField;
        }

        field(12; "Pay Periods"; Integer)
        {
            CalcFormula = Count("Payroll Period");
            FieldClass = FlowField;
        }
        field(13; Earnings; Integer)
        {
            CalcFormula = Count(Earnings);
            FieldClass = FlowField;
        }
        field(14; Deductions; Integer)
        {
            CalcFormula = Count(Deductions);
            FieldClass = FlowField;
        }
        field(15; "Job Positions"; Integer)
        {
            CalcFormula = Count("Company Jobs");
            FieldClass = FlowField;
        }
        field(16; "Pending Recruitment Needs"; Integer)
        {
            CalcFormula = Count("Recruitment Needs" WHERE(Status = FILTER("Pending Approval")));
            FieldClass = FlowField;
        }
        field(17; "Completed Job Adverts"; Integer)
        {
            CalcFormula = Count("Recruitment Needs" WHERE("Current Stage" = CONST(Completed)));
            FieldClass = FlowField;
        }
        field(18; "Pending Leave Applications"; Integer)
        {
            CalcFormula = Count("Employee Leave Application" WHERE(Status = FILTER("Pending Approval")));
            FieldClass = FlowField;
        }
        field(19; "Pending Targets"; Integer)
        {
            CalcFormula = Count("Staff Target Objectives" WHERE("Sent to Supervisor" = FILTER(true),
                                                            "Approved By Supervisor" = FILTER(false)));
            FieldClass = FlowField;
        }
        field(20; "Approved Targets"; Integer)
        {
            CalcFormula = Count("Staff Target Objectives" WHERE("Sent to Supervisor" = FILTER(true),
                                                            "Approved By Supervisor" = FILTER(true)));
            FieldClass = FlowField;
        }
        field(21; "Mid-Year Reviews"; Integer)
        {
            CalcFormula = Count("Mid Year Appraisal");
            FieldClass = FlowField;
        }
        field(22; Appraissals; Integer)
        {
            CalcFormula = Count("Peer Appraisal Header");
            FieldClass = FlowField;
        }
        field(23; "Training Courses"; Integer)
        {
            CalcFormula = Count("Training Master Plan Header");
            FieldClass = FlowField;
        }
        field(24; "Pending Training Requests"; Integer)
        {
            CalcFormula = Count("Training Request" WHERE(Status = FILTER("Pending Approval")));
            FieldClass = FlowField;
        }
        field(25; "Completed Trainings"; Integer)
        {
            CalcFormula = Count("Training Schedules" WHERE(Status = FILTER(Done)));
            FieldClass = FlowField;
        }
        field(26; "Ongoing Trainings"; Integer)
        {
            CalcFormula = Count("Training Schedules" WHERE(Status = FILTER(Ongoing)));
            FieldClass = FlowField;
        }
        field(27; "Upcoming Trainings"; Integer)
        {
            CalcFormula = Count("Training Schedules" WHERE(Status = FILTER(Pending)));
            FieldClass = FlowField;
        }
        field(28; "Active Employees"; Integer)
        {
            Caption = 'Active Employees';
            CalcFormula = Count(Employee WHERE(Status = FILTER(Active)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(29; "Airtime Allocation Batches"; Integer)
        {
            CalcFormula = Count("Airtime Allocation Batches");
            FieldClass = FlowField;
        }
        field(30; "Airtime Requests"; Integer)
        {
            CalcFormula = Count("Airtime Requests");
            FieldClass = FlowField;
        }
        field(31; "Hotels"; Integer)
        {
            CalcFormula = Count(Hotels);
            FieldClass = FlowField;
        }
        field(32; "Pending Bookings"; Integer)
        {
            CalcFormula = Count("Hotel Booking Requests" where("Approval Status" = const("Pending Approval")));
            FieldClass = FlowField;
        }
        field(33; "Approved Bookings"; Integer)
        {
            CalcFormula = Count("Hotel Booking Requests" where("Approval Status" = const(Released)));
            FieldClass = FlowField;
        }
        field(34; "Reservations"; Integer)
        {
            CalcFormula = Count("Hotel Booking Requests" where("Reservation Status" = const(Reserved)));
            FieldClass = FlowField;
        }
        field(35; "Cancellations"; Integer)
        {
            CalcFormula = Count("Hotel Booking Requests" where("Reservation Status" = const(Cancelled)));
            FieldClass = FlowField;
        }
        field(36; "Pending Refreshment Requests"; Integer)
        {
            CalcFormula = Count("Refreshment Requests" where("Approval Status" = const("Pending Approval")));
            FieldClass = FlowField;
        }
        field(37; "Approved Refreshment Requests"; Integer)
        {
            CalcFormula = Count("Refreshment Requests" where("Approval Status" = const(Released)));
            FieldClass = FlowField;
        }
        field(38; Rooms; Integer)
        {
            CalcFormula = Count(Rooms);
            FieldClass = FlowField;
        }
        field(39; "Pending Room Requests"; Integer)
        {
            CalcFormula = Count("Room Booking Requests" where("Approval Status" = const("Pending Approval")));
            FieldClass = FlowField;
        }
        field(40; "Approved Room Requests"; Integer)
        {
            CalcFormula = Count("Room Booking Requests" where("Approval Status" = const(Released)));
            FieldClass = FlowField;
        }
        field(41; "Letter Templates"; Integer)
        {
            CalcFormula = Count("Letter Templates");
            FieldClass = FlowField;
        }
        field(42; "Pending Req Fees Requests"; Integer)
        {
            Caption = 'Pending Requisition Fees Requests';
            CalcFormula = Count("Requisition Fees Requests" where("Approval Status" = const("Pending Approval")));
            FieldClass = FlowField;
        }
        field(43; "Approved Req Fees Requests"; Integer)
        {
            Caption = 'Approved Requisition Fees Requests';
            CalcFormula = Count("Requisition Fees Requests" where("Approval Status" = const(Released)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure PendingApprovalRequestsForThisUser(): Integer
    var
        ApprovalEntries: Record "Approval Entry";
        ApprovalEntriesCount: Decimal;
    begin
        ApprovalEntriesCount := 0;

        ApprovalEntries.Reset();
        ApprovalEntries.SetRange("Approver ID", UserId);
        ApprovalEntries.SetRange(Status, ApprovalEntries.Status::Open);
        ApprovalEntriesCount := ApprovalEntries.Count();
        Exit(ApprovalEntriesCount);
    end;

    procedure OpenJobAdverts(): Integer
    var
        RecruitmentNeeds: Record "Recruitment Needs";
        OpenJobAds: Decimal;
    begin
        OpenJobAds := 0;

        RecruitmentNeeds.Reset();
        RecruitmentNeeds.SetRange(Closed, false);
        RecruitmentNeeds.Setfilter("Start Date", '<=%1', TODAY);
        RecruitmentNeeds.Setfilter("End Date", '>=%1', TODAY);
        RecruitmentNeeds.SetRange(Status, RecruitmentNeeds.Status::Released);
        OpenJobAds := RecruitmentNeeds.Count();
        Exit(OpenJobAds);
    end;

    procedure ClosedJobAdverts(): Integer
    var
        RecruitmentNeeds: Record "Recruitment Needs";
        ClosedJobAds: Decimal;
    begin
        ClosedJobAds := 0;

        RecruitmentNeeds.Reset();
        //RecruitmentNeeds.SetRange(Closed, false);
        RecruitmentNeeds.Setfilter("Current Stage", '<>%1', RecruitmentNeeds."Current Stage"::Completed);
        RecruitmentNeeds.Setfilter("Start Date", '<=%1', TODAY);
        RecruitmentNeeds.Setfilter("End Date", '<=%1', TODAY);
        RecruitmentNeeds.SetRange(Status, RecruitmentNeeds.Status::Released);
        ClosedJobAds := RecruitmentNeeds.Count();
        Exit(ClosedJobAds);
    end;

    procedure ActiveLeaves(): Integer
    var
        LeaveApp: Record "Employee Leave Application";
        ActiveLeavesCount: Decimal;
    begin
        ActiveLeavesCount := 0;

        LeaveApp.Reset();
        LeaveApp.Setfilter("Start Date", '<=%1', TODAY);
        LeaveApp.Setfilter("Resumption Date", '>=%1', TODAY);
        LeaveApp.SetRange(Status, LeaveApp.Status::Released);
        ActiveLeavesCount := LeaveApp.Count();
        Exit(ActiveLeavesCount);
    end;

    procedure ActiveEmpsForLeave(): Integer
    var
        Employees: Record Employee;
        EmpsCount: Decimal;
    begin
        EmpsCount := 0;

        Employees.Reset();
        Employees.SetRange(Status, Employees.Status::Active);
        EmpsCount := Employees.Count();
        Exit(EmpsCount);
    end;


}