table 51525341 "Training Master Plan Header"
{
    Caption = 'Training Master Plan Header';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Training Master Plan";
    LookupPageId = "Training Master Plan";

    fields
    {
        field(1; "No."; Code[30])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; Title; Text[250])
        {
            Caption = 'Title';
        }
        field(3; Description; Text[2000])
        {
            Caption = 'Description';
        }
        field(4; Recurrence; Option)
        {
            Caption = 'Recurrence';
            OptionMembers = Once,Recurs;
            OptionCaption = 'Once,Recurs';
        }
        field(5; Frequency; Code[10])
        {
            Caption = 'Frequency';
            trigger OnValidate()
            begin
                Frequency := DelChr(Frequency, '=', ''); //Remove spaces
                if ((Frequency <> '') and (StrPos(Frequency, 'D') = 0) and (StrPos(Frequency, 'W') = 0) and (StrPos(Frequency, 'M') = 0) and (StrPos(Frequency, 'Y') = 0)) then
                    Error('The Frequency should be a number followed by either D for days, W for weeks, M for months, or Y for years!');
            end;
        }
        field(6; "Notification Period Notice"; Code[10])
        {
            Caption = 'Notification Period Notice';
            trigger OnValidate()
            begin
                if ("Notification Period Notice" <> '') then begin
                    "Notification Period Notice" := DelChr("Notification Period Notice", '=', ''); //Remove spaces
                    "Notification Period Notice" := DelChr("Notification Period Notice", '=', '-'); //Force a -ve because we notify days before - so delete if it exists then put it
                    "Notification Period Notice" := '-' + "Notification Period Notice";
                    if ((StrPos("Notification Period Notice", 'D') = 0) and (StrPos("Notification Period Notice", 'W') = 0) and (StrPos("Notification Period Notice", 'M') = 0) and (StrPos("Notification Period Notice", 'Y') = 0)) then
                        Error('The Notification Period Notice should be hyphen(-), a number followed by either D for days, W for weeks, M for months, or Y for years!');
                end;
            end;
        }
        field(7; "Mandatory/Optional"; Option)
        {
            Caption = 'Mandatory/Optional';
            OptionMembers = Optional,Mandatory;
        }
        field(8; "Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = Probational,General,Occupational,"Capacity Building";
        }
        field(9; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Active,Inactive;
        }
        field(10; "Approximate Duration"; Code[10])
        {
            Caption = 'Approximate Duration';
            trigger OnValidate()
            begin
                "Approximate Duration" := DelChr("Approximate Duration", '=', ''); //Remove spaces
                if (("Approximate Duration" <> '') and (StrPos("Approximate Duration", 'H') = 0) and (StrPos("Approximate Duration", 'D') = 0) and (StrPos("Approximate Duration", 'W') = 0) and (StrPos("Approximate Duration", 'M') = 0) and (StrPos("Approximate Duration", 'Y') = 0)) then
                    Error('The Approximate Duration should be a number followed by either H for hours, D for days, W for weeks, M for months, or Y for years!');
            end;
        }
        field(11; Objectives; Text[2000])
        {

        }
        field(12; "Theory/Practical"; Option)
        {
            OptionMembers = " ",Theory,Practical,"Theory and Practical";
        }
        field(13; Category; Option)
        {
            OptionMembers = " ","Revalidation/Requalification","Aircraft transition/Conversion";
        }
        field(14; "Legacy Data"; Boolean)
        {
            Editable = false;
        }
        field(15; "Course Abbreviation"; Code[100])
        {

        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "No.", Title, Description)
        {
        }
    }

    trigger OnInsert()
    begin
        if IsAReadOnlyUser() then
            Error('You are not authorized to modify these records!');

        if "No." = '' then begin
            TrainingMasterPlan.Reset();
            if TrainingMasterPlan.FindLast then begin
                "No." := IncStr(TrainingMasterPlan."No.")
            end else begin
                "No." := 'TMP-0001';
            end;
        end;
    end;

    trigger OnModify()
    begin
        if IsAReadOnlyUser() then
            Error('You are not authorized to modify these records!');
    end;

    trigger OnDelete()
    begin
        Error('Deleting is prohibited for audit purposes!');
    end;

    var
        TrainingMasterPlan: Record "Training Master Plan Header";

    procedure IsAReadOnlyUser() isReadOnly: Boolean
    var
        UserSetup: Record "User Setup";
    begin
        isReadOnly := false;
        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        UserSetup.SetRange("Training Readonly", true);
        if UserSetup.FindFirst() then
            isReadOnly := true;
    end;
}