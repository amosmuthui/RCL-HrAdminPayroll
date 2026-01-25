table 51525507 "Courses Setup"
{
    fields
    {
        field(1; "Course Type"; Option)
        {
            OptionMembers = ,Degree,Masters,PHD,Diploma,Certificate;

            trigger OnValidate()
            begin
                //"Course Type":=FORMAT("Course Name")+FORMAT('-')+FORMAT("Course Name");
                //message(typename);
            end;
        }
        field(2; "Course Name"; Text[100])
        {

            trigger OnValidate()
            begin

                //typename:=FORMAT("Course Type")+'-'+"Course Name";
                //EVALUATE(temptxt,FORMAT("Course Name"));
                //"Course Type":=temptxt+'_'+"Course Name";
            end;
        }
    }

    keys
    {
        key(Key1; "Course Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Course Type", "Course Name")
        {
        }
    }

    var
        temptxt: Text;
}