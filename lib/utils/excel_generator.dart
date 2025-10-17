// import 'dart:io';
// import 'package:excel/excel.dart';
// import 'package:file_picker/file_picker.dart';
// import '../models/sales_bill.dart';
// import '../models/purchase_bill.dart';
// import '../utils/constants.dart';

// class ExcelGenerator {
//   // Generate Sales Report Excel
//   static Future<void> generateSalesReportExcel(
//     List<SalesBill> bills,
//     DateTime startDate,
//     DateTime endDate,
//   ) async {
//     try {
//       var excel = Excel.createExcel();
//       var sheet = excel['Sales Report'];

//       // Remove default sheet
//       excel.delete('Sheet1');

//       // Title
//       sheet.merge(
//         CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
//         CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0),
//       );
//       var titleCell =
//           sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
//       titleCell.value = TextCellValue('SALES REPORT');

//       // Date Range
//       sheet.merge(
//         CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1),
//         CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 1),
//       );
//       var dateCell =
//           sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1));
//       dateCell.value = TextCellValue(
//           'Period: ${formatDate(startDate)} to ${formatDate(endDate)}');

//       // Headers
//       List<String> headers = [
//         'Invoice No',
//         'Date',
//         'Customer',
//         'Items',
//         'Subtotal',
//         'GST',
//         'Total',
//       ];

//       for (int i = 0; i < headers.length; i++) {
//         var cell =
//             sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 3));
//         cell.value = TextCellValue(headers[i]);
//       }

//       // Data
//       int rowIndex = 4;
//       double totalSales = 0;
//       double totalGst = 0;

//       for (var bill in bills) {
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
//             .value = TextCellValue(bill.id);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
//             .value = TextCellValue(formatDate(bill.billDate));
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
//             .value = TextCellValue(bill.customerName);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
//             .value = IntCellValue(bill.items.length);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
//             .value = DoubleCellValue(bill.subtotal);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
//             .value = DoubleCellValue(bill.totalGst);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
//             .value = DoubleCellValue(bill.grandTotal);

//         totalSales += bill.grandTotal;
//         totalGst += bill.totalGst;
//         rowIndex++;
//       }

//       // Summary
//       rowIndex += 1;
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
//           .value = TextCellValue('Total:');
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
//           .value = DoubleCellValue(totalSales);

//       // Column widths
//       sheet.setColWidth(0, 20);
//       sheet.setColWidth(1, 12);
//       sheet.setColWidth(2, 25);
//       sheet.setColWidth(3, 8);
//       sheet.setColWidth(4, 12);
//       sheet.setColWidth(5, 12);
//       sheet.setColWidth(6, 12);

//       // Save file
//       await _saveExcelFile(
//           excel, 'Sales_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx');
//     } catch (e) {
//       print('Error generating sales report: $e');
//       rethrow;
//     }
//   }

//   // Generate Purchase Report Excel
//   static Future<void> generatePurchaseReportExcel(
//     List<PurchaseBill> bills,
//     DateTime startDate,
//     DateTime endDate,
//   ) async {
//     try {
//       var excel = Excel.createExcel();
//       var sheet = excel['Purchase Report'];

//       // Remove default sheet
//       excel.delete('Sheet1');

//       // Title
//       sheet.merge(
//         CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
//         CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0),
//       );
//       var titleCell =
//           sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
//       titleCell.value = TextCellValue('PURCHASE REPORT');

//       // Date Range
//       sheet.merge(
//         CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1),
//         CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 1),
//       );
//       var dateCell =
//           sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1));
//       dateCell.value = TextCellValue(
//           'Period: ${formatDate(startDate)} to ${formatDate(endDate)}');

//       // Headers
//       List<String> headers = [
//         'PO No',
//         'Date',
//         'Supplier',
//         'Bill No',
//         'Items',
//         'Subtotal',
//         'GST',
//         'Total',
//       ];

//       for (int i = 0; i < headers.length; i++) {
//         var cell =
//             sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 3));
//         cell.value = TextCellValue(headers[i]);
//       }

//       // Data
//       int rowIndex = 4;
//       double totalPurchases = 0;
//       double totalGst = 0;

