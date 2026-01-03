import 'package:flutter_application_1/models/expense.dart';
import 'package:flutter_application_1/services/expense_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseProvider = StreamProvider.autoDispose<List<Expense>>((ref) {
  final expenses = ExpenseService.instance.watchExpenses();
  return expenses;
});
