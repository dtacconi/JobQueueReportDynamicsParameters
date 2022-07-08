page 50115 "Job Queue Rep.Field Sub. List"
{
    Caption = 'Job Queue Rep.Field Sub. List';
    PageType = List;
    ApplicationArea = All;
    Editable = true;
    UsageCategory = Lists;
    SourceTable = "Job Queue Report Field Subst.";
    
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Report ID"; Rec."Report ID")
                {
                    ApplicationArea = All;
                }
                field("Report Caption"; Rec."Report Caption")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Field Type"; Rec."Job Queue Report Field Type")
                {
                    ApplicationArea = All;
                }
                field("Option Field Name"; Rec."Name")
                {
                    ApplicationArea = All;
                }
                field("Req. Page Field Id"; Rec."Req. Page Field Id")
                {
                    ApplicationArea = All;
                }
                field("Substitute Value"; Rec."Substitute Value")
                {
                    ApplicationArea = All;
                }
            }
        }
    }    
}