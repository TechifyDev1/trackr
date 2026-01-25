import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show TextInputFormatter;

class CustomTextInput extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool isPassWordInput;
  final IconData prefixIcon;
  final String? errorText;
  final bool disabled;
  final TextInputType inputType;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  const CustomTextInput({
    super.key,
    required this.controller,
    required this.placeholder,
    this.isPassWordInput = false,
    this.prefixIcon = CupertinoIcons.person,
    this.errorText,
    this.onChanged,
    this.disabled = false,
    this.inputType = TextInputType.text,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        CupertinoTextField(
          inputFormatters: widget.inputFormatters,
          keyboardType: widget.inputType,
          readOnly: widget.disabled,
          obscureText: widget.isPassWordInput,
          padding: const EdgeInsets.all(12),
          controller: widget.controller,
          placeholder: widget.placeholder,
          prefix: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(widget.prefixIcon, color: CupertinoColors.systemGrey6),
          ),
          cursorColor: CupertinoColors.white,
          decoration: BoxDecoration(
            color: CupertinoColors.darkBackgroundGray,
            borderRadius: BorderRadius.circular(10),
          ),
          style: const TextStyle(color: CupertinoColors.white),
          onChanged: widget.onChanged,
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                color: CupertinoColors.systemRed,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
