table 51525397 "Sub County"
{
    DataCaptionFields = "Sub County Code", "Sub County Description";
    DrillDownPageID = "Sub County";
    LookupPageID = "Sub County";

    fields
    {
        field(1; "County Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Sub County Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Sub County Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "County Code", "Sub County Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Sub County Code", "Sub County Description")
        {
        }
    }
}