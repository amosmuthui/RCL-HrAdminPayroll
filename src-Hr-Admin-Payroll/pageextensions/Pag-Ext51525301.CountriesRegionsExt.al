pageextension 51525301 "Countries/Regions Ext" extends "Countries/Regions"
{
    layout
    {
        addafter(Name)
        {
            field("Country Currency"; Rec."Country Currency")
            {
                ApplicationArea = All;
            }
            field("Contractual Amount Type"; Rec."Contractual Amount Type")
            {
                ApplicationArea = All;
            }
            field("Retirement Benefit Table"; Rec."Retirement Benefit Table")
            {
                ApplicationArea = All;
            }
        }
    }
}
