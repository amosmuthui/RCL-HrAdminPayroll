table 51525458 "Recruitment Mandatory Docs"
{
    fields
    {
        field(1; "Recruitment Need Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Document Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Document Desciption"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(5; Mandatory; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Document No"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Documents".Code WHERE(Global = CONST(true));

            trigger OnValidate()
            begin
                if HrDocs.Get("Document No") then
                    "Document Name" := HrDocs.Description;
            end;
        }
    }

    keys
    {
        key(Key1; "Recruitment Need Code", "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        HrDocs: Record "HR Documents";
}