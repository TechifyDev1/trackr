import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/enums/enums.dart';
import 'package:flutter_application_1/models/expense.dart';
import 'package:flutter_application_1/services/expense_service.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_application_1/widgets/molecules/custom_text_input.dart';

class EditExpenseForm extends StatefulWidget {
  final Expense expense;

  const EditExpenseForm({super.key, required this.expense});

  @override
  State<EditExpenseForm> createState() => _EditExpenseFormState();
}

class _EditExpenseFormState extends State<EditExpenseForm> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _noteController;

  bool _loading = false;
  String? _amountError;
  String? _titleError;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.expense.title);
    _amountController = TextEditingController(
      text: widget.expense.amount.toString(),
    );
    _noteController = TextEditingController(text: widget.expense.notes);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool valid = true;

    if (_titleController.text.trim().isEmpty) {
      _titleError = "Title is required";
      valid = false;
    } else {
      _titleError = null;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _amountError = "Enter a valid amount";
      valid = false;
    } else {
      _amountError = null;
    }

    setState(() {});
    return valid;
  }

  Future<void> _submit() async {
    if (_loading) return;
    if (!_validate()) return;

    setState(() => _loading = true);

    if (kDebugMode) print(_amountController.text);

    try {
      await ExpenseService.instance.updateExpense(
        updatedExpense: widget.expense.copyWith(
          title: _titleController.text.trim(),
          amount: double.parse(_amountController.text),
          notes: _noteController.text.trim(),
        ),
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        Utils.showError(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Edit Transaction"),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Title"),
              const SizedBox(height: 5),
              CustomTextInput(
                controller: _titleController,
                errorText: _titleError,
                placeholder: "Title",
                prefixIcon: CupertinoIcons.pencil,
              ),

              const SizedBox(height: 12),
              const Text("Amount"),
              const SizedBox(height: 5),
              CustomTextInput(
                controller: _amountController,
                inputType: TextInputType.number,
                errorText: _amountError,
                placeholder: "New Amount",
                prefixIcon: CupertinoIcons.money_dollar,
              ),

              const SizedBox(height: 12),
              const Text("Notes"),
              const SizedBox(height: 5),
              CustomTextInput(
                controller: _noteController,
                placeholder: "Optional",
                prefixIcon: CupertinoIcons.book,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  color: CupertinoColors.activeBlue,
                  onPressed: () {
                    Utils.showConfirmationDialog(
                      context,
                      severity: Severity.medium,
                      action: _submit,
                      message: "Are you sure you want to Update this Expense?",
                    );
                  },
                  child: _loading
                      ? const CupertinoActivityIndicator()
                      : const Text("Save Changes"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
