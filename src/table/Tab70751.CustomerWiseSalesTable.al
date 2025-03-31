table 70751 "Customer Wise Sales Table"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; entryNo; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; customer_no; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3; customer_name; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; sales_person_name; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; total_sales; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; entryNo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}