import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import '../models/sales_bill.dart';
import '../models/purchase_bill.dart';
import '../utils/constants.dart';

class ExcelGenerator {
  static Future<void> generateBusinessReportExcel({
    required DateTime startDate,
    required DateTime endDate,
    required double totalSales,
    required double totalPurchases,
    required double totalGst,
    required int salesCount,
    required int purchaseCount,
    required List<SalesBill> salesBills,
    required List<PurchaseBill> purchaseBills,
  }) async {
    var excel = Excel.createExcel();
    var summarySheet = excel['Summary'];
    var salesSheet = excel['Sales'];
    var purchaseSheet = excel['Purchase'];

    // Remove default sheet
    excel.delete('Sheet1');

    // Summary Sheet
    _generateSummarySheet(
      summarySheet,
      startDate,
      endDate,
      totalSales,
      totalPurchases,
      totalGst,
      salesCount,
      purchaseCount,
    );

    // Sales Sheet
    _generateSalesSheet(salesSheet, salesBills);

    // Purchase Sheet
    _generatePurchaseSheet(purchaseSheet, purchaseBills);

    // Save file
    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Business Report',
      fileName:
          'Business_Report_${formatDate(startDate)}_${formatDate(endDate)}.xlsx',
    );

    if (result != null) {
      final file = File(result);
      await file.writeAsBytes(excel.save()!);
    }
  }

  static void _generateSummarySheet(
    Sheet sheet,
    DateTime startDate,
    DateTime endDate,
    double totalSales,
    double totalPurchases,
    double totalGst,
    int salesCount,
    int purchaseCount,
  ) {
    // Title
    sheet.merge(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
        CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0));
    var titleCell =
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    titleCell.value = TextCellValue('BUSINESS REPORT');
    titleCell.cellStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      fontSize: 16,
    );

    // Period
    var periodCell =
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 2));
    periodCell.value = TextCellValue(
        'Period: ${formatDate(startDate)} - ${formatDate(endDate)}');

    // Statistics
    var currentRow = 4;
    _addSummaryRow(
        sheet, currentRow++, 'Total Sales', formatCurrency(totalSales));
    _addSummaryRow(
        sheet, currentRow++, 'Total Purchases', formatCurrency(totalPurchases));
    _addSummaryRow(sheet, currentRow++, 'Profit/Loss',
        formatCurrency(totalSales - totalPurchases));
    _addSummaryRow(sheet, currentRow++, 'Total GST', formatCurrency(totalGst));
    _addSummaryRow(
        sheet, currentRow++, 'Sales Bills Count', salesCount.toString());
    _addSummaryRow(
        sheet, currentRow++, 'Purchase Bills Count', purchaseCount.toString());

    // Format columns
    sheet.setColumnWidth(0, 25);
    sheet.setColumnWidth(1, 15);
  }

  static void _generateSalesSheet(Sheet sheet, List<SalesBill> bills) {
    // Headers
    final headers = [
      'Bill ID',
      'Date',
      'Customer',
      'Items',
      'Subtotal',
      'GST',
      'Total',
      'Notes'
    ];

    for (var i = 0; i < headers.length; i++) {
      var cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = CellStyle(bold: true);
    }

    // Data
    var row = 1;
    for (var bill in bills) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .value = TextCellValue(bill.id);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
          .value = TextCellValue(formatDate(bill.billDate));
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
          .value = TextCellValue(bill.customerName);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
          .value = TextCellValue(bill.items.length.toString());
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
          .value = TextCellValue(formatCurrency(bill.subtotal));
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
          .value = TextCellValue(formatCurrency(bill.totalGst));
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row))
          .value = TextCellValue(formatCurrency(bill.grandTotal));
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row))
          .value = TextCellValue(bill.notes ?? '');
      row++;
    }

    // Format columns
    for (var i = 0; i < headers.length; i++) {
      sheet.setColumnWidth(i, 15);
    }
  }

  static void _generatePurchaseSheet(Sheet sheet, List<PurchaseBill> bills) {
    // Headers
    final headers = [
      'PO ID',
      'Date',
      'Supplier',
      'Bill Number',
      'Items',
      'Subtotal',
      'GST',
      'Total',
      'Notes'
    ];

    for (var i = 0; i < headers.length; i++) {
      var cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = CellStyle(bold: true);
    }

    // Data
    var row = 1;
    for (var bill in bills) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .value = TextCellValue(bill.id);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
          .value = TextCellValue(formatDate(bill.billDate));
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
          .value = TextCellValue(bill.supplierName);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
          .value = TextCellValue(bill.billNumber ?? '');
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
          .value = TextCellValue(bill.items.length.toString());
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
          .value = TextCellValue(formatCurrency(bill.subtotal));
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row))
          .value = TextCellValue(formatCurrency(bill.totalGst));
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row))
          .value = TextCellValue(formatCurrency(bill.grandTotal));
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: row))
          .value = TextCellValue(bill.notes ?? '');
      row++;
    }

    // Format columns
    for (var i = 0; i < headers.length; i++) {
      sheet.setColumnWidth(i, 15);
    }
  }

  static void _addSummaryRow(Sheet sheet, int row, String label, String value) {
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
        .value = TextCellValue(label);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
        .value = TextCellValue(value);
  }
}
