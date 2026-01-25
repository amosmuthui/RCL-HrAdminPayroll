table 51525444 "Appraisal Lines"
{
    fields
    {
        field(1; "Employee No"; Code[20])
        {
            TableRelation = Employee;
        }
        field(2; "Appraisal Category"; Code[20])
        {
        }
        field(3; "Appraisal Period"; Code[20])
        {
        }
        field(4; Objective; Text[120])
        {
            NotBlank = true;
        }
        field(5; "No."; Code[20])
        {
            NotBlank = true;
        }
        field(6; Measure; Text[250])
        {
        }
        field(7; "Agreed Target Date"; Date)
        {
        }
        field(8; Weighting; Integer)
        {
        }
        field(9; "Review Comments/ Achievements"; Text[250])
        {
        }
        field(10; "Weighting(%)"; Decimal)
        {
        }
        field(11; "Job ID"; Code[20])
        {
            TableRelation = "Company Jobs"."Job ID";
        }
        field(12; "Line No"; Integer)
        {
        }
        field(13; "Appraiser's Comments"; Text[150])
        {

            trigger OnValidate()
            begin
                "Date of Super Review" := Today;
            end;
        }
        field(14; "Appraisee's comments"; Text[150])
        {

            trigger OnValidate()
            begin
                "Date of Individual Review" := Today;
            end;
        }
        field(15; Description; Text[80])
        {
        }
        field(16; "Appraisal Heading Type"; Option)
        {
            OptionCaption = ' ,Finance and Accounting,Project Management,HR Management,Administration';
            OptionMembers = " ","Finance and Accounting","Project Management","HR Management",Administration;
        }
        field(17; "Appraisal Header"; Text[50])
        {
            TableRelation = "Appraisal Format Header";
        }
        field(18; Bold; Boolean)
        {
        }
        field(19; "Appraisal No"; Code[20])
        {
        }
        field(20; "New No."; Integer)
        {
            AutoIncrement = true;
        }
        field(21; "Appraisal Type"; Text[30])
        {
        }
        field(22; "Strategic Perspective"; Option)
        {
            OptionCaption = 'Financial,Stakeholder,Internal Business Process,Learning and Growth';
            OptionMembers = Financial,Stakeholder,"Internal Business Process","Learning and Growth";
        }
        field(23; "Ind Performance Ratings(%)"; Decimal)
        {
            TableRelation = "Scale Rating";

            trigger OnValidate()
            begin
                /*TESTFIELD("Weighting(%)");
                "Weighted Ratings(%)":=("Performance Ratings(%)"/100)*"Weighting(%)";
                 */

                "Date of Individual Review" := Today;

            end;
        }
        field(24; "Super Performance  Ratings(%)"; Decimal)
        {
            TableRelation = "Scale Rating";

            trigger OnValidate()
            begin
                "Date of Super Review" := Today;
            end;
        }
        field(25; "Appraisal Year"; Code[20])
        {
        }
        field(26; "Resources Required"; Text[250])
        {
        }
        field(27; "Date of Individual Review"; Date)
        {
        }
        field(28; "Date of Super Review"; Date)
        {
        }
        field(29; "Ind Rating Code"; Code[10])
        {
            TableRelation = "Scale Rating";

            trigger OnValidate()
            begin
                if ScaleRating.Get("Ind Rating Code") then
                    "Ind Performance Ratings(%)" := ScaleRating.Rate
                else
                    "Ind Performance Ratings(%)" := 0;
            end;
        }
        field(30; "Sup Rating Code"; Code[10])
        {
            TableRelation = "Scale Rating";

            trigger OnValidate()
            begin
                if ScaleRating.Get("Ind Rating Code") then
                    "Super Performance  Ratings(%)" := ScaleRating.Rate
                else
                    "Super Performance  Ratings(%)" := 0;
            end;
        }
    }

    keys
    {
        key(Key1; "Appraisal No", "Line No")
        {
        }
        key(Key2; "Employee No", "Appraisal Category", "Appraisal Period", "Line No")
        {
            Clustered = true;
        }
        key(Key3; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //MESSAGE('%1',GetNextLine);
        //"Line No":=GetNextLine;
    end;

    var
        Appraisalines: Record "Appraisal Lines";
        ScaleRating: Record "Scale Rating";

    [Scope('OnPrem')]
    procedure GetNextLine() NxtLine: Integer
    var
        AppraisalLine: Record "Appraisal Lines";
    begin
        AppraisalLine.Reset;
        AppraisalLine.SetRange(AppraisalLine."Appraisal No", "Appraisal No");
        if AppraisalLine.Find('+') then
            NxtLine := AppraisalLine."Line No" + 1;
    end;
}