//       for (var bill in bills) {
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
//             .value = TextCellValue(bill.id);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
//             .value = TextCellValue(formatDate(bill.billDate));
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
//             .value = TextCellValue(bill.supplierName);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
//             .value = TextCellValue(bill.billNumber ?? '-');
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
//             .value = IntCellValue(bill.items.length);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
//             .value = DoubleCellValue(bill.subtotal);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
//             .value = DoubleCellValue(bill.totalGst);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
//             .value = DoubleCellValue(bill.grandTotal);

//         totalPurchases += bill.grandTotal;
//         totalGst += bill.totalGst;
//         rowIndex++;
//       }

//       // Summary
//       rowIndex += 1;
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
//           .value = TextCellValue('Total:');
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
//           .value = DoubleCellValue(totalPurchases);

//       // Column widths
//       sheet.setColWidth(0, 20);
//       sheet.setColWidth(1, 12);
//       sheet.setColWidth(2, 25);
//       sheet.setColWidth(3, 15);
//       sheet.setColWidth(4, 8);
//       sheet.setColWidth(5, 12);
//       sheet.setColWidth(6, 12);
//       sheet.setColWidth(7, 12);

//       await _saveExcelFile(excel,
//           'Purchase_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx');
//     } catch (e) {
//       print('Error generating purchase report: $e');
//       rethrow;
//     }
//   }

//   // Generate Combined Report Excel
//   static Future<void> generateCombinedReportExcel({
//     required List<SalesBill> salesBills,
//     required List<PurchaseBill> purchaseBills,
//     required DateTime startDate,
//     required DateTime endDate,
//   }) async {
//     try {
//       var excel = Excel.createExcel();

//       // Remove default sheet
//       excel.delete('Sheet1');

//       // Summary Sheet
//       var summarySheet = excel['Summary'];
//       _createSummarySheet(
//           summarySheet, salesBills, purchaseBills, startDate, endDate);

//       // Sales Sheet
//       var salesSheet = excel['Sales'];
//       _createSalesSheet(salesSheet, salesBills);

//       // Purchase Sheet
//       var purchaseSheet = excel['Purchases'];
//       _createPurchaseSheet(purchaseSheet, purchaseBills);

//       await _saveExcelFile(excel,
//           'Complete_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx');
//     } catch (e) {
//       print('Error generating combined report: $e');
//       rethrow;
//     }
//   }

//   // Create Summary Sheet
//   static void _createSummarySheet(
//     Sheet sheet,
//     List<SalesBill> salesBills,
//     List<PurchaseBill> purchaseBills,
//     DateTime startDate,
//     DateTime endDate,
//   ) {
//     // Calculate totals
//     double totalSales =
//         salesBills.fold(0, (sum, bill) => sum + bill.grandTotal);
//     double totalPurchases =
//         purchaseBills.fold(0, (sum, bill) => sum + bill.grandTotal);
//     double salesGst = salesBills.fold(0, (sum, bill) => sum + bill.totalGst);
//     double purchaseGst =
//         purchaseBills.fold(0, (sum, bill) => sum + bill.totalGst);
//     double profit = totalSales - totalPurchases;

//     // Title
//     sheet.merge(
//       CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
//       CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0),
//     );
//     var titleCell =
//         sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
//     titleCell.value = TextCellValue('BUSINESS SUMMARY');

//     // Period
//     sheet.merge(
//       CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1),
//       CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1),
//     );
//     var periodCell =
//         sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1));
//     periodCell.value = TextCellValue(
//         'Period: ${formatDate(startDate)} to ${formatDate(endDate)}');

//     // Data
//     int row = 3;
//     List<Map<String, dynamic>> data = [
//       {'label': 'Total Sales', 'value': totalSales},
//       {'label': 'Total Purchases', 'value': totalPurchases},
//       {'label': 'Profit/Loss', 'value': profit},
//       {'label': 'Sales GST', 'value': salesGst},
//       {'label': 'Purchase GST', 'value': purchaseGst},
//       {'label': 'Total GST', 'value': salesGst + purchaseGst},
//       {'label': 'Sales Bills Count', 'value': salesBills.length.toDouble()},
//       {
//         'label': 'Purchase Bills Count',
//         'value': purchaseBills.length.toDouble()
//       },
//     ];

//     for (var item in data) {
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
//           .value = TextCellValue(item['label'] as String);
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
//           .value = DoubleCellValue(item['value'] as double);
//       row++;
//     }

//     sheet.setColWidth(0, 25);
//     sheet.setColWidth(1, 20);
//   }

