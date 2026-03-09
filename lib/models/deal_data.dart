class ProposalData {
  final String title;
  final String status;
  final String content;

  ProposalData({
    required this.title,
    required this.status,
    this.content = '',
  });
}

class PaymentRecord {
  final String receiptId;
  final String amount;
  final String date;
  final String mode;

  PaymentRecord({
    required this.receiptId,
    required this.amount,
    required this.date,
    required this.mode,
  });
}

class InvoiceData {
  final String invoiceId;
  final String title;
  final String createdDate;
  final String dueDate;

  final String status;
  final String amount;
  final List<PaymentRecord> payments; // Added to handle multiple payments

  InvoiceData({
    required this.invoiceId,
    required this.title,
    required this.createdDate,
    required this.dueDate,
    required this.status,
    required this.amount,
    this.payments = const [], // Default to empty list
  });
}

class DealData {
  final String dealType;
  final String closingDate;
  final String projectName;
  final String projectStatus;
  final List<ProposalData> proposals;
  final List<InvoiceData> invoices;

  DealData({
    required this.dealType,
    required this.closingDate,
    required this.projectName,
    required this.projectStatus,
    required this.proposals,
    required this.invoices,
  });
}
