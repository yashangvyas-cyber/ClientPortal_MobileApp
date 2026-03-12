import 'package:flutter/material.dart';
import '../models/organization.dart';
import '../models/deal_data.dart';

class PaymentReceiptScreen extends StatelessWidget {
  final PaymentRecord payment;
  final InvoiceData invoice;
  final Organization organization;

  const PaymentReceiptScreen({
    super.key,
    required this.payment,
    required this.invoice,
    required this.organization,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header bar with drag handle, title, actions
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF0F172A)),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  payment.receiptId,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFF10B981)),
                ),
                child: const Text(
                  'PAID',
                  style: TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.download_outlined, color: Color(0xFF0F172A)),
                onPressed: () {},
              ),
            ],
          ),
        ),

        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Fully Paid banner
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B82F6),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  child: const Center(
                    child: Text(
                      'Fully Paid',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Amount Received block
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Text('Amount Received', style: TextStyle(color: Colors.white, fontSize: 12)),
                      const SizedBox(height: 8),
                      Text(
                        payment.amount,
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Payment details card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment Receipt',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Payment Date', payment.date),
                      const Divider(height: 24, color: Color(0xFFF1F5F9)),
                      _buildDetailRow('Payment Mode', payment.mode),
                      const Divider(height: 24, color: Color(0xFFF1F5F9)),
                      _buildDetailRow('Amount in Words', 'Fifty Thousand United States Dollar Only'),
                      const Divider(height: 24, color: Color(0xFFF1F5F9)),
                      _buildDetailRow('Invoice Number', invoice.invoiceId),
                      const Divider(height: 24, color: Color(0xFFF1F5F9)),
                      _buildDetailRow('Invoice Amount', invoice.amount),
                      const Divider(height: 24, color: Color(0xFFF1F5F9)),
                      _buildDetailRow('Invoice Date', invoice.createdDate),
                      const Divider(height: 24, color: Color(0xFFF1F5F9)),
                      _buildDetailRow('Due Date', invoice.dueDate),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // From / Billed To card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('From', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      const SizedBox(height: 4),
                      const Text('Yopmails', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                      const SizedBox(height: 2),
                      const Text(
                        'Virsavarkar Road, Andaman, Gujarat, India',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      const SizedBox(height: 16),
                      const Text('Billed To', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      const SizedBox(height: 4),
                      const Text('Apex Consulting Group', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                      const SizedBox(height: 2),
                      const Text(
                        'Chicago, Illinois, United States',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
          ),
        ),
      ],
    );
  }
}