//   // Create Sales Sheet
//   static void _createSalesSheet(Sheet sheet, List<SalesBill> bills) {
//     List<String> headers = ['Invoice', 'Date', 'Customer', 'Items', 'Total'];

//     for (int i = 0; i < headers.length; i++) {
//       var cell =
//           sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
//       cell.value = TextCellValue(headers[i]);
//     }

//     int row = 1;
//     for (var bill in bills) {
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
//           .value = TextCellValue(bill.id);
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
//           .value = TextCellValue(formatDate(bill.billDate));
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
//           .value = TextCellValue(bill.customerName);
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
//           .value = IntCellValue(bill.items.length);
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
//           .value = DoubleCellValue(bill.grandTotal);
//       row++;
//     }

//     for (int i = 0; i < headers.length; i++) {
//       sheet.setColWidth(i, 20);
//     }
//   }

//   // Create Purchase Sheet
//   static void _createPurchaseSheet(Sheet sheet, List<PurchaseBill> bills) {
//     List<String> headers = [
//       'PO No',
//       'Date',
//       'Supplier',
//       'Bill No',
//       'Items',
//       'Total'
//     ];

//     for (int i = 0; i < headers.length; i++) {
//       var cell =
//           sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
//       cell.value = TextCellValue(headers[i]);
//     }

//     int row = 1;
//     for (var bill in bills) {
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
//           .value = TextCellValue(bill.id);
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
//           .value = TextCellValue(formatDate(bill.billDate));
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
//           .value = TextCellValue(bill.supplierName);
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
//           .value = TextCellValue(bill.billNumber ?? '-');
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
//           .value = IntCellValue(bill.items.length);
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
//           .value = DoubleCellValue(bill.grandTotal);
//       row++;
//     }

//     for (int i = 0; i < headers.length; i++) {
//       sheet.setColWidth(i, 20);
//     }
//   }

//   // Save Excel File
//   static Future<void> _saveExcelFile(Excel excel, String fileName) async {
//     try {
//       // Let user choose save location
//       String? outputPath = await FilePicker.platform.saveFile(
//         dialogTitle: 'Save Excel Report',
//         fileName: fileName,
//         type: FileType.custom,
//         allowedExtensions: ['xlsx'],
//       );

//       if (outputPath != null) {
//         // Ensure .xlsx extension
//         if (!outputPath.endsWith('.xlsx')) {
//           outputPath = '$outputPath.xlsx';
//         }

//         // Encode and save
//         var fileBytes = excel.encode();
//         if (fileBytes != null) {
//           File(outputPath)
//             ..createSync(recursive: true)
//             ..writeAsBytesSync(fileBytes);
//         }
//       }
//     } catch (e) {
//       print('Error saving Excel file: $e');
//       rethrow;
//     }
//   }
// }
// import 'dart:io';
// import 'package:excel/excel.dart';
// import 'package:file_picker/file_picker.dart';
// import '../models/sales_bill.dart';
// import '../models/purchase_bill.dart';
// import '../utils/constants.dart';

// class ExcelGenerator {
//   // Generate Sales Report Excel
//   static Future<void> generateSalesReportExcel(
//     List<SalesBill> bills,
//     DateTime startDate,
//     DateTime endDate,
//   ) async {
//     try {
//       var excel = Excel.createExcel();
//       var sheet = excel['Sales Report'];

//       // Remove default sheet
//       excel.delete('Sheet1');

//       // Title
//       sheet.merge(
//         CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
//         CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0),
//       );
//       var titleCell =
//           sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
//       titleCell.value = TextCellValue('SALES REPORT');

//       // Date Range
//       sheet.merge(
//         CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1),
//         CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 1),
//       );
//       var dateCell =
//           sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1));
//       dateCell.value = TextCellValue(
//           'Period: ${formatDate(startDate)} to ${formatDate(endDate)}');

//       // Headers
//       List<String> headers = [
//         'Invoice No',
//         'Date',
//         'Customer',
//         'Items',
//         'Subtotal',
//         'GST',
//         'Total',
//       ];

//       for (int i = 0; i < headers.length; i++) {
//         var cell =
//             sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 3));
//         cell.value = TextCellValue(headers[i]);
//       }

//       // Data
//       int rowIndex = 4;
//       double totalSales = 0;
//       double totalGst = 0;

