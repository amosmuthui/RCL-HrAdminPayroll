report 51525356 "Job Description"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/JobDescription.rdlc';

    dataset
    {
        dataitem("Company Jobs"; "Company Jobs")
        {
            RequestFilterFields = "Job ID";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Company_Jobs1__Job_ID_; "Job ID")
            {
            }
            column(Company_Jobs1__Job_Description_; "Job Description")
            {
            }
            column(Company_Jobs1__Occupied_Position_; "Occupied Establishments")
            {
            }
            column(Company_Jobs1__Vacant_Posistions_; "Vacant Establishments")
            {
            }
            column(Company_Jobs1__Dimension_1_; "Dimension 1")
            {
            }
            column(Company_Jobs1__No_of_Position_; "No of Position")
            {
            }
            column(Company_Jobs1_Objective; Objective)
            {
            }
            column(Company_Jobs1__Key_Position_; "Key Position")
            {
            }
            column(Company_Jobs1_Category; Category)
            {
            }
            column(Company_Jobs1_Grade; Grade)
            {
            }
            column(Job_DescriptionCaption; Job_DescriptionCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Company_Jobs1__Job_ID_Caption; FieldCaption("Job ID"))
            {
            }
            column(Company_Jobs1__Job_Description_Caption; FieldCaption("Job Description"))
            {
            }
            column(Company_Jobs1__Occupied_Position_Caption; FieldCaption("Occupied Establishments"))
            {
            }
            column(Company_Jobs1__Vacant_Posistions_Caption; FieldCaption("Vacant Establishments"))
            {
            }
            column(Company_Jobs1__Dimension_1_Caption; FieldCaption("Dimension 1"))
            {
            }
            column(Company_Jobs1__No_of_Position_Caption; FieldCaption("No of Position"))
            {
            }
            column(Position_Function_Objective_Caption; Position_Function_Objective_CaptionLbl)
            {
            }
            column(Company_Jobs1__Key_Position_Caption; FieldCaption("Key Position"))
            {
            }
            column(Company_Jobs1_CategoryCaption; FieldCaption(Category))
            {
            }
            column(Company_Jobs1_GradeCaption; FieldCaption(Grade))
            {
            }
            dataitem("Position Supervised"; "Position Supervised")
            {
                DataItemLink = "Job ID" = FIELD("Job ID");
                column(Position_Supervised1_Description; Description)
                {
                }
                column(Positions_Supervised_Caption; Positions_Supervised_CaptionLbl)
                {
                }
                column(Position_Supervised1_Job_ID; "Job ID")
                {
                }
                column(Position_Supervised1_Position_Supervised; "Position Supervised")
                {
                }
            }
            dataitem("Job Responsiblities"; "Job Responsiblities")
            {
                DataItemLink = "Job ID" = FIELD("Job ID");
                column(Job_Responsiblities1_Responsibility; Responsibility)
                {
                }
                column(Key_Responsibilities_Caption; Key_Responsibilities_CaptionLbl)
                {
                }
                column(EmptyStringCaption; EmptyStringCaptionLbl)
                {
                }
                column(Job_Responsiblities1_Job_ID; "Job ID")
                {
                }
            }
            dataitem("Job Requirement"; "Job Requirement")
            {
                DataItemLink = "Job Id" = FIELD("Job ID");
                column(Job_Requirement1__Qualification_Type_; "Qualification Type")
                {
                }
                column(Job_Requirement1_Qualification; Qualification)
                {
                }
                column(Job_Specifications_Caption; Job_Specifications_CaptionLbl)
                {
                }
                column(EmptyStringCaption_Control1000000010; EmptyStringCaption_Control1000000010Lbl)
                {
                }
                column(Job_Requirement1_Job_Id; "Job Id")
                {
                }
                column(Job_Requirement1_Qualification_Code; "Qualification Code")
                {
                }

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FieldNo("Job Requirement"."Qualification Type");
                end;
            }
            dataitem("Job Working Relationships"; "Job Working Relationships")
            {
                DataItemLink = "Job ID" = FIELD("Job ID");
                column(Job_Working_Relationships1_Type; Type)
                {
                }
                column(Job_Working_Relationships1_Relationship; Relationship)
                {
                }
                column(Working_Relationships_Caption; Working_Relationships_CaptionLbl)
                {
                }
                column(EmptyStringCaption_Control1000000016; EmptyStringCaption_Control1000000016Lbl)
                {
                }
                column(Job_Working_Relationships1_Job_ID; "Job ID")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        LastFieldNo: Integer;
        Job_DescriptionCaptionLbl: Label 'Job Description';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Position_Function_Objective_CaptionLbl: Label 'Position Function/Objective:';
        Positions_Supervised_CaptionLbl: Label 'Positions Supervised:';
        Key_Responsibilities_CaptionLbl: Label 'Key Responsibilities:';
        EmptyStringCaptionLbl: Label '-';
        Job_Specifications_CaptionLbl: Label 'Job Specifications:';
        EmptyStringCaption_Control1000000010Lbl: Label '-';
        Working_Relationships_CaptionLbl: Label 'Working Relationships:';
        EmptyStringCaption_Control1000000016Lbl: Label '-';
}