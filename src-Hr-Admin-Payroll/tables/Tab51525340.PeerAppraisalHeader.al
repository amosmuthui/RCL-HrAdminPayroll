table 51525340 "Peer Appraisal Header"
{
    DrillDownPageId = "Peer Appraisal Selection List";
    LookupPageId = "Peer Appraisal Selection List";

    fields
    {
        field(1; No; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Period; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Appraisal Periods".Code;
        }
        field(4; "Staff No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
        }
        field(5; "Peer Appraiser 1"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                if "Peer Appraiser 1" = "Staff No" then Error('You cannot select yourself as an appraisee');
                if ("Peer Appraiser 1" = "Peer Appraiser 2") or ("Peer Appraiser 1" = "Peer Appraiser 3") then Error('You have already picked this staff as your appraisor');

                //check number of reviews
                Counter := 0;
                AppraisalHeader.Reset;
                AppraisalHeader.SetFilter(Period, Period);
                AppraisalHeader.SetFilter("Peer Appraiser 1", "Peer Appraiser 1");
                if AppraisalHeader.FindFirst then
                    repeat
                        Counter += 1;
                    until AppraisalHeader.Next = 0;
                AppraisalHeader.Reset;
                AppraisalHeader.SetFilter(Period, Period);
                AppraisalHeader.SetFilter("Peer Appraiser 2", "Peer Appraiser 1");
                if AppraisalHeader.FindFirst then
                    repeat
                        Counter += 1;
                    until AppraisalHeader.Next = 0;

                AppraisalHeader.Reset;
                AppraisalHeader.SetFilter(Period, Period);
                AppraisalHeader.SetFilter("Peer Appraiser 3", "Peer Appraiser 1");
                if AppraisalHeader.FindFirst then
                    repeat
                        Counter += 1;
                    until AppraisalHeader.Next = 0;

                if Counter > 5 then
                    Error('%1 has already reached the limit for number of people to appraise', "Peer Appraiser 1");

                //FRED - Need this for validation in review pages
                "Peers Filter" := '';
                if "Peer Appraiser 1" <> '' then
                    "Peers Filter" += "Peer Appraiser 1" + '|';
                if "Peer Appraiser 2" <> '' then
                    "Peers Filter" += "Peer Appraiser 2" + '|';
                if "Peer Appraiser 3" <> '' then
                    "Peers Filter" += "Peer Appraiser 3" + '|';
                if Supervisor <> '' then
                    "Peers Filter" += Supervisor;
            end;
        }
        field(6; "Peer Appraiser 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                if "Peer Appraiser 2" = "Staff No" then Error('You cannot select yourself as an appraisee');
                if ("Peer Appraiser 2" = "Peer Appraiser 1") or ("Peer Appraiser 2" = "Peer Appraiser 3") then Error('You have already picked this staff as your appraisor');

                //check number of reviews
                Counter := 0;
                AppraisalHeader.Reset;
                AppraisalHeader.SetFilter(Period, Period);
                AppraisalHeader.SetFilter("Peer Appraiser 1", "Peer Appraiser 2");
                if AppraisalHeader.FindFirst then
                    repeat
                        Counter += 1;
                    until AppraisalHeader.Next = 0;
                AppraisalHeader.Reset;
                AppraisalHeader.SetFilter(Period, Period);
                AppraisalHeader.SetFilter("Peer Appraiser 2", "Peer Appraiser 2");
                if AppraisalHeader.FindFirst then
                    repeat
                        Counter += 1;
                    until AppraisalHeader.Next = 0;

                AppraisalHeader.Reset;
                AppraisalHeader.SetFilter(Period, Period);
                AppraisalHeader.SetFilter("Peer Appraiser 3", "Peer Appraiser 2");
                if AppraisalHeader.FindFirst then
                    repeat
                        Counter += 1;
                    until AppraisalHeader.Next = 0;

                if Counter > 5 then
                    Error('%1 has already reached the limit for number of people to appraise', "Peer Appraiser 1");

                //FRED - Need this for validation in review pages
                "Peers Filter" := '';
                if "Peer Appraiser 1" <> '' then
                    "Peers Filter" += "Peer Appraiser 1" + '|';
                if "Peer Appraiser 2" <> '' then
                    "Peers Filter" += "Peer Appraiser 2" + '|';
                if "Peer Appraiser 3" <> '' then
                    "Peers Filter" += "Peer Appraiser 3" + '|';
                if Supervisor <> '' then
                    "Peers Filter" += Supervisor;
            end;
        }
        field(7; "Peer Appraiser 3"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                if "Peer Appraiser 3" = "Staff No" then Error('You cannot select yourself as an appraisee');
                if ("Peer Appraiser 3" = "Peer Appraiser 1") or ("Peer Appraiser 3" = "Peer Appraiser 2") then Error('You have already picked this staff as your appraisor');


                //check number of reviews
                Counter := 0;
                AppraisalHeader.Reset;
                AppraisalHeader.SetFilter(Period, Period);
                AppraisalHeader.SetFilter("Peer Appraiser 1", "Peer Appraiser 3");
                if AppraisalHeader.FindFirst then
                    repeat
                        Counter += 1;
                    until AppraisalHeader.Next = 0;
                AppraisalHeader.Reset;
                AppraisalHeader.SetFilter(Period, Period);
                AppraisalHeader.SetFilter("Peer Appraiser 2", "Peer Appraiser 3");
                if AppraisalHeader.FindFirst then
                    repeat
                        Counter += 1;
                    until AppraisalHeader.Next = 0;

                AppraisalHeader.Reset;
                AppraisalHeader.SetFilter(Period, Period);
                AppraisalHeader.SetFilter("Peer Appraiser 3", "Peer Appraiser 3");
                if AppraisalHeader.FindFirst then
                    repeat
                        Counter += 1;
                    until AppraisalHeader.Next = 0;

                if Counter > 5 then
                    Error('%1 has already reached the limit for number of people to appraise', "Peer Appraiser 1");

                //FRED - Need this for validation in review pages
                "Peers Filter" := '';
                if "Peer Appraiser 1" <> '' then
                    "Peers Filter" += "Peer Appraiser 1" + '|';
                if "Peer Appraiser 2" <> '' then
                    "Peers Filter" += "Peer Appraiser 2" + '|';
                if "Peer Appraiser 3" <> '' then
                    "Peers Filter" += "Peer Appraiser 3" + '|';
                if Supervisor <> '' then
                    "Peers Filter" += Supervisor;
            end;
        }
        field(8; "Created By"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Created On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Peer Appraisal';
            OptionMembers = Open,"Pending Peer Appraisal";
        }
        field(11; Directorate; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center".Code;
        }
        field(12; Department; Code[240])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sub Responsibility Center".Code WHERE("Responsibility Center" = FIELD(Directorate));

            trigger OnValidate()
            begin
                /*IF CONFIRM('Do you want to replace the current lines?', TRUE) = TRUE THEN BEGIN
                ObjDeptObjectivesHeader.RESET;
                ObjDeptObjectivesHeader.SETRANGE(Department, Department);
                ObjDeptObjectivesHeader.SETRANGE(Directorate, Directorate);
                ObjDeptObjectivesHeader.SETRANGE(Period, Period);
                IF ObjDeptObjectivesHeader.FIND('-') THEN BEGIN
                  StaffTargetsLines.RESET;
                  StaffTargetsLines.SETRANGE("Staff No", "Staff No");
                  StaffTargetsLines.SETRANGE(Period, Period);
                  IF StaffTargetsLines.FIND('-') THEN
                      StaffTargetsLines.DELETEALL;
                    ObjDeptObjectives.RESET;
                    ObjDeptObjectives.SETRANGE("Doc No", ObjDeptObjectivesHeader.No);
                    IF ObjDeptObjectives.FIND('-') THEN BEGIN
                      REPEAT
                        StaffTargetsLines.INIT;
                        StaffTargetsLines.No:='';
                        StaffTargetsLines."Doc No":=No;
                        StaffTargetsLines."Objective Code":=ObjDeptObjectives."Objective Code";
                        StaffTargetsLines.Objective:=ObjDeptObjectives.Objective;
                        StaffTargetsLines."Success Measure":=ObjDeptObjectives."Success Measure";
                        StaffTargetsLines.Period:=Period;
                        StaffTargetsLines."Staff No":="Staff No";
                        StaffTargetsLines.INSERT(TRUE);
                        UNTIL ObjDeptObjectives.NEXT=0;
                      END ELSE MESSAGE('Department Objectives not found');
                  END;
                END ELSE MESSAGE('Current lines have not been replaced');*/

            end;
        }
        field(13; Supervisor; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                //FRED - Need this for validation in review pages
                "Peers Filter" := '';
                if "Peer Appraiser 1" <> '' then
                    "Peers Filter" += "Peer Appraiser 1" + '|';
                if "Peer Appraiser 2" <> '' then
                    "Peers Filter" += "Peer Appraiser 2" + '|';
                if "Peer Appraiser 3" <> '' then
                    "Peers Filter" += "Peer Appraiser 3" + '|';
                if Supervisor <> '' then
                    "Peers Filter" += Supervisor;
            end;
        }
        field(14; "Supervisor Name"; Text[250])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD(Supervisor)));
            FieldClass = FlowField;
        }
        field(15; Designation; Text[250])
        {
            CalcFormula = Lookup(Employee."Job Title" WHERE("No." = FIELD("Staff No")));
            FieldClass = FlowField;
        }
        field(16; "Level of interaction"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Every Day,A few times a week,A few times a month,Every few months,NA (Never)';
            OptionMembers = " ","Every Day","A few times a week","A few times a month","Every few months","NA (Never)";
        }
        field(17; "Send Back To Supervisor"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Peers Filter"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Peer 1 Send Back To Supervisor"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Peer 2 Send Back To Supervisor"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Peer 3 Send Back To Supervisor"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if No = '' then begin
            AppraisalHeader.Reset;
            if AppraisalHeader.FindLast then begin
                No := IncStr(AppraisalHeader.No);
            end else begin
                No := 'PEERAPPR-001';
            end;
        end;
        UserSetup.Reset;
        UserSetup.SetRange("Employee No.", Supervisor);
        if UserSetup.FindFirst then
            "Created By" := UserSetup."User ID";
        "Created On" := Today;
        // ObjEmp.RESET;
        // ObjEmp.SETRANGE("User ID", USERID);
        // IF ObjEmp.FIND('-') THEN
        //  "Staff No":= ObjEmp."No.";
    end;

    var
        AppraisalHeader: Record "Peer Appraisal Header";
        ObjEmp: Record Employee;
        UserSetup: Record "User Setup";
        Counter: Integer;
}