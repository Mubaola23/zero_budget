import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:zero_budget/src/controller/expense_view_controller.dart';
import 'package:zero_budget/src/view/add_expense_view.dart';
import 'package:zero_budget/src/view/components.dart/expense_card.dart';
import 'package:zero_budget/src/view/components.dart/expense_chart.dart';
import 'package:zero_budget/src/view/components.dart/stats_card.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseNotifier = ref.watch(expenseProvider.notifier);
    final expenses = ref.watch(expenseProvider);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'ZeroBudget',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Track your expenses without giving up your data',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: 16, color: Colors.green),
                  Text(
                    ' End-to-end encrypted • Privacy-first • Your data stays yours',
                    style: TextStyle(fontSize: 10, color: Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      title: 'Total Spent',
                      value: NumberFormat.currency(
                        symbol: '\$',
                        decimalDigits: 1,
                      ).format(expenseNotifier.totalSpent),
                      icon: Icons.trending_up,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatsCard(
                      title: 'Average Spend',
                      value: NumberFormat.currency(
                        symbol: '\$',
                        decimalDigits: 1,
                      ).format(expenseNotifier.averageSpent),
                      icon: Icons.calculate,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatsCard(
                      title: 'Total Entries',
                      value: expenseNotifier.totalEntries.toString(),
                      icon: Icons.receipt,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),

              // Add New Expense Button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddExpenseScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text(
                        'Add New Expense',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Expense Chart
              if (expenses.isNotEmpty) ...[
                const Text(
                  'Expense Breakdown',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ExpenseChart(categoryTotals: expenseNotifier.categoryTotals),
                const SizedBox(height: 24),
              ],

              // Recent Expenses
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Expenses',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all expenses
                    },
                    child: const Text('All Categories'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (expenses.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'No expenses yet. Add your first expense!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              else
                ...expenseNotifier.recentExpenses.map(
                  (expense) => ExpenseCard(
                    expense: expense,
                    onDelete: () => expenseNotifier.removeExpense(expense.id),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
