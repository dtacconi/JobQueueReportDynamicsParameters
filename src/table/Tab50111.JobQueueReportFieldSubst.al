table 50111 "Job Queue Report Field Subst."
{
    Caption = 'Job Queue Report Field Substitution';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Report));

            trigger OnValidate()
            begin
                CalcFields("Report Caption");
            end;
        }
        field(2; "Report Caption"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report),
                                                                           "Object ID" = FIELD("Report ID")));
            Caption = 'Report Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Job Queue Report Field Type"; Enum "Job Queue Report Field Type")
        {
            Caption = 'Job Queue Report Field Type';
        }
        field(4; "Name"; Text[100])
        {
            Caption = 'Name';
        }
        field(5; "Req. Page Field Id"; Integer)
        {
            Caption = 'Req. Page Field Id';
        }
        field(6; "Substitute Value"; Enum "Job Queue Report Field Subst.")
        {
            Caption = 'Substitute Value';
        }
    }

    keys
    {
        key(Key1; "Report ID", "Job Queue Report Field Type","Name", "Req. Page Field Id")
        {
            Clustered = true;
        }
    }
    
}