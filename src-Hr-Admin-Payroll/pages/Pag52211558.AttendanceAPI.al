page 52211558 "Attendance API"
{
    PageType = API;
    SourceTable = "Attendance Staging";
    APIPublisher = 'org';
    APIGroup = 'attendance';
    APIVersion = 'v1.0';
    EntityName = 'attendanceLog';
    EntitySetName = 'attendanceLogs';
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(employeeNo; Rec."Employee No.") { }
                field(employeeName; Rec."Employee Name") { }
                field(logDate; Rec."Log Date") { }
                field(logInTime; Rec."Log In Time") { }
                field(logOutTime; Rec."Log Out Time") { }
                field(deviceId; Rec."Device ID") { }
            }
        }
    }
}
