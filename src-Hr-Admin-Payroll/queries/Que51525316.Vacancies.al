query 51525316 Vacancies
{
    OrderBy = Ascending(End_Date);

    elements
    {
        dataitem(Recruitment_Needs; "Recruitment Needs")
        {
            column(No; "No.")
            {
            }
            column(Job_ID; "Job ID")
            {
            }
            column(Date; Date)
            {
            }
            column(Priority; Priority)
            {
            }
            column(Positions; Positions)
            {
            }
            column(Approved; Approved)
            {
            }
            column(Date_Approved; "Date Approved")
            {
            }
            column(Description; Description)
            {
            }
            column(Score; Score)
            {
            }
            column(Stage_Code; "Stage Code")
            {
            }
            column(Qualified; Qualified)
            {
            }
            column(Start_Date; "Start Date")
            {
            }
            column(End_Date; "End Date")
            {
            }
            column(Documentation_Link; "Documentation Link")
            {
            }
            column(Turn_Around_Time; "Turn Around Time")
            {
            }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code")
            {
            }
            column(No_Series; "No. Series")
            {
            }
            column(Reason_for_Recruitment; "Reason for Recruitment")
            {
            }
            column(Appointment_Type; "Appointment Type")
            {
            }
            column(Requested_By; "Requested By")
            {
            }
            column(Expected_Reporting_Date; "Expected Reporting Date")
            {
            }
            column(Status; Status)
            {
            }
            column(Recruitment_Cycle; "Recruitment Cycle")
            {
            }
            column(Degree; Degree)
            {
            }
            column(Masters; Masters)
            {
            }
            column(PHD; PHD)
            {
            }
            column(Certification; Certification)
            {
            }
            column(Professional_Body; "Professional Body")
            {
            }
            column(diploma; diploma)
            {
            }
            column(Shortlisting_Criteria; "Shortlisting Criteria")
            {
            }
            column(Experience_Yrs; "Experience(Yrs)")
            {
            }
            column(Level_Or_Higher; "Level Or Higher")
            {
            }
            column(Course_1; "Course 1")
            {
            }
            column(Course_2; "Course 2")
            {
            }
            column(Masters_Course; "Masters Course")
            {
            }
            column(Course_3; "Course 3")
            {
            }
            column(PHD_Course; "PHD Course")
            {
            }
            column(Professional_Body_1; "Professional Body 1")
            {
            }
            column(Professional_Body_2; "Professional Body 2")
            {
            }
            column(Professional_Body_3; "Professional Body 3")
            {
            }
            column(Professional_Body_4; "Professional Body 4")
            {
            }
            column(Professional_Body_5; "Professional Body 5")
            {
            }
            column(Short_Listing_Done; "Short Listing Done?")
            {
            }
            column(Requires_Aptitude_Test; "Requires Aptitude Test")
            {
            }
            column(Minutes_Path; "Minutes Path")
            {
            }
            column(Recruitment_Closed; "Recruitment Closed")
            {
            }
            column(In_Oral_Test; "In Oral Test")
            {
            }
            column(Past_Oral_Test; "Past Oral Test")
            {
            }
            column(Closed_Applications; "Closed Applications")
            {
            }
            column(Panelist_1; "Panelist 1")
            {
            }
            column(Panelist_2; "Panelist 2")
            {
            }
            column(Panelist_3; "Panelist 3")
            {
            }
            column(Panelist_4; "Panelist 4")
            {
            }
            column(Panelist_5; "Panelist 5")
            {
            }
            column(DateTimeAdded; DateTimeAdded)
            {
            }
            column(isInternship; isInternship)
            {
            }
            column(Oral_Interview_Complete; "Oral Interview Complete")
            {
            }
            column(Technical_Interview_Complete; "Technical Interview Complete")
            {
            }
            column(Closed; Closed)
            {
            }
            column(Requisition_Type; "Requisition Type")
            {
            }
            column(Employee_No; "Employee No.")
            {
            }
            column(Employee_Name; "Employee Name")
            {
            }
            column(Global_Dimension_1; "Global Dimension 1")
            {
            }
            column(Global_Dimension_2; "Global Dimension 2")
            {
            }
            column(Shortcut_Dimension_3; "Shortcut Dimension 3")
            {
            }
            column(Portal_Generated; "Portal Generated")
            {
            }
            column(Cert_of_Good_Conduct_Attached; "Cert of Good Conduct Attached")
            {
            }
            column(HELB_Clearance_Attached; "HELB Clearance Attached")
            {
            }
            column(E_A_C_C_Clearance_Attached; "E.A.C.C Clearance Attached")
            {
            }
            column(CRB_Clearance_Attached; "CRB Clearance Attached")
            {
            }
            column(TAX_Compliance_Attached; "TAX Compliance Attached")
            {
            }
            column(Advertisement_Link; "Advertisement Link")
            {
            }
            column(Select_Top; "Select Top")
            {
            }
            column(Pass_Mark; "Pass Mark")
            {
            }
            column(Total_Interview_Score; "Total Interview Score")
            {
            }
            column(Validate_Required_Attachments; "Validate Required Attachments")
            {
            }
            column(Validate_Prof_Documents; "Validate Prof Documents")
            {
            }
            column(Minimum_Academic_Level; "Minimum Academic Level")
            {
            }
            column(Other_Requirements; "Other Requirements")
            {
            }
            column(Minimum_Academic_Level_Lk; "Minimum Academic Level Lk")
            {
            }
            column(Reporting_To; "Reporting To")
            {
            }
            column(Reporting_To_Desc; "Reporting To(Desc)")
            {
            }
        }
    }
    trigger OnBeforeOpen()
    begin
        CurrQuery.Setfilter("Start_Date", '<=%1', TODAY);
        CurrQuery.Setfilter("End_Date", '>=%1', TODAY);
        CurrQuery.SetRange(Closed, false);
        CurrQuery.SetFilter(Requisition_Type, '<>%1', Requisition_Type::Internal);
    end;
}