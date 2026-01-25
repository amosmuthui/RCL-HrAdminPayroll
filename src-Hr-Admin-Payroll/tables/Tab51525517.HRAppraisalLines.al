table 51525517 "HR Appraisal Lines"
{
    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Appraisal No"; Code[30])
        {
            TableRelation = "HR Appraisal Header"."No.";
        }
        field(3; "Appraisal Period"; Code[20])
        {
            TableRelation = "HR Appraisal Periods".Code;
        }
        field(4; "Employee No"; Code[20])
        {
            NotBlank = true;
            TableRelation = Employee."No.";
        }
        field(5; Sections; Code[60])
        {
        }
        field(6; "Perfomance Goals and Targets"; Text[250])
        {
        }
        field(7; "Self Rating"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(8; "Peer Rating"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Categorize As" = "Categorize As"::"Employee's Peers" then begin
                    fnCheckParametersPeers("Peer Rating");
                end;
            end;
        }
        field(9; "Supervisor Rating"; Decimal)
        {
        }
        field(10; "Sub-ordinates Rating"; Decimal)
        {

            trigger OnValidate()
            begin

                if "Categorize As" = "Categorize As"::"Employee's Subordinates" then begin
                    fnCheckParametersSubordinates("Sub-ordinates Rating");
                end;
            end;
        }
        field(11; "Outside Agencies Rating"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(17; "Agreed Rating"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(18; "Agreed Rating x Weighting"; Decimal)
        {
        }
        field(19; "Employee Comments"; Text[250])
        {
        }
        field(21; "Peer Comments"; Text[250])
        {
        }
        field(22; "Supervisor Comments"; Text[250])
        {
        }
        field(23; "Subordinates Comments"; Text[200])
        {
        }
        field(25; "Approval Status"; Option)
        {
            OptionMembers = "Pending Approval",Approved;
        }
        field(26; "Categorize As"; Option)
        {
            OptionCaption = ' ,Employee''s Subordinates,Employee''s Peers,External Sources,Job Specific,Self Evaluation,Personal Goals/Objectives';
            OptionMembers = " ","Employee's Subordinates","Employee's Peers","External Sources","Job Specific","Self Evaluation","Personal Goals/Objectives";
        }
        field(27; "Sub Category"; Code[60])
        {
        }
        field(28; "External Source Rating"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Categorize As" = "Categorize As"::"External Sources" then begin
                    fnCheckParametersExternal("External Source Rating");
                end;
            end;
        }
        field(29; "External Source Comments"; Text[250])
        {
        }
        field(30; "Min. Target Score"; Decimal)
        {
        }
        field(31; "Max Target Score"; Decimal)
        {
        }
        field(32; "Unit of Measure"; Code[20])
        {
            TableRelation = "Human Resource Unit of Measure".Code;
        }
    }

    keys
    {
        key(Key1; "Line No", "Appraisal No", "Appraisal Period", "Employee No")
        {
            Clustered = true;
        }
        key(Key2; Sections)
        {
        }
    }

    fieldgroups
    {
    }

    var
        //Employee: Record Payments;
        mycurrStatus: Boolean;
        //objHRSetup: Record "Overtime Set Up";
        Vendor: Record Vendor;
        Customer: Record Customer;

    [Scope('OnPrem')]
    procedure maxRating() maxRating: Decimal
    begin
    end;

    local procedure fnCheckParametersPeers(Score: Integer)
    var
        PerformanceSetup: Record "Perfomance Management Setup";
        Text1: Label 'The rating is below the minimum accepted value of %1.';
        Text2: Label 'The rating is beyond the maximum accepted value of %1.';
    begin
        PerformanceSetup.Get();
        if Score < PerformanceSetup."Peers Minimum Score" then
            Error(Text1, PerformanceSetup."Peers Minimum Score");
        if Score > PerformanceSetup."Peers Maximum Score" then
            Error(Text2, PerformanceSetup."Peers Maximum Score");
    end;

    local procedure fnCheckParametersSubordinates(Score: Integer)
    var
        PerformanceSetup: Record "Perfomance Management Setup";
        Text1: Label 'The rating is below the minimum accepted value of %1.';
        Text2: Label 'The rating is beyond the maximum accepted value of %1.';
    begin
        PerformanceSetup.Get();
        if Score < PerformanceSetup."Surbodinate Minimum Score" then
            Error(Text1, PerformanceSetup."Surbodinate Minimum Score");
        if Score > PerformanceSetup."Surbodinate Maximum Score" then
            Error(Text2, PerformanceSetup."Surbodinate Maximum Score");
    end;

    local procedure fnCheckParametersExternal(Score: Integer)
    var
        PerformanceSetup: Record "Perfomance Management Setup";
        Text1: Label 'The rating is below the minimum accepted value of %1.';
        Text2: Label 'The rating is beyond the maximum accepted value of %1.';
    begin
        PerformanceSetup.Get();
        if Score < PerformanceSetup."External Minimum Score" then
            Error(Text1, PerformanceSetup."External Minimum Score");
        if Score > PerformanceSetup."External Maximum Score" then
            Error(Text2, PerformanceSetup."External Maximum Score");
    end;
}