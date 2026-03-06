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
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Background color reflecting web design backdrop
      appBar: AppBar(
        title: Text(
          payment.receiptId,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.fromLTRB(0, 10, 8, 10),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFF10B981)),
            ),
            child: const Text('PAID', style: TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined, color: Color(0xFF0F172A)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ribbon effect (simulated with a banner at top left)
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF3B82F6),
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(8)),
                    ),
                    child: const Text('Fully Paid', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Addresses
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('From:', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          const SizedBox(height: 4),
                          const Text('Yopmails', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                          const SizedBox(height: 4),
                          const Text('Virsavarkar Road, Andaman, Gujarat, India, 457464654646546\nmihirpoojara@yopmail.com', style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Billed To:', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          const SizedBox(height: 4),
                          const Text('Apex Consulting Group Industry', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                          const SizedBox(height: 4),
                          const Text('450 North Michigan Avenue, Suite 800 Country, Chicago, Illinois, United States, 60611\nOrionlx@yahoo.fr.nf', style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                const Center(
                  child: Text('Payment Receipt', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                ),
                const SizedBox(height: 32),

                // Amount block & Details
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                            const Text('Amount Received', style: TextStyle(color: Colors.white, fontSize: 12)),
                            const SizedBox(height: 8),
                            Text(payment.amount, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          _buildDetailRow('Payment Date', payment.date),
                          const Divider(height: 24, color: Color(0xFFF1F5F9)),
                          _buildDetailRow('Payment Mode', payment.mode),
                          const Divider(height: 24, color: Color(0xFFF1F5F9)),
                          _buildDetailRow('Amount Received in words', 'Fifty Thousand United States Dollar Only'), // Hardcoded for this demo
                          const Divider(height: 24, color: Color(0xFFF1F5F9)),
                          _buildDetailRow('Invoice Number', invoice.invoiceId),
                          const Divider(height: 24, color: Color(0xFFF1F5F9)),
                          _buildDetailRow('Invoice amount', invoice.amount),
                          const Divider(height: 24, color: Color(0xFFF1F5F9)),
                          _buildDetailRow('Invoice date', invoice.createdDate),
                          const Divider(height: 24, color: Color(0xFFF1F5F9)),
                          _buildDetailRow('Due date', invoice.dueDate),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        ),
        Expanded(
          flex: 3,
          child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        ),
      ],
    );
  }
}
