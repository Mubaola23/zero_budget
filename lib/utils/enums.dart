import 'package:flutter/material.dart';

enum ExpenseCategory {
  food('Food & Dining', Colors.orange),
  transportation('Transportation', Colors.green),
  bills('Bills & Utilities', Colors.red),
  shopping('Shopping', Colors.purple),
  entertainment('Entertainment', Colors.blue),
  other('Other', Colors.grey);

  const ExpenseCategory(this.displayName, this.color);
  final String displayName;
  final Color color;
}
