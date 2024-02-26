import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;
import 'package:fluttertest/pdf.dart';
import 'package:fluttertest/home.dart';
import 'package:fluttertest/pdf.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

Future<void> generatePDFAndOpen(
    String supplierName,
    String supplierAddress,
    String taxNumber,
    String name,
    String address,
    String date,
    String number,
    String Title,
    String TaxNumberCustomer,
    String VAT,
    String AdditionalInformation,
    String Bank,
    String IBAN,
    String BIC,
    String Currency,
    List<InvoiceItem>? itemDetailsList) async {
  //Final PDF and Invoice
  final pdf = pw.Document();
  final invoice = generateInvoice(
      supplierName: supplierName,
      supplierAddress: supplierAddress,
      taxNumber: taxNumber,
      name: name,
      address: address,
      date: date,
      number: number,
      itemDetailsList: itemDetailsList,
      Title: Title,
      TaxNumberCustomer: TaxNumberCustomer,
      AdditionalInformation: AdditionalInformation,
      Bank: Bank,
      IBAN: IBAN,
      Currency: Currency,
      BIC: BIC);

  // Calculate total amount without VAT
  final totalAmountWithoutVat = invoice.items
      .map((item) => item.quantity * item.unitPrice)
      .reduce((value, element) => value + element);

  // Define VAT percentage
  final vatPercentage = double.parse(VAT.replaceAll(',', '.')) / 100;

  // Calculate VAT amount
  final vatAmount = totalAmountWithoutVat * vatPercentage;

  // Calculate total amount including VAT
  final totalAmount = totalAmountWithoutVat + vatAmount;

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              Title,
              style: pw.TextStyle(fontSize: 24),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Date: ${invoice.info.date.toString()}'),
            pw.Text('Invoice Number: ${invoice.info.number}'),
            pw.SizedBox(height: 20),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Supplier Information',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(invoice.supplier.address),
                    pw.Text(invoice.supplier.name),
                    pw.Text('VAT: ${invoice.supplier.taxNumber}'),
                  ],
                ),
                pw.SizedBox(width: 100),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Customer Information',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(invoice.customer.name),
                    pw.Text(invoice.customer.address),
                    pw.Text('VAT: ${invoice.customer.TaxNumberCustomer}')
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Invoice Items',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Table(
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Text('Description'),
                    pw.Text('Quantity'),
                    pw.Text('Unit Price'),
                    pw.Text('Total Price'),
                  ],
                ),
                pw.TableRow(
                  children: [pw.SizedBox(height: 10)],
                ),
                for (var item in generateInvoice(
                        supplierName: supplierName,
                        supplierAddress: supplierAddress,
                        taxNumber: taxNumber,
                        name: name,
                        address: address,
                        date: date,
                        number: number,
                        itemDetailsList: itemDetailsList,
                        Title: Title)
                    .items)
                  pw.TableRow(
                    children: [
                      pw.Text(item.description),
                      pw.Text(item.quantity.toString()),
                      pw.Text(
                        Currency == "€"
                            ? String.fromCharCode(128) +
                                item.unitPrice.toStringAsFixed(2)
                            : Currency + item.unitPrice.toStringAsFixed(2),
                      ),
                      pw.Text(Currency == "€"
                          ? String.fromCharCode(128) +
                              (item.quantity * item.unitPrice)
                                  .toStringAsFixed(2)
                          : Currency +
                              (item.quantity * item.unitPrice)
                                  .toStringAsFixed(2)),
                    ],
                  ),
                pw.TableRow(
                  children: [pw.SizedBox(height: 20)],
                ),
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Text('Subtotal'),
                    pw.Text(''),
                    pw.Text(''),
                    pw.Text(Currency == "€"
                        ? String.fromCharCode(128) +
                            totalAmountWithoutVat.toStringAsFixed(2)
                        : Currency + totalAmountWithoutVat.toStringAsFixed(2)),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Text(
                        'VAT (${(vatPercentage * 100).toStringAsFixed(2)}%)'),
                    pw.Text(''),
                    pw.Text(''),
                    pw.Text(Currency == "€"
                        ? String.fromCharCode(128) +
                            vatAmount.toStringAsFixed(2)
                        : Currency + vatAmount.toStringAsFixed(2)),
                  ],
                ),
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Text('Total'),
                    pw.Text(''),
                    pw.Text(''),
                    pw.Text(
                      Currency == "€"
                          ? String.fromCharCode(128) +
                              totalAmount.toStringAsFixed(2)
                          : Currency + totalAmount.toStringAsFixed(2),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Additional Information',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Text(AdditionalInformation),
            pw.Expanded(
              child: pw.Container(), // Empty container for expanded space
            ),
            pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  top: pw.BorderSide(
                    color: PdfColors.black,
                    width: 1.0,
                  ),
                ),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(height: 10),
                          pw.Text(
                            invoice.supplier.address,
                            style: pw.TextStyle(fontSize: 8),
                          ),
                          pw.Text(
                            invoice.supplier.name,
                            style: pw.TextStyle(fontSize: 8),
                          ),
                          pw.Text(
                            'VAT: ${invoice.supplier.taxNumber}',
                            style: pw.TextStyle(fontSize: 8),
                          ),
                        ],
                      ),
                      pw.Spacer(),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(height: 10),
                          pw.Text(
                            Bank,
                            style: pw.TextStyle(fontSize: 8),
                          ),
                          pw.Text(
                            IBAN,
                            style: pw.TextStyle(fontSize: 8),
                          ),
                          pw.Text(
                            'BIC: ${BIC}',
                            style: pw.TextStyle(fontSize: 8),
                          ),
                        ],
                      ),
                      pw.Spacer(),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(height: 10),
                          pw.Text(
                            invoice.customer.name,
                            style: pw.TextStyle(fontSize: 8),
                          ),
                          pw.Text(
                            invoice.customer.address,
                            style: pw.TextStyle(fontSize: 8),
                          ),
                          pw.Text(
                            'VAT: ${invoice.customer.TaxNumberCustomer}',
                            style: pw.TextStyle(fontSize: 8),
                          )
                        ],
                      ),
                    ],
                  ),
                  // Footer content
                ],
              ),
            )
          ],
        );
      },
    ),
  );

  final Uint8List pdfBytes = await pdf.save();
  final blob = html.Blob([pdfBytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.window.open(url, '_blank');
  html.Url.revokeObjectUrl(url);
}
