page 51525488 "Applicant Documents"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Applicant Documents";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DocumentNo; Rec.DocumentNo)
                {
                }
                field("Applicant No"; Rec."Applicant No")
                {
                }
                field("Document Description"; Rec."Document Description")
                {
                }
                field("Document Link"; Rec."Document Link")
                {
                }
                field(Attached; Rec.Attached)
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        HRDocuments.Reset;
        HRDocuments.SetRange(Code, Rec.DocumentNo);
        if HRDocuments.Find('-') then
            Rec."Document Description" := HRDocuments.Description;
        // IF NOT GET("Applicant No","Document Description","Line No.") THEN
        //  MODIFY;
    end;

    var
        HRDocuments: Record "HR Documents";
}