report 51525382 "Claims Report"
{
    Caption = 'Claims Report';
    dataset
    {
        dataitem(MedicalClaimHeader; "Medical Claim Header")
        {
            column(ClaimNo; "Claim No")
            {
            }
            column(ClaimDate; "Claim Date")
            {
            }
            column(Claimant; Claimant)
            {
            }
            column(ClaimantName; "Claimant Name")
            {
            }
            column(ClaimantNo; "Claimant No.")
            {
            }
            column(Amount; Amount)
            {
            }
            column(Department; Department)
            {
            }
            column(ServiceProviderName; "Service Provider Name")
            {
            }
            dataitem("Claim Line"; "Claim Line")
            {
                DataItemLink = "Claim No" = FIELD("Claim No");

                column(Employee_Name; "Employee Name")
                {

                }
                column(Claim_No; "Claim No")
                {

                }
                column(Department1; Department)
                {

                }
                column(Medical_Scheme; "Medical Scheme")
                {

                }
                column(Invoice_Number; "Invoice Number")
                {

                }
                column(AmountLines; Amount)
                {

                }

            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
