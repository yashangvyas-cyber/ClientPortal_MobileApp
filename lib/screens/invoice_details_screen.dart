import 'package:flutter/material.dart';
import '../models/organization.dart';
import '../models/deal_data.dart';
import 'payment_receipt_screen.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  final InvoiceData invoice;
  final Organization organization;
  
  const InvoiceDetailsScreen({
    super.key,
    required this.invoice,
    required this.organization,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPaid = invoice.status.toLowerCase().contains('paid');

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Slightly darker background for cards to pop
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Invoice Details',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined, color: Color(0xFF4F46E5)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Amount Area
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Amount ${isPaid ? "Received" : "Due"}',
                    style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    invoice.amount,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isPaid ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      invoice.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isPaid ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Content Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSummaryCard(),
                  const SizedBox(height: 16),
                  _buildPartiesCard(),
                  const SizedBox(height: 16),
                  _buildTotalAmountCard(),
                  const SizedBox(height: 16),
                   if (isPaid && invoice.payments.isNotEmpty) _buildRecordedPaymentsCard(context),
                   const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return _buildCard(
      title: 'Invoice Summary',
      child: Column(
        children: [
          _buildRow('Invoice Number', invoice.invoiceId),
          const Divider(height: 24, color: Color(0xFFF1F5F9)),
          _buildRow('Issue Date', invoice.createdDate),
          const Divider(height: 24, color: Color(0xFFF1F5F9)),
          _buildRow('Due Date', invoice.dueDate),
        ],
      ),
    );
  }

  Widget _buildPartiesCard() {
    return _buildCard(
      title: 'Parties',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('From:', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              const SizedBox(height: 4),
              Text(
                organization.name,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 4),
              const Text(
                'Virsavarkar Road, Andaman\nGujarat, India',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 20),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Billed To:', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              SizedBox(height: 4),
              Text(
                'Apex Consulting Group',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              SizedBox(height: 4),
              Text(
                'James Mitchell\nGandhi Nagar, Gujarat',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalAmountCard() {
    return _buildCard(
      title: 'Total Amount',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Amount', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
          Text(
            invoice.amount,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordedPaymentsCard(BuildContext context) {
    return _buildCard(
      title: 'Recorded Payments',
      child: Column(
        children: invoice.payments.asMap().entries.map((entry) {
          int idx = entry.key;
          PaymentRecord payment = entry.value;
          return Column(
            children: [
              if (idx > 0) const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    payment.receiptId,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4F46E5), // Indigo color for ID like the screenshot
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFF10B981)),
                        ),
                        child: const Text('PAID', style: TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (ctx) => DraggableScrollableSheet(
                              initialChildSize: 0.92,
                              maxChildSize: 0.95,
                              minChildSize: 0.5,
                              builder: (_, controller) => Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                child: PaymentReceiptScreen(
                                  payment: payment,
                                  invoice: invoice,
                                  organization: organization,
                                ),
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFCBD5E1)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.remove_red_eye_outlined, size: 16, color: Color(0xFF64748B)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Particulars', style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                          Text('Amount (USD)', style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Container(height: 1, color: const Color(0xFFE2E8F0)),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Payment', style: TextStyle(fontSize: 14, color: Color(0xFF1E293B))),
                          Text(payment.amount, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                  border: Border(
                    left: BorderSide(color: Color(0xFFE2E8F0)),
                    right: BorderSide(color: Color(0xFFE2E8F0)),
                    bottom: BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Payment Mode', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                          const SizedBox(height: 4),
                          Text(payment.mode, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Payment Date', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                          const SizedBox(height: 4),
                          Text(payment.date, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFooterSignatures() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF3B82F6).withAlpha(100), width: 2),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF3B82F6).withAlpha(150), width: 1),
                  ),
                  child: const Center(
                    child: Text(
                      'RECEIVED',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Color(0xFF3B82F6)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text('Verified', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            ],
          ),
          Column(
            children: [
              const Icon(Icons.gesture, size: 40, color: Color(0xFF0F172A)),
              const SizedBox(height: 8),
              Container(width: 80, height: 1, color: const Color(0xFFCBD5E1)),
              const SizedBox(height: 4),
              const Text('M. Doshi', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }
}