//       for (var bill in bills) {
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
//             .value = TextCellValue(bill.id);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
//             .value = TextCellValue(formatDate(bill.billDate));
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
//             .value = TextCellValue(bill.customerName);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
//             .value = IntCellValue(bill.items.length);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
//             .value = DoubleCellValue(bill.subtotal);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
//             .value = DoubleCellValue(bill.totalGst);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
//             .value = DoubleCellValue(bill.grandTotal);

//         totalSales += bill.grandTotal;
//         totalGst += bill.totalGst;
//         rowIndex++;
//       }

//       // Summary
//       rowIndex += 1;
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
//           .value = TextCellValue('Total:');
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
//           .value = DoubleCellValue(totalSales);

//       // Save file
//       await _saveExcelFile(
//           excel, 'Sales_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx');
//     } catch (e) {
//       print('Error generating sales report: $e');
//       rethrow;
//     }
//   }

//   // Generate Purchase Report Excel
//   static Future<void> generatePurchaseReportExcel(
//     List<PurchaseBill> bills,
//     DateTime startDate,
//     DateTime endDate,
//   ) async {
//     try {
//       var excel = Excel.createExcel();
//       var sheet = excel['Purchase Report'];

//       // Remove default sheet
//       excel.delete('Sheet1');

//       // Title
//       sheet.merge(
//         CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
//         CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0),
//       );
//       var titleCell =
//           sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
//       titleCell.value = TextCellValue('PURCHASE REPORT');

//       // Date Range
//       sheet.merge(
//         CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1),
//         CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 1),
//       );
//       var dateCell =
//           sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1));
//       dateCell.value = TextCellValue(
//           'Period: ${formatDate(startDate)} to ${formatDate(endDate)}');

//       // Headers
//       List<String> headers = [
//         'PO No',
//         'Date',
//         'Supplier',
//         'Bill No',
//         'Items',
//         'Subtotal',
//         'GST',
//         'Total',
//       ];

//       for (int i = 0; i < headers.length; i++) {
//         var cell =
//             sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 3));
//         cell.value = TextCellValue(headers[i]);
//       }

//       // Data
//       int rowIndex = 4;
//       double totalPurchases = 0;
//       double totalGst = 0;

//       for (var bill in bills) {
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
//             .value = TextCellValue(bill.id);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
//             .value = TextCellValue(formatDate(bill.billDate));
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
//             .value = TextCellValue(bill.supplierName);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
//             .value = TextCellValue(bill.billNumber ?? '-');
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
//             .value = IntCellValue(bill.items.length);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
//             .value = DoubleCellValue(bill.subtotal);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
//             .value = DoubleCellValue(bill.totalGst);
//         sheet
//             .cell(
//                 CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
//             .value = DoubleCellValue(bill.grandTotal);

//         totalPurchases += bill.grandTotal;
//         totalGst += bill.totalGst;
//         rowIndex++;
//       }

//       // Summary
//       rowIndex += 1;
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
//           .value = TextCellValue('Total:');
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
//           .value = DoubleCellValue(totalPurchases);

//       await _saveExcelFile(excel,
//           'Purchase_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx');
//     } catch (e) {
//       print('Error generating purchase report: $e');
//       rethrow;
//     }
//   }

//   // Generate Combined Report Excel
//   static Future<void> generateCombinedReportExcel({
//     required List<SalesBill> salesBills,
//     required List<PurchaseBill> purchaseBills,
//     required DateTime startDate,
//     required DateTime endDate,
//   }) async {
//     try {
//       var excel = Excel.createExcel();

//       // Remove default sheet
//       excel.delete('Sheet1');

//       // Summary Sheet
//       var summarySheet = excel['Summary'];
//       _createSummarySheet(
//           summarySheet, salesBills, purchaseBills, startDate, endDate);

//       // Sales Sheet
//       var salesSheet = excel['Sales'];
//       _createSalesSheet(salesSheet, salesBills);

//       // Purchase Sheet
//       var purchaseSheet = excel['Purchases'];
//       _createPurchaseSheet(purchaseSheet, purchaseBills);

//       await _saveExcelFile(excel,
//           'Complete_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx');
//     } catch (e) {
//       print('Error generating combined report: $e');
//       rethrow;
//     }
//   }

