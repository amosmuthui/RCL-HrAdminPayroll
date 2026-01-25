table 51525552 "Letter Templates"
{
    Caption = 'Letter Templates';
    DataClassification = ToBeClassified;
    LookupPageId = "Letter Templates";
    DrillDownPageId = "Letter Templates";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
            AutoIncrement = true;
        }
        field(2; "Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = Visa,"Work Permit",Other;
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(4; "Custom Layout Code"; Code[20])
        {
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    var
        CustomReportLayouts: Record "Custom Report Layout";
        CustomReportLayoutInit: Record "Custom Report Layout";

    trigger OnInsert()
    begin
        //if "Entry No." <> 0 then
        //CreateCustomLayoutIfNotExists();
    end;

    trigger OnModify()
    begin
        if "Custom Layout Code" = '' then
            CreateCustomLayoutIfNotExists();
    end;

    procedure OpenTemplateLayout()
    begin
        if not CreateCustomLayoutIfNotExists() then
            Error('A layout error occurred. Please try again or contact the administrator.');

        CustomReportLayouts.Reset();
        CustomReportLayouts.SetRange("Report ID", Report::"Recommendation Letter");
        CustomReportLayouts.SetRange(Code, Rec."Custom Layout Code");
        if CustomReportLayouts.Find('-') then
            Page.Run(Page::"Custom Report Layouts", CustomReportLayouts)
        else
            Error('Layout not found!');
    end;

    procedure CreateCustomLayoutIfNotExists(): Boolean
    var
        OutStr: OutStream;
        Instr: InStream;
        lvCustomReportLayouts: Record "Custom Report Layout";
        FirstLayoutCode: Code[20];
        ReportLayouts: Record "Report Layout List";
        TempBlob: Codeunit "Temp Blob";
    begin
        if Description = '' then
            Error('Please provide the description before proceeding!');

        CustomReportLayouts.Reset();
        CustomReportLayouts.SetRange("Report ID", Report::"Recommendation Letter");
        CustomReportLayouts.SetRange(Code, Rec."Custom Layout Code");
        if CustomReportLayouts.FindFirst() then
            exit(true);

        //If none exists, create initial
        CustomReportLayouts.Reset();
        CustomReportLayouts.SetRange("Report ID", Report::"Recommendation Letter");
        if not CustomReportLayouts.FindFirst() then begin
            FirstLayoutCode := CustomReportLayouts.InitBuiltInLayout(Report::"Recommendation Letter", CustomReportLayouts.Type::Word.AsInteger());
            //Copy layout from main
            ReportLayouts.Reset();
            ReportLayouts.SetRange("Report ID", Report::"Recommendation Letter");
            if ReportLayouts.Get() then begin
                if lvCustomReportLayouts.Get(FirstLayoutCode) then begin
                    Clear(OutStr);
                    Clear(Instr);
                    if ReportLayouts.Layout.HasValue then begin
                        ReportLayouts.Layout.ExportStream(TempBlob.CreateOutStream());
                        TempBlob.CreateInStream(Instr);
                        lvCustomReportLayouts.Layout.CreateOutStream(OutStr);
                        CopyStream(OutStr, Instr);
                        lvCustomReportLayouts.SetDefaultCustomXmlPart();
                        lvCustomReportLayouts.Modify();
                    end;
                end;
            end;
        end;

        CustomReportLayouts.Reset();
        CustomReportLayouts.SetRange("Report ID", Report::"Recommendation Letter");//copy the most recent
        CustomReportLayouts.SetRange(Type, CustomReportLayouts.Type::Word);
        if CustomReportLayouts.Find('-') then begin
            CustomReportLayoutInit.Init();
            CustomReportLayoutInit.TransferFields(CustomReportLayouts);
            CustomReportLayoutInit.Code := Format(Report::"Recommendation Letter") + '-' + Format(Rec."Entry No.");
            CustomReportLayoutInit."Built-In" := false;
            if CustomReportLayouts.Layout.HasValue then begin
                Clear(OutStr);
                Clear(Instr);
                CustomReportLayouts.CalcFields(Layout);
                CustomReportLayouts.Layout.CreateInStream(Instr);
                CustomReportLayoutInit.Layout.CreateOutStream(OutStr);
                CopyStream(OutStr, Instr);
            end;
            CustomReportLayoutInit.Description := Description;
            CustomReportLayoutInit.Insert();
            if not CustomReportLayoutInit.Layout.HasValue then
                Error('Layout not copied!');
            CustomReportLayoutInit.SetDefaultCustomXmlPart();
            CustomReportLayoutInit.Modify();

            Rec."Custom Layout Code" := CustomReportLayoutInit.Code;
            exit(true);
        end;
        exit(false);
    end;
}
