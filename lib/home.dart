import 'package:flutter/material.dart';
import 'package:fluttertest/function.dart';
import 'package:fluttertest/pdf.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;

import 'ad.dart';

class MyStatefulWidget extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final _supplierNameController = TextEditingController();
  final _supplierAddressController = TextEditingController();
  final _taxNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _dateController = TextEditingController();
  final _numberController = TextEditingController();
  final _TitleController = TextEditingController();
  final _taxNumberCustomerController = TextEditingController();
  final _VATController = TextEditingController();
  final _AdditionalInformationController = TextEditingController();
  final _BankController = TextEditingController();
  final _IBANController = TextEditingController();
  final _BICController = TextEditingController();
  final _CurrencyController = TextEditingController();
  bool _isButtonClicked = false;
  bool _isVATDirty = false;

  List<InvoiceItem> itemDetailsList = [];

  @override
  void initState() {
    super.initState();
    _VATController.addListener(_handleVATChange);
  }

  @override
  void dispose() {
    _VATController.removeListener(_handleVATChange);
    _VATController.dispose();
    super.dispose();
  }

  void _handleVATChange() {
    setState(() {
      _isVATDirty = _VATController.text.isNotEmpty;
    });
  }

  void addItem() {
    setState(() {
      itemDetailsList
          .add(InvoiceItem(description: '', quantity: 0, unitPrice: 0));
    });
  }

  void _generateAndOpenPDF() {
    String supplierName = _supplierNameController.text;
    String supplierAddress = _supplierAddressController.text;
    String taxNumber = _taxNumberController.text;
    String name = _nameController.text;
    String address = _addressController.text;
    String date = _dateController.text;
    String number = _numberController.text;
    String TaxNumberCustomer = _taxNumberCustomerController.text;
    String Title = _TitleController.text;
    String VAT = _VATController.text;
    String AdditionalInformation = _AdditionalInformationController.text;
    String Bank = _BankController.text;
    String IBAN = _IBANController.text;
    String BIC = _BICController.text;
    String Currency = _CurrencyController.text;

    generatePDFAndOpen(
      supplierAddress,
      supplierName,
      taxNumber,
      name,
      address,
      date,
      number,
      Title,
      TaxNumberCustomer,
      VAT,
      AdditionalInformation,
      Bank,
      IBAN,
      BIC,
      Currency,
      itemDetailsList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Generator'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40), // Adjust the padding as needed
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Invoice Details',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: _TitleController,
                            decoration: InputDecoration(
                              labelText: 'Title',
                            ),
                          ),
                          TextField(
                            controller: _dateController,
                            decoration: InputDecoration(
                              labelText: 'Date',
                            ),
                          ),
                          TextField(
                            controller: _numberController,
                            decoration: InputDecoration(
                              labelText: 'Invoice Number',
                            ),
                          ),
                          TextField(
                            controller: _CurrencyController,
                            decoration: InputDecoration(
                              labelText:
                                  'Currency (Enter currency symbol here, find symbols in the FAQ)',
                            ),
                          ),
                          TextField(
                            controller: _supplierNameController,
                            decoration: InputDecoration(
                              labelText: 'Supplier Name',
                            ),
                          ),
                          TextField(
                            controller: _supplierAddressController,
                            decoration: InputDecoration(
                              labelText: 'Supplier Address',
                            ),
                          ),
                          TextField(
                            controller: _taxNumberController,
                            decoration: InputDecoration(
                              labelText: 'Supplier Tax Number',
                            ),
                          ),
                          TextField(
                            controller: _VATController,
                            decoration: InputDecoration(
                              labelText: 'VAT Amount (in %)',
                              enabledBorder: (_isButtonClicked && !_isVATDirty)
                                  ? UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width:
                                            2.0, // Adjust the thickness as needed
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Customer Name',
                            ),
                          ),
                          TextField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: 'Customer Address',
                            ),
                          ),
                          TextField(
                            controller: _taxNumberCustomerController,
                            decoration: InputDecoration(
                              labelText: 'Customer Tax Number',
                            ),
                          ),
                          TextField(
                            controller: _BankController,
                            decoration: InputDecoration(
                              labelText: 'Bank',
                            ),
                          ),
                          TextField(
                            controller: _IBANController,
                            decoration: InputDecoration(
                              labelText: 'IBAN',
                            ),
                          ),
                          TextField(
                            controller: _BICController,
                            decoration: InputDecoration(
                              labelText: 'BIC',
                            ),
                          ),
                          TextField(
                            controller: _AdditionalInformationController,
                            decoration: InputDecoration(
                              labelText: 'Additional Information',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Add Invoice Items',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children:
                                  itemDetailsList.asMap().entries.map((entry) {
                                final index = entry.key;
                                final itemDetails = entry.value;

                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Description',
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              itemDetailsList[index]
                                                  .description = value;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Quantity',
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              itemDetailsList[index].quantity =
                                                  int.tryParse(value) ?? 0;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Net Price',
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              itemDetailsList[index].unitPrice =
                                                  double.tryParse(value) ?? 0.0;
                                            });
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        color: Colors.red,
                                        iconSize: 24,
                                        onPressed: () {
                                          setState(() {
                                            itemDetailsList.removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 250,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 24.0,
            right: 16.0,
            child: Container(
              width: 100, // Set the desired width
              child: Column(
                children: [
                  FloatingActionButton(
                    child: Icon(Icons.open_in_new),
                    onPressed: _isVATDirty
                        ? () async {
                            await showDialog(
                              context: context,
                              builder: (context) =>
                                  AdDialog(onNext: _generateAndOpenPDF),
                            );
                          }
                        : () {
                            setState(() {
                              _isButtonClicked = true;
                            });
                          },
                  ),
                  SizedBox(height: 8),
                  Text('Generate PDF',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 116.0,
            right: 16.0,
            child: Container(
              width: 100, // Set the desired width
              child: Column(
                children: [
                  FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: addItem,
                  ),
                  SizedBox(height: 8),
                  Text('Add Item',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