//   // Create Summary Sheet
//   static void _createSummarySheet(
//     Sheet sheet,
//     List<SalesBill> salesBills,
//     List<PurchaseBill> purchaseBills,
//     DateTime startDate,
//     DateTime endDate,
//   ) {
//     // Calculate totals
//     double totalSales =
//         salesBills.fold(0, (sum, bill) => sum + bill.grandTotal);
//     double totalPurchases =
//         purchaseBills.fold(0, (sum, bill) => sum + bill.grandTotal);
//     double salesGst = salesBills.fold(0, (sum, bill) => sum + bill.totalGst);
//     double purchaseGst =
//         purchaseBills.fold(0, (sum, bill) => sum + bill.totalGst);
//     double profit = totalSales - totalPurchases;

//     // Title
//     sheet.merge(
//       CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
//       CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0),
//     );
//     var titleCell =
//         sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
//     titleCell.value = TextCellValue('BUSINESS SUMMARY');

//     // Period
//     sheet.merge(
//       CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1),
//       CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1),
//     );
//     var periodCell =
//         sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1));
//     periodCell.value = TextCellValue(
//         'Period: ${formatDate(startDate)} to ${formatDate(endDate)}');

//     // Data
//     int row = 3;
//     List<Map<String, dynamic>> data = [
//       {'label': 'Total Sales', 'value': totalSales},
//       {'label': 'Total Purchases', 'value': totalPurchases},
//       {'label': 'Profit/Loss', 'value': profit},
//       {'label': 'Sales GST', 'value': salesGst},
//       {'label': 'Purchase GST', 'value': purchaseGst},
//       {'label': 'Total GST', 'value': salesGst + purchaseGst},
//       {'label': 'Sales Bills Count', 'value': salesBills.length.toDouble()},
//       {
//         'label': 'Purchase Bills Count',
//         'value': purchaseBills.length.toDouble()
//       },
//     ];

//     for (var item in data) {
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
//           .value = TextCellValue(item['label'] as String);
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
//           .value = DoubleCellValue(item['value'] as double);
//       row++;
//     }
//   }

//   // Create Sales Sheet
//   static void _createSalesSheet(Sheet sheet, List<SalesBill> bills) {
//     List<String> headers = ['Invoice', 'Date', 'Customer', 'Items', 'Total'];

//     for (int i = 0; i < headers.length; i++) {
//       var cell =
//           sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
//       cell.value = TextCellValue(headers[i]);
//     }

//     int row = 1;
//     for (var bill in bills) {
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
//           .value = TextCellValue(bill.id);
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
//           .value = TextCellValue(formatDate(bill.billDate));
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
//           .value = TextCellValue(bill.customerName);
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
//           .value = IntCellValue(bill.items.length);
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
//           .value = DoubleCellValue(bill.grandTotal);
//       row++;
//     }
//   }

//   // Create Purchase Sheet
//   static void _createPurchaseSheet(Sheet sheet, List<PurchaseBill> bills) {
//     List<String> headers = [
//       'PO No',
//       'Date',
//       'Supplier',
//       'Bill No',
//       'Items',
//       'Total'
//     ];

//     for (int i = 0; i < headers.length; i++) {
//       var cell =
//           sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
//       cell.value = TextCellValue(headers[i]);
//     }

//     int row = 1;
//     for (var bill in bills) {
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
//           .value = TextCellValue(bill.id);
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
//           .value = TextCellValue(formatDate(bill.billDate));
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
//           .value = TextCellValue(bill.supplierName);
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
//           .value = TextCellValue(bill.billNumber ?? '-');
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
//           .value = IntCellValue(bill.items.length);
//       sheet
//           .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
//           .value = DoubleCellValue(bill.grandTotal);
//       row++;
//     }

//     for (int i = 0; i < headers.length; i++) {
//       sheet.setColWidth(i, 20);
//     }
//   }

//   // Save Excel File
//   static Future<void> _saveExcelFile(Excel excel, String fileName) async {
//     try {
//       // Let user choose save location
//       String? outputPath = await FilePicker.platform.saveFile(
//         dialogTitle: 'Save Excel Report',
//         fileName: fileName,
//         type: FileType.custom,
//         allowedExtensions: ['xlsx'],
//       );

//       if (outputPath != null) {
//         // Ensure .xlsx extension
//         if (!outputPath.endsWith('.xlsx')) {
//           outputPath = '$outputPath.xlsx';
//         }

