import 'package:flutter/cupertino.dart';

class AiButton extends StatefulWidget {
  const AiButton({super.key});

  @override
  State<AiButton> createState() => _AiButtonState();
}

class _AiButtonState extends State<AiButton> {
  bool expanded = false;
  bool isEmpty = true;
  late FocusNode _focusNode;
  late TextEditingController reqController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    reqController = TextEditingController();
    reqController.addListener(_handleTextChange);
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      setState(() {
        expanded = false;
      });
    }
  }

  void _handleTextChange() {
    if (reqController.text.trim() == "") {
      setState(() {
        isEmpty = true;
      });
    } else {
      setState(() {
        isEmpty = false;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusNode.removeListener(_handleFocusChange);
    reqController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height * 0.06;
    final double fromBottom = MediaQuery.sizeOf(context).height * 0.005;
    final double initialWidth = MediaQuery.sizeOf(context).width * 0.4;
    // final double fromLeft = MediaQuery.sizeOf(context).width * 0.1;
    return Positioned(
      bottom: fromBottom,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {
            setState(() {
              expanded = !expanded;
            });
            _focusNode.requestFocus();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: height,
            width: expanded
                ? MediaQuery.sizeOf(context).width * 0.7
                : initialWidth,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 36, 36, 36),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                if (!expanded) ...[
                  const Icon(
                    CupertinoIcons.lightbulb,
                    color: CupertinoColors.activeOrange,
                  ),
                  const SizedBox(width: 8),
                  const Text("Ask Trackr"),
                ] else ...[
                  Expanded(
                    child: CupertinoTextField(
                      focusNode: _focusNode,
                      autofocus: true,
                      placeholder: "Ask Trackr…",
                      decoration: null,
                      padding: const .all(8),
                      controller: reqController,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: Icon(
                      isEmpty
                          ? CupertinoIcons.keyboard
                          : CupertinoIcons.arrow_up_circle_fill,
                      color: isEmpty
                          ? CupertinoColors.systemGrey
                          : CupertinoColors.activeBlue,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
