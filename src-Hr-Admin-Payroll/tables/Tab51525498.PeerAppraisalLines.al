table 51525498 "Peer Appraisal Lines"
{
    fields
    {
        field(1; "Doc No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Peer Appraisal Header".No;
        }
        field(2; "Entry No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(3; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Management Leadership,Job Knowledge,Problem Solving,Communication and Teamwork,Additional Comments';
            OptionMembers = " ","Management Leadership","Job Knowledge","Problem Solving","Communication and Teamwork","Additional Comments";
        }
        field(4; "Section No"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Peer Level"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,First,Second,Third';
            OptionMembers = " ",First,Second,Third;
        }
        field(6; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                /*CALCFIELDS("1st Appraiser");
                ObjEmp.RESET;
                ObjEmp.SETRANGE("No.", "1st Appraiser");
                //ObjEmp.SETRANGE
                IF ObjEmp.FIND('-') THEN BEGIN
                  "Peer Level":="Peer Level"::First;
                END;*/

            end;
        }
        field(7; "1st Appraiser"; Code[20])
        {
            CalcFormula = Lookup("Peer Appraisal Header"."Peer Appraiser 1" WHERE(No = FIELD("Doc No")));
            FieldClass = FlowField;
            TableRelation = Employee."No.";
        }
        field(8; Appraiser; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Staff No"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
        }
        field(10; Period; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Appraisal Periods".Code;
        }
        field(11; Big_Remarks; BLOB)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Send Back To Supervisor"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Period, "Staff No", "Peer Level", Type)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //"1st Appraiser" := 'UMSOMIHVKENYA\AAKINYI';//USERID UMSOMIHVKENYA\DTOBON

        PeerAppraisalHeader.Reset;
        PeerAppraisalHeader.SetRange(No, "Doc No");
        if PeerAppraisalHeader.FindFirst then begin
            if Appraiser = PeerAppraisalHeader."Peer Appraiser 1" then
                "Peer Level" := "Peer Level"::First;
            if Appraiser = PeerAppraisalHeader."Peer Appraiser 2" then
                "Peer Level" := "Peer Level"::Second;
            if Appraiser = PeerAppraisalHeader."Peer Appraiser 3" then
                "Peer Level" := "Peer Level"::Third;


            "Staff No" := PeerAppraisalHeader."Staff No";
            Period := PeerAppraisalHeader.Period;
        end;

        PeerAppraissalLines.Reset;
        PeerAppraissalLines.SetRange(Period, Period);
        PeerAppraissalLines.SetRange("Staff No", "Staff No");
        PeerAppraissalLines.SetRange("Peer Level", "Peer Level");
        PeerAppraissalLines.SetRange(Type, Type);
        PeerAppraissalLines.SetFilter("Entry No", '<>%1', "Entry No");
        if PeerAppraissalLines.FindFirst then
            Error('You can only enter 1 line per section! Entries cannot be repeated for a particular staff in a particular period and peer level!');
    end;

    var
        //MidYearLines: Record "MidYear Appraisal Lines";
        PeerAppraisalHeader: Record "Peer Appraisal Header";
        ObjEmp: Record Employee;
        PeerAppraissalLines: Record "Peer Appraisal Lines";
}