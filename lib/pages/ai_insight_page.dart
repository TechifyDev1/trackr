import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/chat/history.dart';
import 'package:flutter_application_1/models/chat/message.dart';
import 'package:flutter_application_1/models/insights/part.dart';
import 'package:flutter_application_1/models/ui_message.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_application_1/widgets/molecules/ai_response.dart';
import 'package:flutter_application_1/widgets/molecules/chat_bubble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiInsightPage extends ConsumerStatefulWidget {
  final String insights;
  const AiInsightPage({super.key, required this.insights});

  @override
  ConsumerState<AiInsightPage> createState() => _AiInsightPageState();
}

class _AiInsightPageState extends ConsumerState<AiInsightPage> {
  late TextEditingController messageController;
  late ScrollController scrollController;
  List<UiMessage> messages = [];

  @override
  void initState() {
    super.initState();
    messages.add(UiMessage(message: widget.insights, isUser: false));
    InsightHistoryState.history = [
      History(
        role: "user",
        parts: [
          Part(
            text:
                "Here is an AI-generated financial insight about my expenses. Please use it as context for our conversation:\n\n${widget.insights}",
          ),
        ],
      ),
      History(
        role: "model",
        parts: [Part(text: widget.insights)],
      ),
    ];
    messageController = TextEditingController();
    scrollController = ScrollController();
    scrolltoBottom();
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void scrolltoBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void sendMessage() async {
    final String text = messageController.text.trim();
    if (text.isEmpty) {
      return;
    }

    setState(() {
      messages.add(UiMessage(message: text, isUser: true));
      messageController.clear();
    });
    scrolltoBottom();

    // 1. Create the user turn
    final userTurn = History(
      role: "user",
      parts: [Part(text: text)],
    );

    // 2. Prepare the message for the FIRST API call
    final message = Message(
      message: text,
      history: List.from(InsightHistoryState.history),
    );

    // 3. Add the user turn to global history now so recursive calls have it
    InsightHistoryState.history.add(userTurn);

    try {
      final res = await Utils.getResponse(message, ref);
      if (res.trim().isEmpty) {
        throw "Empty response received";
      }
      setState(() {
        messages.add(UiMessage(message: res, isUser: false));

        // 4. Add the model's response to global history
        InsightHistoryState.history.add(
          History(
            role: "model",
            parts: [Part(text: res)],
          ),
        );
      });
      debugPrint(res);
    } catch (e) {
      setState(() {
        messages.add(
          UiMessage(
            message: "Something went wrong. Please try again.",
            isUser: false,
          ),
        );
      });
      debugPrint(e.toString());
    } finally {
      scrolltoBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Trackr Insight")),
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              padding: .only(bottom: 60),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: .end,
                  children: messages.map((m) {
                    return Padding(
                      padding: .only(bottom: 12),
                      child: m.isUser
                          ? ChatBubble(message: m.message)
                          : AiResponse(response: m.message),
                    );
                  }).toList(),
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                // Use a solid color or a blur effect for the background
                decoration: BoxDecoration(
                  color:
                      CupertinoColors.black, // Darker background for contrast
                  border: Border(
                    top: BorderSide(
                      color: const Color.fromARGB(26, 242, 242, 247),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        placeholder: "Ask Trackr...",
                        placeholderStyle: const TextStyle(
                          color: CupertinoColors.systemGrey,
                        ),
                        style: const TextStyle(color: CupertinoColors.white),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(26, 242, 242, 247),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        controller: messageController,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(
                        CupertinoIcons.arrow_up_circle_fill,
                        size: 32,
                      ),
                      onPressed: () {
                        sendMessage();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InsightHistoryState {
  static List<History> history = [];
}
