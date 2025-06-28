import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zero_budget/src/model/expense_model.dart';
import 'package:zero_budget/utils/enums.dart';

class ExpenseNotifier extends StateNotifier<List<Expense>> {
  ExpenseNotifier() : super([]);

  void addExpense(Expense expense) {
    state = [...state, expense];
  }

  void removeExpense(String id) {
    state = state.where((expense) => expense.id != id).toList();
  }

  double get totalSpent {
    return state.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double get averageSpent {
    if (state.isEmpty) return 0.0;
    return totalSpent / state.length;
  }

  int get totalEntries => state.length;

  Map<ExpenseCategory, double> get categoryTotals {
    final Map<ExpenseCategory, double> totals = {};
    for (final expense in state) {
      totals[expense.category] =
          (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }

  List<Expense> get recentExpenses {
    final sorted = [...state];
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(10).toList();
  }
}

final expenseProvider = StateNotifierProvider<ExpenseNotifier, List<Expense>>((
  ref,
) {
  return ExpenseNotifier();
});
