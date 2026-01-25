table 51525331 "Performance Management Themes"
{
    Caption = 'Performance Management Themes';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; Code[50])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; Title; Text[50])
        {
            Caption = 'Title';
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; No, Title)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if No = '' then begin
            PerfThemes.Reset;
            if PerfThemes.FindLast then begin
                No := IncStr(PerfThemes.No);
            end else begin
                No := 'TH-001';
            end;
        end;
        //"Created By" := UserId;
        //"Created On" := Today;
    end;

    var
        PerfThemes: Record "Performance Management Themes";
}