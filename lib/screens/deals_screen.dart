import 'package:flutter/material.dart';

class DealsScreen extends StatelessWidget {
  const DealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Deals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search), 
            onPressed: () {},
            tooltip: 'Search Deals',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSummarySection(context),
          const SizedBox(height: 24),
          const Text(
            'In Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          _buildDealCard(
            context: context,
            title: 'Website Redesign',
            company: 'TechFlow Inc.',
            amount: '\$15,000',
            status: 'Proposal Review',
            statusColor:Theme.of(context).colorScheme.secondary,
            progress: 0.6,
          ),
          _buildDealCard(
            context: context,
            title: 'Mobile App MVP',
            company: 'Pinnacle Goods',
            amount: '\$45,000',
            status: 'Contract Sent',
            statusColor:Theme.of(context).primaryColor,
            progress: 0.9,
          ),
          const SizedBox(height: 24),
          const Text(
            'Recently Closed',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          _buildDealCard(
            context: context,
            title: 'SEO Audit',
            company: 'Globex Corp',
            amount: '\$3,500',
            status: 'Won',
            statusColor: const Color(0xFF10B981),
            progress: 1.0,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'New Deal',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withAlpha(76), // ~0.3 opacity
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Pipeline',
                style: TextStyle(
                  color: Colors.white.withAlpha(204), // ~0.8 opacity
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '\$60,000',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51), // ~0.2 opacity
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.trending_up,
              color: Colors.white,
              size: 28,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDealCard({
    required BuildContext context,
    required String title,
    required String company,
    required String amount,
    required String status,
    required Color statusColor,
    required double progress,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
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
                        const SizedBox(height: 4),
                        Text(
                          company,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(25), // ~0.1 opacity
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
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
}
