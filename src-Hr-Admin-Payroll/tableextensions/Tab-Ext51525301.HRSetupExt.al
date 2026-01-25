tableextension 51525301 "HR Setup Ext" extends "Human Resources Setup"
{
    fields
    {
        field(51525300; "Tax Table"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bracket Tables";
        }
        field(51525301; "Corporation Tax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525302; "Housing Earned Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525303; "Pension Limit Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525304; "Pension Limit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525305; "Round Down"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525306; "Working Hours"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525308; "Payroll Rounding Precision"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525309; "Payroll Rounding Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Nearest,Up,Down;
        }
        field(51525310; "Special Duty Table"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(51525311; "CFW Round Deduction code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Deductions;
        }
        field(51525312; "BFW Round Earning code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Earnings;
        }
        field(51525313; "Company overtime hours"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525314; "Loan Product Type Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(51525315; "Tax Relief Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525316; "General Payslip Message"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(51525320; "Incoming Mail Server"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51525321; "Outgoing Mail Server"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51525322; "Email Text"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(51525323; "Sender User ID"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51525324; "Sender Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(51525325; "Email Subject"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(51525326; "Template Location"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(51525327; "Applicants Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(51525328; "Leave Application Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(51525329; "Recruitment Needs Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(51525330; "Disciplinary Cases Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(51525331; "No. Of Days in Month"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        /*  field(551525332; "Transport Request Nos"; Code[10])
         {
             DataClassification = ToBeClassified;
             TableRelation = "No. Series";
         } */
        field(51525333; "Cover Selection Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525334; "Qualification Days (Leave)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525335; "Leave Allowance Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Earnings.Code;
        }
        field(51525336; "Telephone Request Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525337; "Training Request Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525338; "Leave Recall Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525339; "Medical Claim Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525340; "Account No (Training)"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(51525341; "Training Evaluation Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525342; "Off Days Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Leave Types";
        }
        field(51525343; "Appraisal Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525344; "Leave Plan Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525345; "Keys Request Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525346; "Incidences Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525347; "Sick Of Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525348; "Conveyance Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525349; "Base Calender Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Base Calendar".Code;
        }
        field(51525350; "Membership No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525352; "Employee Absentism"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525356; "Conf/Sem/Request"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525357; "Conf/Sem Evaluation"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525358; "Monthly PayDate"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(51525359; "User Incident"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525360; "DMS LINK"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(51525361; "Vehicle Filling No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525362; "Savings Withdrawal No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525363; "All Staff Mail"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(51525364; "Resource Request Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525365; "Appraisal Objective Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525366; "Probation Period(Months)"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(51525367; "Retirement Age"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(51525368; "Owner occupier interest"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Earnings;
        }
        field(51525369; "Technical Competence Overall %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525370; "Behaviour Competence Overall %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525371; "Training Need Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525372; "Training Needs Request Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525373; "Employee Training Need Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525374; "Job Structure Identifier"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Structure Identifier Tables";
        }
        field(51525375; "Fleet Accident Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525376; "Maintenance Req Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525377; "Grievance Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525378; "Medical Claim Account No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(51525379; "JobApplication Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525380; "Overtime Earning Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525381; "Contract Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525382; "Training Assessment Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525383; "Email Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525384; "Salary Increment Period"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(51525385; "Payroll Administrator Email"; Text[30])
        {
            Caption = 'Payroll Email';
            DataClassification = ToBeClassified;
        }
        field(51525386; "Share Top Up Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525387; "Signature Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525388; "Pension Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Deductions;
        }
        field(51525389; "Pension Arrears Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Deductions;
        }
        field(51525390; NITA; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Deductions;
        }
        field(51525391; "Disciplinary Cases File"; Text[240])
        {
            DataClassification = ToBeClassified;
        }
        field(51525392; "Disciplinary Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525393; "Payroll Template"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51525394; "Payroll Journal Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51525395; "Recruitment  File Path"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(51525396; "Excess Leave Days No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525397; "Training Evaluation Documents"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(51525398; "Training Evaluation Cert Path"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(51525399; "Payable Leave Days"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525400; "Absence No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525401; "Transport DMS Link"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(51525402; "Insurance Attachments"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(51525403; "FY Deadline-Training Proposals"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(51525404; "Leave Adjustment Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525405; "Employee Transfer Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525406; "Employee Nos(Interns)"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525407; "Car Loan Documents Path"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(51525408; "Car Loan Request Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525409; "Salary Advance Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525410; "Mortgage Request Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525411; "HR HOD"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(51525412; CEO; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(51525413; "Director CS"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(51525414; "Exit Interview Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525415; "Intern Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525416; "Employee On Contract Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525417; "Job Application No"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525418; "Payroll Processing No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525419; "Repair Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525420; "HelpDesk Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        /*field(51525421; "Asset Transfer No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }*/
        field(51525422; "Use Fiscal Year"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525423; "Batch Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525424; "Retirement Age PWD"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(51525425; "Employee Data Directory Name"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(51525426; "Change Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525427; "Leave Posting Period[FROM]"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(51525428; "Leave Posting Period[TO]"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(51525429; "Default Leave Posting Template"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Leave Journal Template".Name;
        }
        field(51525430; "Positive Leave Posting Batch"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Leave Journal Batch".Name;
        }
        field(51525431; ExcessLeave; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Carry forward,Convet to Money';
            OptionMembers = "Carry forward","Convet to Kshs";
        }
        field(51525432; conversionRation; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525433; "Control account"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
        field(51525434; "Leave Allowance Days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(51525435; "Leave Allowance Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525436; "Annual Leave Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Leave Types".Code;
        }
        field(51525437; Workplans; Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        /*field(51525438; "Asset Requisitions"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525439; "Asset Allocation"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }*/
        field(51525440; "Employee Timesheet No's"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525442; "Company NHIF No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51525443; "Company NSSF No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51525444; "Company KRA No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51525445; "NITA Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525446; "Path to Save Employee Data"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(51525447; "HR Department Email"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(51525448; "Insurance Relief Rate (%)"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(51525449; "PAYE Flat Rate (%)"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(51525450; "Max Tax Exemption Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525451; "Final Payroll Adm Day"; Integer)
        {
            trigger OnValidate()
            begin
                if ("Final Payroll Adm Day" < 0) or ("Final Payroll Adm Day" > 31) then
                    Error('The day value should range from 0 to 31');
            end;
        }
        field(51525452; "Last PartNo"; Code[50])
        { }
        field(51525453; "Suspend Probation Reminders"; Boolean)
        { }
        field(51525454; "Suspend 10-year Reminders"; Boolean)
        { }
        field(51525455; "Suspend Retirement Reminders"; Boolean)
        { }
        field(51525456; "Suspend Contract Reminders"; Boolean)
        { }
        field(51525457; "Onboarding Section Email"; Text[250])
        { }
        field(51525458; "Edit Bank Details"; Boolean)
        { }
        field(51525459; "Edit Pension Details"; Boolean)
        { }
        field(51525460; "Edit Medical Details"; Boolean)
        { }
        field(51525461; "Edit TIN Details"; Boolean)
        { }
        field(51525462; "10Y Notification Start Date"; Date)
        { }
        field(51525463; "Special Transport Allowance"; Decimal)
        {
            Caption = 'Special Transport Allowance Cutoff (RWF)';
        }
        field(51525464; "Airtime Request Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525465; "Airtime Mgmt E-Mail"; Text[200])
        {

        }
        field(51525466; "Hotel Request Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525467; "Hotel Mgmt E-Mail"; Text[200])
        {

        }
        field(51525468; "Refreshment Request Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525469; "Refreshment Mgmt E-Mail"; Text[200])
        {

        }
        field(51525470; "Room Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525471; "Room Booking Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525472; "Room Mgmt E-Mail"; Text[200])
        {

        }
        field(51525473; "Requisition Fees Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525474; "Memo Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525475; "Shift Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(51525476; "Accident / Incident"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        /* field(51525477;  "Transport Request Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        } */

    }
}
