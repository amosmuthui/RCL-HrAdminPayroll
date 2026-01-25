table 51525415 "Professional Membership Info"
{
    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(3; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Professional Level,Professional Membership';
            OptionMembers = ,"Professional Level","Professional Membership";
        }
        field(4; Body; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST("Professional Level")) "Professional Bodies".ProfessionalBodyID
            ELSE
            IF (Type = CONST("Professional Membership")) "Membership Bodies".MembershipBodyID;

            trigger OnValidate()
            begin
                if Type = Type::"Professional Level" then begin
                    if ProfBody.Get(Body) then
                        "Body Name" := ProfBody.ProfessionalBodyName;
                end;
                if Type = Type::"Professional Membership" then begin
                    if MembBody.Get(Body) then
                        "Body Name" := MembBody.MembershipBodyName;
                end;
            end;
        }
        field(5; "Body Name"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Level; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST("Professional Level")) "Professional Levels".ProfessionalLevelID WHERE(ProfessionalBodyID = FIELD(Body))
            ELSE
            IF (Type = CONST("Professional Membership")) "Membership Categories".MembershipCategoryID WHERE(MembershipBodyID = FIELD(Body));

            trigger OnValidate()
            begin
                if Type = Type::"Professional Level" then begin
                    if Pfoflevel.Get(Level) then
                        "Level Name" := Pfoflevel.ProfessionalLevelName;
                end;
                if Type = Type::"Professional Membership" then begin
                    if MembLevel.Get(Level) then
                        "Level Name" := MembLevel."Level Name";
                end;
            end;
        }
        field(7; "Level Name"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code", "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Pfoflevel: Record "Professional Levels";
        MembLevel: Record "Professional Membership Info";
        ProfBody: Record "Professional Bodies";
        MembBody: Record "Membership Bodies";
}