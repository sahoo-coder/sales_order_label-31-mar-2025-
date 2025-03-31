report 70359 salesOrderLabel
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './salesOrderLabel.rdl';
    Caption = 'Label Report_KSS';

    dataset
    {
        dataitem("Barcode Table"; "Barcode Table")
        {
            column(Item_No; Item_No) { }
            column(Description; Description) { }
            column(barcode; barcode) { }
            trigger OnPreDataItem()
            var
                I: Integer;
                currQuantity: Integer;
                entry: Integer;
            begin
                "Barcode Table".Reset();
                "Barcode Table".DeleteAll();
                entry := 0;
                if orderNumber <> '' then begin
                    salesLine.SetRange("Document Type", salesLine."Document Type"::Order);
                    salesLine.SetRange("Document No.", orderNumber);
                    if salesLine.FindSet() then
                        repeat
                            currQuantity := salesLine.Quantity;
                            if currQuantity > 0 then begin
                                BarCodeItemNo(salesLine."No.");
                                for I := 1 to currQuantity do begin
                                    entry += 1;
                                    "Barcode Table".EntryNo := entry;
                                    "Barcode Table".Item_No := salesLine."No.";
                                    "Barcode Table".Description := salesLine.Description;
                                    "Barcode Table".barcode := BarcdItemNo;
                                    "Barcode Table".Insert();
                                end;
                            end;
                        until salesLine.Next() = 0;
                end;
            end;

        }
    }

    requestpage
    {
        SaveValues = true;
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group("Label Printer_KSS")
                {
                    field(orderNumber; orderNumber)
                    {
                        Caption = 'Sales Order Number...';
                        ApplicationArea = All;
                        TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {

                }
            }
        }
    }
    procedure BarCodeItemNo(item_no: Code[20])
    var
        BarcodeFontProvider: Interface "Barcode Font Provider";
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeString: Code[50];
    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code128;
        BarcodeString := item_no;
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        BarcdItemNo := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
    end;

    var
        orderNumber: Code[30];
        BarcdItemNo: Text;
        currQuantity: Integer;
        salesLine: Record "Sales Line";
}