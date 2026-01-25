table 51525334 "HR Appraisal Header"
{
    fields
    {
        field(1; "No."; Code[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    PerformanceSetup.Get;
                    NoSeriesMgt.TestManual(PerformanceSetup."Performance Numbers");
                    "No. series" := '';
                end;
            end;
        }
        field(2; "Supervisor User ID"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(3; "Appraisal Type"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Appraisal Period"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "HR Appraisal Periods".Code;
        }
        field(5; "Appraisal Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = true;
            OptionMembers = Appraisee,Supervisor,Others;
        }
        field(6; Recommendations; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Appraisal Stage"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Mid Year Review","End Year Evaluation";
        }
        field(9; Sent; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Appraisee,Supervisor,Completed,Rated';
            OptionMembers = Appraisee,Supervisor,Completed,Rated;
        }
        field(10; "User ID"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
        }
        field(11; Picture; Media)
        {
            DataClassification = ToBeClassified;
            //SubType = Bitmap;
        }
        field(12; "Employee No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                Clear(HREmp);
                HREmp.SetRange(HREmp."No.", "Employee No.");
                if HREmp.FindFirst() then begin
                    "Employee Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                    "Department Code" := HREmp."Global Dimension 2 Code";
                    Validate("Department Code");
                    "Supervisor No." := HREmp."Manager No.";
                    Validate("Supervisor No.");
                    Designation := HREmp.Position;
                end;
            end;
        }
        field(13; "Employee Name"; Text[60])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Date of First Appointment"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15; Designation; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17; "Department Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;

            trigger OnValidate()
            var
                DimensionValue: Record "Dimension Value";
            begin

                Clear("Department Name");

                DimensionValue.Reset();
                DimensionValue.SetRange(Code, "Department Code");
                if DimensionValue.FindFirst() then "Department Name" := DimensionValue.Name;
            end;
        }
        field(18; "Department Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19; "Comments Appraisee"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Comments Appraiser"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Evaluation Period Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Evaluation Period End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Target Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Company Targets,Individual Targets,Peer Targets,Surbodinates Targets,Out Agencies Targets,Company Rating,Individual Rating,Peer Rating,Surbodinates Rating,Out Agencies Rating';
            OptionMembers = " ","Company Targets","Individual Targets","Peer Targets","Surbodinates Targets","Out Agencies Targets","Company Rating","Individual Rating","Peer Rating","Surbodinates Rating","Out Agencies Rating";
        }
        field(25; "Supervisor No."; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                HREmpCopy.Reset;
                if HREmpCopy.Get("Supervisor No.") then
                    "Supervisor Name" := HREmpCopy."First Name" + ' ' + HREmpCopy."Middle Name" + ' ' + HREmpCopy."Last Name";
                "Supervisor User ID" := HREmpCopy."User ID";
            end;
        }
        field(26; "Final Scores"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Final Scores" > 90 then
                    Error('Final scrores cannot be more than 90');

                HRAppraisalGoalSettingH.CalcFields(HRAppraisalGoalSettingH."Final Scores");
                HRAppraisalGoalSettingH.CalcFields(HRAppraisalGoalSettingH."Final Soft Scores");
                "Total Scores" := "Final Scores" + "Final Soft Scores";

                if "Total Scores" > 99 then begin
                    "Rating Remarks" := 'Excellent'
                end
                else

                    if "Total Scores" > 90 then begin
                        "Rating Remarks" := 'Very Good'
                    end
                    else

                        if "Total Scores" > 70 then begin
                            "Rating Remarks" := 'Good'

                        end
                        else

                            if "Total Scores" > 50 then begin
                                "Rating Remarks" := 'Fair'
                            end
                            else

                                if "Total Scores" < 50 then begin
                                    "Rating Remarks" := 'Poor'
                                end;
            end;
        }
        field(27; "Final Soft Scores"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Scores" := "Final Scores" + "Final Soft Scores";

                if "Total Scores" > 99 then begin
                    "Rating Remarks" := 'Excellent'
                end
                else

                    if "Total Scores" > 90 then begin
                        "Rating Remarks" := 'Very Good'
                    end
                    else

                        if "Total Scores" > 70 then begin
                            "Rating Remarks" := 'Good'

                        end
                        else

                            if "Total Scores" > 50 then begin
                                "Rating Remarks" := 'Fair'
                            end
                            else

                                if "Total Scores" < 50 then begin
                                    "Rating Remarks" := 'Poor'
                                end;
            end;
        }
        field(28; "Total Scores"; Decimal)
        {
            DataClassification = ToBeClassified;
            MaxValue = 100;

            trigger OnValidate()
            begin
                "Total Scores" := "Final Scores" + "Final Soft Scores";

                if "Total Scores" > 99 then begin
                    "Rating Remarks" := 'Excellent'
                end
                else

                    if "Total Scores" > 90 then begin
                        "Rating Remarks" := 'Very Good'
                    end
                    else

                        if "Total Scores" > 70 then begin
                            "Rating Remarks" := 'Good'

                        end
                        else

                            if "Total Scores" > 50 then begin
                                "Rating Remarks" := 'Fair'
                            end
                            else

                                if "Total Scores" < 50 then begin
                                    "Rating Remarks" := 'Poor'
                                end;
            end;
        }
        field(29; "Rating Remarks"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(30; Locked; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(31; "Supervisor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(32; "E-mail"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(33; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,Released,"Pending Approval",Rejected;
        }
        field(34; "Current Scale"; Code[40])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(35; "Scale Year"; Code[40])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(36; "Appraisal Period."; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(37; "No. series"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(38; Manager; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39; "Peer Line Scores"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines"."Peer Rating" WHERE("Appraisal No" = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "External Line Scores"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines"."External Source Rating" WHERE("Appraisal No" = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(41; "Surbodinate Line Scores"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines"."Sub-ordinates Rating" WHERE("Appraisal No" = FIELD("No."),
                                                                                 "Categorize As" = CONST("Employee's Subordinates")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(42; "Performance Line Scores"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines - PT"."Agreed-Assesment Results" WHERE("Appraisal No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(43; "Competencies Line Scores"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines - Values"."Agreed Score" WHERE("Appraisal No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(44; "Appraised Score"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(45; "Appraised Narration"; Text[60])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(46; "Score Grading"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(47; "Assign To Peers"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
        }
        field(48; "Assign To Subordinate"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
        }
        field(49; "Assign To Customer"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
        }
        field(50; Appraised; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(51; "Appraised By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52; "Directorate Code"; Code[40])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(53; "Directorate Name"; Code[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(54; "User Designation"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Officer,Asst Manager,Manager,Director,CEO,BOD';
            OptionMembers = " ",Officer,"Asst Manager",Manager,Director,CEO,BOD;
        }
        field(55; Remark; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(56; "Accept Result"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(57; "Performance Line Scores MY"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines - PT"."Agreed-Assesment Results" WHERE("Appraisal No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(58; Appealed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(59; "Reason for Appeal"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(60; Decline; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(61; "Reason for Decline"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Lines_DeptObject: Record "HR Appraisal Lines - DO";
        Lines_PerfTarget: Record "HR Appraisal Lines - PT";
        Lines_ValComp: Record "HR Appraisal Lines - Values";
    begin
    end;

    trigger OnInsert()
    var
        HRAppPeriod: Record "HR Appraisal Periods";
        HRAppDeptObj: Record "HR Appraisal Dept. Obj. Setup";
        HRAppValComp: Record "HR Appraisal Values and Compt.";
        HREmp: Record Employee;
        ERR_ACTIVE_APPRAISAL_PERIOD: Label 'There are currently [ %1 ] Active Appraisal Period. Please ensure one Period  is Active';
        ERR_MISSING_DEPARTMENTAL_OBJ: Label 'Departmental Objectives for [ %1 ] have not been defined for this Appraisal Period [ %2 ]';
        HREmp_2: Record Employee;
        Lines_DeptObject: Record "HR Appraisal Lines - DO";
        Lines_ValCompt: Record "HR Appraisal Lines - Values";
        ERR_MISSING_VALUES_COMPETENCIIES: Label 'Values and Competencies have not been defined for this Appraisal Period [ %1 ]';
        TheTable: Record "HR Appraisal Header";
        LineNoX: Integer;
        LineNoY: Integer;
    begin
        if "No." = '' then begin
            PerformanceSetup.Get;
            PerformanceSetup.TestField(PerformanceSetup."Performance Numbers");
            "No." := NoSeriesMgt.GetNextNo(PerformanceSetup."Performance Numbers");
        end;

        "Document Date" := Today;
        Periods.Reset;
        Periods.SetFilter(Periods."Close By", '%1', '');
        if Periods.FindLast then begin
            "Appraisal Period" := Periods.Code;
            "Appraisal Period." := Periods.Code;
            "Evaluation Period Start Date" := Periods."Period Start Date";
            "Evaluation Period End Date" := Periods."Period End Date";
        end;
        HREmp.Reset();
        HREmp.SetAutoCalcFields(Image);
        HREmp.SetRange(HREmp."User ID", UserId);
        HREmp.FindFirst();
        begin
            HREmp.TestField("Employment Date");
            HREmp.TestField("Job Title");
            //HREmp.TESTFIELD("Global Dimension 1 Code");
            HREmp.TestField("User ID");
            //HREmp.TESTFIELD("Manager No.");

            "Employee No." := HREmp."No.";
            "Employee Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
            "Date of First Appointment" := HREmp."Employment Date";
            Designation := HREmp."Job Title";
            Picture := HREmp.Image;
            "Current Scale" := HREmp."Salary Scale";
            "Scale Year" := HREmp.Present;
            DimensionValue.Reset();
            DimensionValue.SetRange(Code, HREmp."Global Dimension 2 Code");
            if DimensionValue.FindFirst() then begin
                "Department Code" := UpperCase(DimensionValue.Code);
                "Department Name" := UpperCase(DimensionValue.Name);
            end;

            DimensionValue.Reset();
            DimensionValue.SetRange(Code, HREmp."Global Dimension 1 Code");
            if DimensionValue.FindFirst() then begin
                "Directorate Code" := UpperCase(DimensionValue.Code);
                "Directorate Name" := UpperCase(DimensionValue.Name);
            end;
            //HREmp.TESTFIELD("Manager No.");
            "User ID" := HREmp."User ID";
            "Supervisor No." := HREmp."Manager No.";
            // MESSAGE('Here%1');
            //HREmp_2.RESET;
            //HREmp_2.SETRANGE(HREmp_2."No.",HREmp."Manager No.");
            //HREmp_2.FINDFIRST;
            //BEGIN
            //"Supervisor User ID":=HREmp_2."User ID";
            //"Supervisor Name":=HREmp_2."Search Name";
            //END;
            "E-mail" := HREmp."Company E-Mail";
        end;
        if UserSetups.Get(UserId) then begin
            "User Designation" := UserSetups.Designation;
            if UserSetups.Designation <> UserSetups.Designation::Officer then
                Manager := true;
        end;

        //*******************************************************Auto  insert Lines************************************************************************************
        //********************Insert Targets
        //Clear Existing Lines
        HRApprLinesDO.Reset();
        HRApprLinesDO.SetRange("Appraisal No.", "No.");
        if not HRApprLinesDO.IsEmpty() then HRApprLinesDO.DeleteAll();


        WPTargets.Reset();
        WPTargets.SetRange(WPTargets."Appraisal No.", "No.");
        if not WPTargets.IsEmpty() then WPTargets.DeleteAll();

        HRApprLinesDO.Reset;
        if HRApprLinesDO.FindLast then
            LineNoX := HRApprLinesDO."Line No"
        else
            LineNoX := 1;

        WPTargets.Reset;
        if WPTargets.FindLast then
            LineNoY := WPTargets."Line No."
        else
            LineNoY := 1;

        //Initialize Counter
        Clear(CountObjectives);
        WPLines.Reset();
        WPLines.SetRange(WPLines."Staff No", "Employee No.");
        WPLines.SetRange(WPLines.Period, "Appraisal Period.");
        if WPLines.FindSet(true) then begin
            CountObjectives := WPLines.Count();
            repeat

                HRApprLinesDO.Init();
                HRApprLinesDO."Line No" := LineNoX + 1;
                HRApprLinesDO."Appraisal No." := "No.";
                HRApprLinesDO."Objective Code" := WPLines."Objective Code";
                HRApprLinesDO."Objective Description" := WPLines.Objective;
                //HRApprLinesDO."Success Measure" := WPLines."Success Measure";
                HRApprLinesDO.Period := WPLines.Period;
                HRApprLinesDO."CWP Line" := WPLines.No;
                HRApprLinesDO."Staff No" := WPLines."Staff No";
                HRApprLinesDO.Insert();
                LineNoX += 1;

                /*WPTargets.INIT;
                WPTargets."Line No.":=LineNoY+1;
                WPTargets."Appraisal No.":="No.";
                WPTargets."Project Name":=WPLines.Project;
                WPTargets."Key Performance Indicator":=WPLines."Performance Measure/Indicator";
                WPTargets.Outcome:=WPLines."Performance Outcome";
                WPTargets."Staff No":=WPLines."Staff No";
                WPTargets."Project Name":=WPLines.Project;
                WPTargets.Objective:=WPLines."Performance Objective";
                WPTargets."Agreed Performance Targets":=WPLines.Targets;
                WPTargets.Perspective:=WPLines.Perspective;
                WPTargets.Activity:=WPLines.Activity;
                WPTargets."Appraisal Period":=WPLines.Period;
                WPTargets."Target Score":=WPLines."Target Score";
                WPTargets."Weight Total":=WPLines."Weight Total";
                WPTargets.INSERT();*/
                LineNoY += 1;

            until WPLines.Next = 0;
            Message('%1 Departmental objectives have been imported successfully', CountObjectives);
        end else begin
            Error('Please setup departmental objectives for the [ %1 ] department', "Department Code");
        end;

        //*********************Competence Values Lines***************************************************
        //Clear Existing Lines
        HRAppLinesValues.Reset();
        HRAppLinesValues.SetRange("Appraisal No.", "No.");
        if not HRAppLinesValues.IsEmpty() then HRAppLinesValues.DeleteAll();

        //Initialize Counter
        Clear(CountObjectives);

        HRAppValuesSetup.Reset();
        HRAppValuesSetup.SetFilter(HRAppValuesSetup.Category, '%1', HRAppValuesSetup.Category::"Staff Values & Core Competence");
        if HRAppValuesSetup.FindFirst then begin
            CountObjectives := HRAppValuesSetup.Count();

            repeat
                HRAppLinesValues.Init();
                HRAppLinesValues."Appraisal No." := "No.";
                HRAppLinesValues.Code := HRAppValuesSetup.Code;
                HRAppLinesValues.Category := HRAppValuesSetup.Category;
                HRAppLinesValues.Description := HRAppValuesSetup.Description;
                HRAppLinesValues."Appraisal Period" := HRAppValuesSetup."Appraisal Period";
                HRAppLinesValues.Insert(true);
            until HRAppValuesSetup.Next = 0;
            Message('%1 staff core competencies have been imported successfully', CountObjectives);
        end else begin
            Error('Please setup core competencies');
        end;

        //*******************************Load Peer Lines************************************************
        //Clear Existing Lines
        HRAppLines.Reset();
        HRAppLines.SetRange(HRAppLines."Appraisal No", "No.");
        HRAppLines.SetFilter(HRAppLines."Categorize As", '%1', EvaluationAreas."Categorize As"::"Employee's Peers");
        if not HRAppLines.IsEmpty() then HRAppLines.DeleteAll();

        //Initialize Counter
        Clear(CountObjectives);
        if HRAppLinesx.FindLast then
            LineNo := HRAppLinesx."Line No";
        EvaluationAreas.Reset();
        EvaluationAreas.SetFilter(EvaluationAreas."Categorize As", '%1', EvaluationAreas."Categorize As"::"Employee's Peers");
        if EvaluationAreas.FindFirst then begin
            CountObjectives := EvaluationAreas.Count();

            repeat
                LineNo := LineNo + 1;
                HRAppLines.Init();
                HRAppLines."Line No" := LineNo;
                HRAppLines."Appraisal No" := "No.";
                HRAppLines."Employee No" := "Employee No.";
                HRAppLines."Perfomance Goals and Targets" := EvaluationAreas.Description;
                HRAppLines."Sub Category" := EvaluationAreas."Sub Category";
                HRAppLines."Categorize As" := EvaluationAreas."Categorize As";
                HRAppLines."Appraisal Period" := EvaluationAreas."Appraisal Period";
                HRAppLines.Sections := EvaluationAreas.Code;
                HRAppLines.Insert(true);
            until EvaluationAreas.Next = 0;
            Message('%1 staff peer lines have been imported successfully', CountObjectives);
        end else begin
            Error('Please setup core competencies');
        end;

        //***************************Load External Evaluation Lines**********************************************
        //Clear Existing Lines
        HRAppLines.Reset();
        HRAppLines.SetRange(HRAppLines."Appraisal No", "No.");
        HRAppLines.SetFilter(HRAppLines."Categorize As", '%1', EvaluationAreas."Categorize As"::"External Sources");
        if not HRAppLines.IsEmpty() then HRAppLines.DeleteAll();

        //Initialize Counter
        Clear(CountObjectives);

        if HRAppLinesx.FindLast then
            LineNo := HRAppLinesx."Line No";

        EvaluationAreas.Reset();
        EvaluationAreas.SetFilter(EvaluationAreas."Categorize As", '%1', EvaluationAreas."Categorize As"::"External Sources");
        if EvaluationAreas.FindFirst then begin
            CountObjectives := EvaluationAreas.Count();

            repeat
                LineNo := LineNo + 1;
                HRAppLines.Init();
                HRAppLines."Line No" := LineNo;
                HRAppLines."Appraisal No" := "No.";
                HRAppLines."Employee No" := "Employee No.";
                HRAppLines."Perfomance Goals and Targets" := EvaluationAreas.Description;
                HRAppLines."Sub Category" := EvaluationAreas."Sub Category";
                HRAppLines."Categorize As" := EvaluationAreas."Categorize As";
                HRAppLines."Appraisal Period" := EvaluationAreas."Appraisal Period";
                HRAppLines.Sections := EvaluationAreas.Code;
                HRAppLines.Insert(true);
            until EvaluationAreas.Next = 0;
        end else begin
            Error('Please setup core competencies');
        end;

        //***********************Load Subordinate Lines*******************************************************************
        //Clear Existing Lines
        HRAppLines.Reset();
        HRAppLines.SetRange(HRAppLines."Appraisal No", "No.");
        HRAppLines.SetFilter(HRAppLines."Categorize As", '%1', EvaluationAreas."Categorize As"::"Employee's Subordinates");
        if not HRAppLines.IsEmpty() then HRAppLines.DeleteAll();

        //Initialize Counter
        Clear(CountObjectives);
        if HRAppLinesx.FindLast then
            LineNo := HRAppLinesx."Line No";
        EvaluationAreas.Reset();
        EvaluationAreas.SetFilter(EvaluationAreas."Categorize As", '%1', EvaluationAreas."Categorize As"::"Employee's Subordinates");
        if EvaluationAreas.FindFirst then begin
            CountObjectives := EvaluationAreas.Count();

            repeat
                LineNo := LineNo + 1;
                HRAppLines.Init();
                HRAppLines."Line No" := LineNo;
                HRAppLines."Appraisal No" := "No.";
                HRAppLines."Employee No" := "Employee No.";
                HRAppLines."Perfomance Goals and Targets" := EvaluationAreas.Description;
                HRAppLines."Sub Category" := EvaluationAreas."Sub Category";
                HRAppLines."Categorize As" := EvaluationAreas."Categorize As";
                HRAppLines."Appraisal Period" := EvaluationAreas."Appraisal Period";
                HRAppLines.Sections := EvaluationAreas.Code;
                HRAppLines.Insert(true);
            until EvaluationAreas.Next = 0;
            Message('%1 staff peer lines have been imported successfully', CountObjectives);
        end else begin
            Error('Please setup core competencies');
        end;

    end;

    var
        HRAppHeader: Record "HR Appraisal Header";
        HREmp: Record Employee;
        HREmpCopy: Record Employee;
        NoSeriesMgt: Codeunit "No. Series";
        HREmpCard: Page "Employee Card";
        //HRAppraisalRatings: Record "HR Targets Indicator";
        HRAppraisalGoalSettingH: Record "HR Appraisal Header";
        //HRGoalSettingL: Record "Appraisal Strategic Objectives";
        //HRGoalSettingLNext: Record "Appraisal Strategic Objectives";
        HRLookUpValues: Record "HR Lookup Values";
        LastAppraisal: Record "HR Appraisal Header";
        CompanyScoreAppraisee: Decimal;
        KPIScoreAppraisee: Decimal;
        PFScoreAppraisee: Decimal;
        PFBase: Decimal;
        //HrRatings: Record "HR Targets Indicator";
        UserSetup: Record "User Setup";
        Approver: Record "User Setup";
        KPIScoreAppraiser: Decimal;
        KPIScoreMgt: Decimal;
        PFScoreAppraiser: Decimal;
        PFScoreMgt: Decimal;
        //AppraisalStrObj: Record "Appraisal Strategic Objectives";
        //Appraisalobj: Record "Appraisal Strategic Objectives";
        LineNo: Integer;
        DimensionValue: Record "Dimension Value";
        HRAppraisalPeriodsSetup: Record "HR Appraisal Periods";
        HRAppPeriod: Record "HR Appraisal Periods";
        Periods: Record "HR Appraisal Periods";
        PerformanceSetup: Record "Perfomance Management Setup";
        UserSetups: Record "User Setup";
        HRAppDeptObjSetup: Record "HR Appraisal Dept. Obj. Setup";
        HRAppValuesSetup: Record "HR Appraisal Values and Compt.";
        HRApprLinesDO: Record "HR Appraisal Lines - DO";
        HRAppLinesValues: Record "HR Appraisal Lines - Values";
        CountObjectives: Integer;
        HRAppLines: Record "HR Appraisal Lines";
        EvaluationAreas: Record "HR Appraisal Eval Areas";
        HRAppLinesx: Record "HR Appraisal Lines";
        //PerformanceCU: Codeunit "Perfomance Management";
        SubordinatesVisible: Boolean;
        StyleEditable: Text;
        WPLines: Record "Staff Target Lines";
        WPTargets: Record "HR Appraisal Lines - PT";
        AssignUser: Boolean;
}