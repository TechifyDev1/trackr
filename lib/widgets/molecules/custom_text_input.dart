import 'package:flutter/cupertino.dart';

class CustomTextInput extends StatefulWidget {
  final TextEditingController nameController;
  final String placeholder;
  final bool isPassWordInput;
  final IconData prefixIcon;
  final String? errorText;
  final bool disabled;
  final void Function(String)? onChanged;
  const CustomTextInput({
    super.key,
    required this.nameController,
    required this.placeholder,
    this.isPassWordInput = false,
    this.prefixIcon = CupertinoIcons.person,
    this.errorText,
    this.onChanged,
    this.disabled = false,
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
          readOnly: widget.disabled,
          obscureText: widget.isPassWordInput,
          padding: EdgeInsets.all(12),
          controller: widget.nameController,
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
          style: TextStyle(color: CupertinoColors.white),
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
