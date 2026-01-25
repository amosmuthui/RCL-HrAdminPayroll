pageextension 51525303 "Administrator RC Ext HR" extends "Administrator Role Center"
{
    actions
    {
        addafter(WBSections)
        {
            action(Stations)
            {
                ApplicationArea = Suite;
                RunObject = Page Stations;
            }
            action("Sub Sections")
            {
                ApplicationArea = Suite;
                RunObject = Page "Sub Sections";
            }
        }
    }
}
