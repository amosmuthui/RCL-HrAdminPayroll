table 51525372 "HR Leave Ledger Entries"
{
    Caption = 'Leave Ledger Entry';
    LookupPageId = "Leave Ledger Entries";
    DrillDownPageId = "Leave Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Leave Period"; Code[20])
        {
            Caption = 'Leave Period';
            TableRelation = "HR Leave Periods"."Period Code";
        }
        field(3; Closed; Boolean)
        {
            Caption = 'Closed';
        }
        field(4; "Staff No."; Code[20])
        {
            Caption = 'Staff No.';
            TableRelation = Employee."No.";
        }
        field(5; "Staff Name"; Text[70])
        {
            Caption = 'Staff Name';
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(7; "Leave Entry Type"; Option)
        {
            Caption = 'Leave Entry Type';
            OptionCaption = 'Positive,Negative,Reimbursement';
            OptionMembers = Positive,Negative,Reimbursement;
        }
        field(8; "Leave Approval Date"; Date)
        {
            Caption = 'Leave Approval Date';
        }
        field(9; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(10; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(11; "Job ID"; Code[20])
        {
            //TableRelation = Table0.Field4;
        }
        field(12; "Job Group"; Code[20])
        {
        }
        field(13; "Contract Type"; Code[20])
        {
        }
        field(14; "No. of days"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'No. of days';
        }
        field(15; "Leave Start Date"; Date)
        {
        }
        field(16; "Leave Posting Description"; Text[250])
        {
            Caption = 'Leave Posting Description';
        }
        field(17; "Leave End Date"; Date)
        {
        }
        field(18; "Leave Return Date"; Date)
        {
        }
        field(20; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(21; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(22; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(23; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
                //LoginMgt.LookupUserID("User ID");
            end;
        }
        field(24; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(25; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(26; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(27; "Index Entry"; Boolean)
        {
            Caption = 'Index Entry';
        }
        field(28; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(29; "Leave Recalled No."; Code[20])
        {
            Caption = 'Leave Application No.';
            /*TableRelation = Locations."Location Type" WHERE (Field3961 = FIELD ("Staff No."),
                                                             Test = CONST ('7'));*/
        }
        field(30; "Leave Type"; Code[60])
        {
            TableRelation = "Leave Types".Code;
        }
        field(31; "Is For Annual Leave"; Boolean)
        {
            Editable = true;
        }
        field(32; "Leave Family"; Code[20])
        {
            //TableRelation = "Scale Rating".Code;
        }
        field(33; IsMonthlyAccrued; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(34; Adjustment; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Leave Year"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Leave Bal Portal"; Decimal)
        {
            CalcFormula = Sum("HR Leave Ledger Entries"."No. of days" WHERE("Staff No." = FIELD("Staff No."),
                                                                             "Leave Type" = FILTER('ANNUAL' | 'CF')));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Leave Period", "Posting Date")
        {
            SumIndexFields = "No. of days";
        }
        key(Key3; "Leave Period", Closed, "Posting Date")
        {
            SumIndexFields = "No. of days";
        }
        key(Key4; "Staff No.", "Leave Period", Closed, "Posting Date")
        {
            SumIndexFields = "No. of days";
        }
        key(Key5; "Staff No.", Closed, "Posting Date")
        {
        }
        key(Key6; "Posting Date", "Leave Entry Type", "Staff No.")
        {
            SumIndexFields = "No. of days";
        }
        key(Key7; "Staff No.")
        {
            SumIndexFields = "No. of days";
        }
        key(Key8; "Leave Entry Type", "Staff No.", "Leave Type", Closed)
        {
            SumIndexFields = "No. of days";
        }
        key(Key9; "Leave Entry Type", "Staff No.", Closed)
        {
            Enabled = false;
            SumIndexFields = "No. of days";
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", "Leave Period", "Staff No.", "Staff Name", "Posting Date")
        {
        }
    }

    trigger OnDelete()
    begin
        //ERROR(Text1);
    end;

    trigger OnInsert()
    begin
        if "Leave Type" <> '' then begin
            hrleavetypes.Reset;
            hrleavetypes.SetRange(IsMonthly, true);
            hrleavetypes.SetRange("Acrue Days", true);
            hrleavetypes.SetRange(Code, "Leave Type");
            if hrleavetypes.Find('-') then
                IsMonthlyAccrued := true;
        end;
    end;

    var
        hrleavetypes: Record "Leave Types";
        Text1: Label 'You cant delete this entry';
}