import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/chat/history.dart';
import 'package:flutter_application_1/models/chat/message.dart';
import 'package:flutter_application_1/models/insights/part.dart';
import 'package:flutter_application_1/pages/ai_insight_page.dart';
import 'package:flutter_application_1/pages/trackr_page.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiButton extends ConsumerStatefulWidget {
  const AiButton({super.key});

  @override
  ConsumerState<AiButton> createState() => _AiButtonState();
}

class _AiButtonState extends ConsumerState<AiButton> {
  bool expanded = false;
  bool isEmpty = true;
  bool isLoading = false;
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
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    reqController.removeListener(_handleTextChange);
    reqController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    final text = reqController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final userTurn = History(
        role: "user",
        parts: [Part(text: text)],
      );

      final message = Message(
        message: text,
        history: List.from(InsightHistoryState.history),
      );

      InsightHistoryState.history.add(userTurn);

      final res = await Utils.getResponse(message, ref);

      if (!mounted) return;

      InsightHistoryState.history.add(
        History(
          role: "model",
          parts: [Part(text: res)],
        ),
      );

      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) =>
              TrackrPage(initialMessage: text, initialResponse: res),
        ),
      );

      setState(() {
        reqController.clear();
        expanded = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;

    final double height = (screenHeight * 0.06).clamp(45.0, 60.0);
    final double fromBottom = screenHeight * 0.01;
    final double initialWidth = (screenWidth * 0.4).clamp(140.0, 200.0);
    final double expandedWidth = (screenWidth * 0.85).clamp(280.0, 500.0);

    return Positioned(
      bottom: fromBottom,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: true,
        top: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              if (!expanded) {
                setState(() {
                  expanded = true;
                });
                _focusNode.requestFocus();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: height,
              width: expanded ? expandedWidth : initialWidth,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 36, 36, 36),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(48, 0, 0, 0),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (!expanded) ...[
                    const Icon(
                      CupertinoIcons.lightbulb,
                      color: CupertinoColors.activeOrange,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child:
                          Text("Ask Trackr", overflow: TextOverflow.ellipsis),
                    ),
                  ] else ...[
                    Expanded(
                      child: CupertinoTextField(
                        focusNode: _focusNode,
                        autofocus: true,
                        placeholder: "Ask Trackr…",
                        decoration: null,
                        padding: const EdgeInsets.all(8),
                        controller: reqController,
                        readOnly: isLoading,
                        style: const TextStyle(color: CupertinoColors.white),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: isLoading ? null : sendMessage,
                      child: isLoading
                          ? const CupertinoActivityIndicator()
                          : Icon(
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
      ),
    );
  }
}
