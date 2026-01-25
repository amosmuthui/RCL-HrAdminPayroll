table 51525330 "Leave Types"
{
    LookupPageID = "Leave Types";

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[200])
        {
        }
        field(3; Days; Decimal)
        {
        }
        field(4; "Acrue Days"; Boolean)
        {
        }
        field(5; "Unlimited Days"; Boolean)
        {
        }
        field(6; Gender; Option)
        {
            OptionCaption = 'Both,Male,Female';
            OptionMembers = Both,Male,Female;
        }
        field(7; Balance; Option)
        {
            OptionCaption = 'Ignore,Carry Forward,Convert to Cash';
            OptionMembers = Ignore,"Carry Forward","Convert to Cash";
        }
        field(8; "Inclusive of Holidays"; Boolean)
        {
        }
        field(9; "Inclusive of Saturday"; Boolean)
        {
        }
        field(10; "Inclusive of Sunday"; Boolean)
        {
        }
        field(11; "Off/Holidays Days Leave"; Boolean)
        {
        }
        field(12; "Max Carry Forward Days"; Decimal)
        {

            trigger OnValidate()
            begin
                //IF Balance<>Balance::"Carry Forward" THEN
                //"Max Carry Forward Days":=0;
            end;
        }
        field(13; "Conversion Rate Per Day"; Decimal)
        {
        }
        field(14; "Annual Leave"; Boolean)
        {
        }
        field(15; Status; Option)
        {
            OptionMembers = Active,Inactive;
        }
        field(16; "Eligible Staff"; Option)
        {
            OptionCaption = 'Both,Permanent,Temporary';
            OptionMembers = Both,Permanent,"Temporary";
        }
        field(17; "Contract Days"; Decimal)
        {
        }
        field(18; "Use Fiscal Year"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Application Doc"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Inclusive of Non Working Days"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Base Calendar"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Require Supporting Doc.Attache"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Show in Portal"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(24; IsMonthly; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Is Annual Leave"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Require Handover Notes Attach"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Portal Leave Alloc Gender"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Female,Male';
            OptionMembers = " ",Female,Male;
        }
        field(28; "Visible on Portal Dashboard"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Minimum Days Worked"; Decimal)
        { }
        field(30; "Notification Email"; Text[200])
        { }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}