import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/sales_bill.dart';
import '../models/purchase_bill.dart';
import '../models/company_settings.dart';
import 'constants.dart';

class PDFGenerator {
  // Generate Sales Bill PDF
  static Future<void> generateSalesBillPDF(
    SalesBill bill,
    CompanySettings companySettings,
  ) async {
    final font = await _loadFont();
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Theme(
            data: pw.ThemeData.withFont(
              base: font,
              bold: font,
              italic: font,
              boldItalic: font,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(companySettings, isSalesInvoice: true, font: font),
                pw.SizedBox(height: 20),
                pw.Divider(),
                pw.SizedBox(height: 20),

                // Invoice Info
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Bill To:',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            font: font,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          bill.customerName,
                          style: pw.TextStyle(fontSize: 14, font: font),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Invoice: ${bill.id}',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            font: font,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Date: ${formatDate(bill.billDate)}',
                          style: pw.TextStyle(fontSize: 12, font: font),
                        ),
                      ],
                    ),
                  ],
                ),

                pw.SizedBox(height: 30),

                // Items Table
                _buildItemsTable(bill.items, font: font),

                pw.SizedBox(height: 20),

                // Summary
                _buildSummary(bill.subtotal, bill.totalGst, bill.grandTotal,
                    font: font),

                if (bill.notes != null) ...[
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Notes: ${bill.notes}',
                    style: pw.TextStyle(fontSize: 10, font: font),
                  ),
                ],

                pw.Spacer(),

                // Footer
                _buildFooter(font: font),
              ],
            ),
          );
        },
      ),
    );

    // Print or Save
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  // Generate Purchase Bill PDF
  static Future<void> generatePurchaseBillPDF(
    PurchaseBill bill,
    CompanySettings companySettings,
  ) async {
    final pdf = pw.Document();

    final font = await _loadFont();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(companySettings, isSalesInvoice: false, font: font),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 20),

              // Purchase Info
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Supplier:',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        bill.supplierName,
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'PO: ${bill.id}',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      if (bill.billNumber != null)
                        pw.Text(
                          'Bill No: ${bill.billNumber}',
                          style: const pw.TextStyle(fontSize: 11),
                        ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Date: ${formatDate(bill.billDate)}',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 30),

              // Items Table
              _buildItemsTable(bill.items, font: font),

              pw.SizedBox(height: 20),

              // Summary
              _buildSummary(bill.subtotal, bill.totalGst, bill.grandTotal,
                  font: font),

              if (bill.notes != null) ...[
                pw.SizedBox(height: 20),
                pw.Text(
                  'Notes: ${bill.notes}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],

              pw.Spacer(),

              // Footer
              _buildFooter(font: font),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  // Generate Report PDF
  static Future<void> generateReportPDF({
    required DateTime startDate,
    required DateTime endDate,
    required double totalSales,
    required double totalPurchases,
    required double totalGst,
    required int salesCount,
    required int purchaseCount,
    required CompanySettings companySettings,
  }) async {
    final pdf = pw.Document();

    final font = await _loadFont();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(companySettings, font: font),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 20),

              // Report Title
              pw.Center(
                child: pw.Text(
                  'BUSINESS REPORT',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  'Period: ${formatDate(startDate)} to ${formatDate(endDate)}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ),

              pw.SizedBox(height: 30),

              // Summary Table
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                children: [
                  _buildReportRow('Description', 'Amount', isHeader: true),
                  _buildReportRow('Total Sales', formatCurrency(totalSales)),
                  _buildReportRow(
                      'Total Purchases', formatCurrency(totalPurchases)),
                  _buildReportRow(
                    'Profit',
                    formatCurrency(totalSales - totalPurchases),
                  ),
                  _buildReportRow('Total GST', formatCurrency(totalGst)),
                  _buildReportRow('Sales Bills', salesCount.toString()),
                  _buildReportRow('Purchase Bills', purchaseCount.toString()),
                ],
              ),

              pw.Spacer(),

              _buildFooter(font: font),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  // Build Header
  static pw.Widget _buildHeader(CompanySettings settings,
      {bool? isSalesInvoice, required pw.Font font}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  settings.companyName.isEmpty
                      ? 'Company Name'
                      : settings.companyName,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.indigo,
                  ),
                ),
                pw.SizedBox(height: 4),
                if (settings.address.isNotEmpty)
                  pw.Text(settings.address,
                      style: const pw.TextStyle(fontSize: 10)),
                if (settings.city.isNotEmpty || settings.state.isNotEmpty)
                  pw.Text(
                    '${settings.city}${settings.city.isNotEmpty && settings.state.isNotEmpty ? ', ' : ''}${settings.state}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                if (settings.phone.isNotEmpty)
                  pw.Text('Ph: ${settings.phone}',
                      style: const pw.TextStyle(fontSize: 10)),
                if (settings.email.isNotEmpty)
                  pw.Text('Email: ${settings.email}',
                      style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  isSalesInvoice == null
                      ? ''
                      : (isSalesInvoice ? 'SALES INVOICE' : 'PURCHASE ORDER'),
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                if (settings.gstin.isNotEmpty) ...[
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'GSTIN: ${settings.gstin}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Build Items Table
  static pw.Widget _buildItemsTable(List items, {required pw.Font font}) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildTableCell('Product', isHeader: true, font: font),
            _buildTableCell('HSN', isHeader: true, font: font),
            _buildTableCell('Qty', isHeader: true, font: font),
            _buildTableCell('Rate', isHeader: true, font: font),
            _buildTableCell('GST%', isHeader: true, font: font),
            _buildTableCell('Amount', isHeader: true, font: font),
          ],
        ),
        // Items
        ...items.map((item) {
          return pw.TableRow(
            children: [
              _buildTableCell(item.productName, font: font),
              _buildTableCell(item.hsnCode, font: font),
              _buildTableCell(item.quantity.toString(), font: font),
              _buildTableCell(formatCurrency(item.rate), font: font),
              _buildTableCell('${item.gstPercent}%', font: font),
              _buildTableCell(formatCurrency(item.total), font: font),
            ],
          );
        }).toList(),
      ],
    );
  }

  // Build Table Cell
  static pw.Widget _buildTableCell(String text,
      {bool isHeader = false, required pw.Font font}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 11 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          font: font,
        ),
      ),
    );
  }

  // Build Summary
  static pw.Widget _buildSummary(double subtotal, double gst, double total,
      {required pw.Font font}) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        width: 250,
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        ),
        child: pw.Column(
          children: [
            _buildSummaryRow('Subtotal:', formatCurrency(subtotal), font: font),
            pw.SizedBox(height: 8),
            _buildSummaryRow('GST:', formatCurrency(gst), font: font),
            pw.Divider(),
            _buildSummaryRow(
              'Grand Total:',
              formatCurrency(total),
              isBold: true,
              font: font,
            ),
          ],
        ),
      ),
    );
  }

  // Build Summary Row
  static pw.Widget _buildSummaryRow(String label, String value,
      {bool isBold = false, required pw.Font font}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: isBold ? 12 : 10,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            font: font,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: isBold ? 12 : 10,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            font: font,
          ),
        ),
      ],
    );
  }

  // Build Report Row
  static pw.TableRow _buildReportRow(String label, String value,
      {bool isHeader = false}) {
    return pw.TableRow(
      decoration:
          isHeader ? const pw.BoxDecoration(color: PdfColors.grey200) : null,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
            textAlign: pw.TextAlign.right,
          ),
        ),
      ],
    );
  }

  // Build Footer
  static pw.Widget _buildFooter({required pw.Font font}) {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text(
          'Generated by BizEase - Business Management System',
          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey, font: font),
        ),
        pw.Text(
          'Thank you for your business!',
          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey, font: font),
        ),
      ],
    );
  }

  // Load NotoSans Font
  static Future<pw.Font> _loadFont() async {
    final fontData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
    return pw.Font.ttf(fontData);
  }
}
