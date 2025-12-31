import 'package:flutter/cupertino.dart';

class ExpenseDetailPage extends StatelessWidget {
  const ExpenseDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Expense Details'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount
              Center(
                child: Column(
                  children: const [
                    Text(
                      '₦4,500',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Lauch with friends • Food',
                      style: TextStyle(fontSize: 16, color: Color(0xFF8E8E93)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Info section
              _InfoRow(
                icon: CupertinoIcons.calendar,
                label: 'Date',
                value: '23 Dec 2025, 2:45 PM',
              ),
              _InfoRow(
                icon: CupertinoIcons.creditcard,
                label: 'Payment',
                value: 'Debit Card',
              ),
              _InfoRow(
                icon: CupertinoIcons.folder,
                label: 'Category',
                value: 'Food',
              ),

              const SizedBox(height: 30),

              // Description
              const Text(
                'Note',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Lunch with friends at campus café',
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.systemGrey,
                ),
              ),

              const SizedBox(height: 40),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      color: CupertinoColors.systemGrey5,
                      onPressed: () {},
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          color: CupertinoColors.extraLightBackgroundGray,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CupertinoButton(
                      color: CupertinoColors.systemRed,
                      onPressed: () {},
                      child: const Text('Delete'),
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: CupertinoColors.systemGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