//         // Encode and save
//         var fileBytes = excel.encode();
//         if (fileBytes != null) {
//           File(outputPath)
//             ..createSync(recursive: true)
//             ..writeAsBytesSync(fileBytes);
//         }
//       }
//     } catch (e) {
//       print('Error saving Excel file: $e');
//       rethrow;
//     }
//   }
// }
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import '../models/sales_bill.dart';
import '../models/purchase_bill.dart';
import '../utils/constants.dart';

class ExcelGenerator {
  // Generate Sales Report Excel
  static Future<void> generateSalesReportExcel(
    List<SalesBill> bills,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      var excel = Excel.createExcel();
      var sheet = excel['Sales Report'];

      // Remove default sheet
      excel.delete('Sheet1');

      // Title
      sheet.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
        CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0),
      );
      var titleCell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
      titleCell.value = TextCellValue('SALES REPORT');

      // Date Range
      sheet.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1),
        CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 1),
      );
      var dateCell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1));
      dateCell.value = TextCellValue(
          'Period: ${formatDate(startDate)} to ${formatDate(endDate)}');

      // Headers
      List<String> headers = [
        'Invoice No',
        'Date',
        'Customer',
        'Items',
        'Subtotal',
        'GST',
        'Total',
      ];

      for (int i = 0; i < headers.length; i++) {
        var cell =
            sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 3));
        cell.value = TextCellValue(headers[i]);
      }

      // Data
      int rowIndex = 4;
      double totalSales = 0;
      double totalGst = 0;

      for (var bill in bills) {
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
            .value = TextCellValue(bill.id);
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
            .value = TextCellValue(formatDate(bill.billDate));
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
            .value = TextCellValue(bill.customerName);
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
            .value = IntCellValue(bill.items.length);
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
            .value = DoubleCellValue(bill.subtotal);
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
            .value = DoubleCellValue(bill.totalGst);
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
            .value = DoubleCellValue(bill.grandTotal);

        totalSales += bill.grandTotal;
        totalGst += bill.totalGst;
        rowIndex++;
      }

      // Summary
      rowIndex += 1;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
          .value = TextCellValue('Total:');
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
          .value = DoubleCellValue(totalSales);

      // Save file
      await _saveExcelFile(
          excel, 'Sales_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx');
    } catch (e) {
      print('Error generating sales report: $e');
      rethrow;
    }
  }

  // Generate Purchase Report Excel
  static Future<void> generatePurchaseReportExcel(
    List<PurchaseBill> bills,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      var excel = Excel.createExcel();
      var sheet = excel['Purchase Report'];

      // Remove default sheet
      excel.delete('Sheet1');

      // Title
      sheet.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
        CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0),
      );
      var titleCell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
      titleCell.value = TextCellValue('PURCHASE REPORT');

      // Date Range
      sheet.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1),
        CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 1),
      );
      var dateCell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1));
      dateCell.value = TextCellValue(
          'Period: ${formatDate(startDate)} to ${formatDate(endDate)}');

      // Headers
      List<String> headers = [
        'PO No',
        'Date',
        'Supplier',
        'Bill No',
        'Items',
        'Subtotal',
        'GST',
        'Total',
      ];

      for (int i = 0; i < headers.length; i++) {
        var cell =
            sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 3));
        cell.value = TextCellValue(headers[i]);
      }

      // Data
      int rowIndex = 4;
      double totalPurchases = 0;
      double totalGst = 0;

      for (var bill in bills) {
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
            .value = TextCellValue(bill.id);
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
            .value = TextCellValue(formatDate(bill.billDate));
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
            .value = TextCellValue(bill.supplierName);
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
            .value = TextCellValue(bill.billNumber ?? '-');
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
            .value = IntCellValue(bill.items.length);
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
            .value = DoubleCellValue(bill.subtotal);
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
            .value = DoubleCellValue(bill.totalGst);
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
            .value = DoubleCellValue(bill.grandTotal);

        totalPurchases += bill.grandTotal;
        totalGst += bill.totalGst;
        rowIndex++;
      }

      // Summary
      rowIndex += 1;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
          .value = TextCellValue('Total:');
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
          .value = DoubleCellValue(totalPurchases);

      await _saveExcelFile(excel,
          'Purchase_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx');
    } catch (e) {
      print('Error generating purchase report: $e');
      rethrow;
    }
  }

  // Generate Combined Report Excel
  static Future<void> generateCombinedReportExcel({
    required List<SalesBill> salesBills,
    required List<PurchaseBill> purchaseBills,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      var excel = Excel.createExcel();

      // Remove default sheet
      excel.delete('Sheet1');

      // Summary Sheet
      var summarySheet = excel['Summary'];
      _createSummarySheet(
          summarySheet, salesBills, purchaseBills, startDate, endDate);

      // Sales Sheet
      var salesSheet = excel['Sales'];
      _createSalesSheet(salesSheet, salesBills);

      // Purchase Sheet
      var purchaseSheet = excel['Purchases'];
      _createPurchaseSheet(purchaseSheet, purchaseBills);

      await _saveExcelFile(excel,
          'Complete_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx');
    } catch (e) {
      print('Error generating combined report: $e');
      rethrow;
    }
  }

  // Create Summary Sheet
  static void _createSummarySheet(
    Sheet sheet,
    List<SalesBill> salesBills,
    List<PurchaseBill> purchaseBills,
    DateTime startDate,
    DateTime endDate,
  ) {
    // Calculate totals
    double totalSales =
        salesBills.fold(0, (sum, bill) => sum + bill.grandTotal);
    double totalPurchases =
        purchaseBills.fold(0, (sum, bill) => sum + bill.grandTotal);
    double salesGst = salesBills.fold(0, (sum, bill) => sum + bill.totalGst);
    double purchaseGst =
        purchaseBills.fold(0, (sum, bill) => sum + bill.totalGst);
    double profit = totalSales - totalPurchases;

    // Title
    sheet.merge(
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
      CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0),
    );
    var titleCell =
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    titleCell.value = TextCellValue('BUSINESS SUMMARY');

    // Period
    sheet.merge(
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1),
      CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1),
    );
    var periodCell =
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1));
    periodCell.value = TextCellValue(
        'Period: ${formatDate(startDate)} to ${formatDate(endDate)}');

    // Data
    int row = 3;
    List<Map<String, dynamic>> data = [
      {'label': 'Total Sales', 'value': totalSales},
      {'label': 'Total Purchases', 'value': totalPurchases},
      {'label': 'Profit/Loss', 'value': profit},
      {'label': 'Sales GST', 'value': salesGst},
      {'label': 'Purchase GST', 'value': purchaseGst},
      {'label': 'Total GST', 'value': salesGst + purchaseGst},
      {'label': 'Sales Bills Count', 'value': salesBills.length.toDouble()},
      {
        'label': 'Purchase Bills Count',
        'value': purchaseBills.length.toDouble()
      },
    ];

    for (var item in data) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .value = TextCellValue(item['label'] as String);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
          .value = DoubleCellValue(item['value'] as double);
      row++;
    }
  }

  // Create Sales Sheet
  static void _createSalesSheet(Sheet sheet, List<SalesBill> bills) {
    List<String> headers = ['Invoice', 'Date', 'Customer', 'Items', 'Total'];

    for (int i = 0; i < headers.length; i++) {
      var cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
    }

    int row = 1;
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
          .value = IntCellValue(bill.items.length);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
          .value = DoubleCellValue(bill.grandTotal);
      row++;
    }
  }

  // Create Purchase Sheet
  static void _createPurchaseSheet(Sheet sheet, List<PurchaseBill> bills) {
    List<String> headers = [
      'PO No',
      'Date',
      'Supplier',
      'Bill No',
      'Items',
      'Total'
    ];

    for (int i = 0; i < headers.length; i++) {
      var cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
    }

    int row = 1;
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
          .value = TextCellValue(bill.billNumber ?? '-');
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
          .value = IntCellValue(bill.items.length);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
          .value = DoubleCellValue(bill.grandTotal);
      row++;
    }
  }

  // Save Excel File
  static Future<void> _saveExcelFile(Excel excel, String fileName) async {
    try {
      // Let user choose save location
      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Excel Report',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (outputPath != null) {
        // Ensure .xlsx extension
        if (!outputPath.endsWith('.xlsx')) {
          outputPath = '$outputPath.xlsx';
        }

        // Encode and save
        var fileBytes = excel.encode();
        if (fileBytes != null) {
          File(outputPath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(fileBytes);
        }
      }
    } catch (e) {
      print('Error saving Excel file: $e');
      rethrow;
    }
  }
}
