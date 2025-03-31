report 70361 customerwiseSalesReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './customerwiseSalesReport.rdl';
    Caption = 'Sales Report Of Customers_KSS';

    dataset
    {
        dataitem("Customer Wise Sales Table"; "Customer Wise Sales Table")
        {
            column(customer_no; customer_no) { }
            column(customer_name; customer_name) { }
            column(sales_person_name; sales_person_name) { }
            column(total_sales; total_sales) { }

            trigger OnPreDataItem()
            var
                customer: Record Customer;
                salesPersonPurchaser: Record "Salesperson/Purchaser";
                salesInvoiceHeader: Record "Sales Invoice Header";
                salesInvoiceLine: Record "Sales Invoice Line";
                pkIncreament: Integer;
            begin
                "Customer Wise Sales Table".Reset();
                "Customer Wise Sales Table".DeleteAll();
                pkIncreament := 0;
                if customer.FindSet() then
                    repeat
                        if salesPersonPurchaser.FindSet() then
                            repeat
                                totalSales := 0;
                                salesInvoiceHeader.Reset();
                                salesInvoiceHeader.SetRange("Salesperson Code", salesPersonPurchaser.Code);
                                if not salesInvoiceHeader.IsEmpty then begin
                                    salesInvoiceHeader.SetRange("Sell-to Customer No.", customer."No.");
                                    salesInvoiceHeader.SetFilter("Posting Date", '%1..%2', startDate, endDate);
                                    if salesInvoiceHeader.FindSet() then
                                        repeat
                                            salesInvoiceLine.Reset();
                                            salesInvoiceLine.SetRange("Document No.", salesInvoiceHeader."No.");
                                            if salesInvoiceLine.FindSet() then
                                                repeat
                                                    totalSales += salesInvoiceLine.Amount;
                                                until salesInvoiceLine.Next() = 0;
                                        until salesInvoiceHeader.Next() = 0;

                                    if totalSales > 0 then begin
                                        pkIncreament += 1;
                                        "Customer Wise Sales Table".customer_no := customer."No.";
                                        "Customer Wise Sales Table".customer_name := customer.Name;
                                        "Customer Wise Sales Table".entryNo := pkIncreament;
                                        "Customer Wise Sales Table".sales_person_name := salesPersonPurchaser.Name;
                                        "Customer Wise Sales Table".total_sales := totalSales;
                                        "Customer Wise Sales Table".Insert();
                                    end;
                                end;
                            until salesPersonPurchaser.Next() = 0;
                    until customer.Next() = 0;
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
                group("Date Range_KSS")
                {
                    field(startDate; startDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea = All;
                    }
                    field(endDate; endDate)
                    {
                        Caption = 'End Date';
                        ApplicationArea = All;
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

    var
        startDate: Date;
        endDate: Date;
        totalSales: Decimal;
}