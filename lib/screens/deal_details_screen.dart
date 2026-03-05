import 'package:flutter/material.dart';
import '../models/organization.dart';
import '../models/deal_data.dart';
import 'invoice_details_screen.dart';

class DealDetailsScreen extends StatefulWidget {
  final Organization organization;
  final BusinessUnit currentUnit;
  final String dealId;
  final String dealTitle;

  const DealDetailsScreen({
    super.key,
    required this.organization,
    required this.currentUnit,
    required this.dealId,
    required this.dealTitle,
  });

  @override
  State<DealDetailsScreen> createState() => _DealDetailsScreenState();
}

class _DealDetailsScreenState extends State<DealDetailsScreen> {
  late DealData _dealData;
  int _expandedSection = -1;

  @override
  void initState() {
    super.initState();
    _dealData = _getDealData(widget.dealId);
  }

  DealData _getDealData(String dealId) {
    final dealMap = {
      '1': DealData(
        dealType: 'Hourly',
        closingDate: '15-Apr-2026',
        projectName: 'IT Support & Development – Apex Consulting Group',
        projectStatus: 'In Progress',
        proposals: [
          ProposalData(
            title: 'Proposal #1 - Initial Quote',
            status: 'Accepted',
          ),
          ProposalData(title: 'Proposal #2 - Updated Scope', status: 'Pending'),
        ],
        invoices: [
          InvoiceData(
            invoiceId: 'INV-001',
            title: 'Monthly Support Services - March 2026',
            createdDate: '15-Mar-2026',
            dueDate: '31-Mar-2026',
            status: 'Pending',
            amount: '\$5,000',
          ),
        ],
      ),
      '2': DealData(
        dealType: 'Hire Base',
        closingDate: '31-Mar-2026',
        projectName: 'IT Staff Augmentation – Apex Consulting Group',
        projectStatus: 'In Progress',
        proposals: [
          ProposalData(title: 'Resource Pool Proposal', status: 'Accepted'),
        ],
        invoices: [
          InvoiceData(
            invoiceId: 'INV-002',
            title: 'Q1 2026 Staffing Services',
            createdDate: '01-Apr-2026',
            dueDate: '15-Apr-2026',
            status: 'Pending',
            amount: '\$25,000',
          ),
        ],
      ),
      '3': DealData(
        dealType: 'Fixed Cost',
        closingDate: '30-May-2026',
        projectName: 'IT Infrastructure Setup – Apex Consulting Group',
        projectStatus: 'Planned',
        proposals: [
          ProposalData(
            title: 'Infrastructure Setup Proposal',
            status: 'Pending',
          ),
        ],
        invoices: [
          InvoiceData(
            invoiceId: 'INV-003',
            title: 'Infrastructure Setup Phase 1',
            createdDate: '27-Feb-2026',
            dueDate: '01-Jun-2026',
            status: 'Paid',
            amount: '\$50,000',
            payments: [
              PaymentRecord(
                receiptId: 'PM-189',
                amount: '\$50,000',
                date: '03-Mar-2026',
                mode: 'Demand Draft (DD)',
              ),
            ],
          ),
        ],
      ),
    };

    return dealMap[dealId] ?? dealMap['1']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Deal Details',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDealHeaderCard(),
              const SizedBox(height: 16),
              _buildDealOwnerSection(),
              const SizedBox(height: 16),
              _buildExpandableSection(
                title: 'Proposals',
                index: 0,
                icon: Icons.description,
                content: _buildProposalsContent(),
              ),
              const SizedBox(height: 12),
              _buildExpandableSection(
                title: 'Projects',
                index: 1,
                icon: Icons.folder,
                content: _buildProjectsContent(),
              ),
              const SizedBox(height: 12),
              _buildExpandableSection(
                title: 'Invoices',
                index: 2,
                icon: Icons.receipt,
                content: _buildInvoicesContent(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDealHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getDealTypeBadgeColor(_dealData.dealType).withAlpha(20),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _dealData.dealType,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _getDealTypeBadgeColor(_dealData.dealType),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.dealTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 16,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 8),
              const Text(
                'Closing Date: ',
                style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
              Text(
                _dealData.closingDate,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getDealTypeBadgeColor(String dealType) {
    switch (dealType.toLowerCase()) {
      case 'fixed cost':
        return Colors.orange;
      case 'hourly':
        return Colors.blue;
      case 'hire base':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  Widget _buildDealOwnerSection() {
    return Container(
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
            'Deal Owner',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFF4F46E5),
                radius: 24,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Super User',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'superuser.staging@yopmail.com',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(20),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Deal Owner',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required int index,
    required IconData icon,
    required Widget content,
  }) {
    final isExpanded = _expandedSection == index;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedSection = isExpanded ? -1 : index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(icon, color: const Color(0xFF4F46E5), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
              ),
              child: content,
            ),
        ],
      ),
    );
  }

  Widget _buildProposalsContent() {
    if (_dealData.proposals.isEmpty) {
      return _buildEmptyState('No Proposals Found.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ..._dealData.proposals.map((proposal) => _buildProposalCard(proposal)),
      ],
    );
  }

  Widget _buildProjectsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _dealData.projectName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  _buildStatusBadge(_dealData.projectStatus, Colors.grey),
                ],
              ),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.description, 'NDA Signed: ', 'No'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInvoicesContent() {
    if (_dealData.invoices.isEmpty) {
      return _buildEmptyState('Invoice not found.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ..._dealData.invoices.map((inv) => _buildInvoiceCard(inv)),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProposalCard(ProposalData proposal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  proposal.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Status: ${proposal.status}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            _buildStatusBadge(proposal.status, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceCard(InvoiceData inv) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InvoiceDetailsScreen(
                invoice: inv,
                organization: widget.organization,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Expanded(
                     child: Text(
                       inv.invoiceId,
                       style: const TextStyle(
                         fontSize: 13,
                         fontWeight: FontWeight.w600,
                         color: Color(0xFF0F172A),
                       ),
                     ),
                   ),
                  _buildStatusBadge(inv.status, inv.status.toLowerCase().contains("paid") ? Colors.green : Colors.red),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                inv.title,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Created: ${inv.createdDate}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Due: ${inv.dueDate}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    inv.amount,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
