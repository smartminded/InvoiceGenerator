class Invoice {
  final Supplier supplier;
  final Customer customer;
  final InvoiceInfo info;
  final List<InvoiceItem> items;
  final String Title;

  Invoice(
      {required this.supplier,
      required this.customer,
      required this.info,
      required this.items,
      required this.Title});
}

class Supplier {
  final String name;
  final String address;
  final String taxNumber;

  Supplier(
      {required this.name, required this.address, required this.taxNumber});
}

class Customer {
  final String name;
  final String address;
  final String TaxNumberCustomer;

  Customer(
      {required this.name,
      required this.address,
      required this.TaxNumberCustomer});
}

class InvoiceInfo {
  final String date;
  final String number;
  final String AdditionalInformation;
  final String Bank;
  final String IBAN;
  final String BIC;
  final String Currency;

  InvoiceInfo(
      {required this.date,
      required this.number,
      required this.AdditionalInformation,
      required this.IBAN,
      required this.Bank,
      required this.BIC,
      required this.Currency});
}

class InvoiceItem {
  String description;
  int quantity;
  double unitPrice;

  InvoiceItem(
      {required this.description,
      required this.quantity,
      required this.unitPrice});
}

Invoice generateInvoice(
    {String supplierName = 'ABC Company',
    String supplierAddress = '123 Supplier St, City',
    String taxNumber = '12345-67890',
    String name = 'John Doe',
    String address = '456 Customer St, City',
    String date = 'MM/DD/YYYY',
    String number = 'INV-2023-001',
    String Title = 'Invoice',
    List<InvoiceItem>? itemDetailsList,
    String Bank = 'Beispielbank',
    String IBAN = '123456789',
    String BIC = '123456789',
    String Currency = '€',
    String AdditionalInformation =
        "Es liegen keine zusätzlichen Informationen vor.",
    String TaxNumberCustomer = '123456789'}) {
  final supplier = Supplier(
    name: supplierName,
    address: supplierAddress,
    taxNumber: taxNumber,
  );

  final customer = Customer(
      name: name, address: address, TaxNumberCustomer: TaxNumberCustomer);

  final invoiceInfo = InvoiceInfo(
      date: date,
      number: number,
      AdditionalInformation: AdditionalInformation,
      BIC: BIC,
      IBAN: IBAN,
      Bank: Bank,
      Currency: Currency);

  final items = itemDetailsList ??
      [
        InvoiceItem(
          description: 'Product 1',
          quantity: 2,
          unitPrice: 10.0,
        ),
        InvoiceItem(
          description: 'Product 2',
          quantity: 3,
          unitPrice: 15.0,
        ),
        InvoiceItem(
          description: 'Product 3',
          quantity: 1,
          unitPrice: 8.0,
        ),
      ];

  return Invoice(
    supplier: supplier,
    customer: customer,
    info: invoiceInfo,
    items: items,
    Title: Title,
  );
}

double calculateTotal(Invoice invoice) {
  double total = 0;
  for (var item in invoice.items) {
    total += item.quantity * item.unitPrice;
  }
  return total;
}
