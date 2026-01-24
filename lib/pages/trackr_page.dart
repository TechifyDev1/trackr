import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/chat/history.dart';
import 'package:flutter_application_1/models/chat/message.dart';
import 'package:flutter_application_1/models/insights/part.dart';
import 'package:flutter_application_1/models/ui_message.dart';
import 'package:flutter_application_1/pages/ai_insight_page.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_application_1/widgets/molecules/ai_response.dart';
import 'package:flutter_application_1/widgets/molecules/chat_bubble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrackrPage extends ConsumerStatefulWidget {
  final String? initialMessage;
  final String? initialResponse;
  const TrackrPage({super.key, this.initialMessage, this.initialResponse});

  @override
  ConsumerState<TrackrPage> createState() => _TrackrPageState();
}

class _TrackrPageState extends ConsumerState<TrackrPage> {
  late TextEditingController messageController;
  late ScrollController scrollController;
  List<UiMessage> messages = [];
  bool isThinking = false;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
    scrollController = ScrollController();

    if (widget.initialMessage != null) {
      messages.add(UiMessage.user(widget.initialMessage!));
      // If we came from Home Page, the initial history might already have been populated in AI button
    }

    if (widget.initialResponse != null) {
      messages.add(UiMessage.ai(widget.initialResponse!));
    }

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
      messages.add(UiMessage.user(text));
      messageController.clear();
      isThinking = true;
    });
    scrolltoBottom();

    final userTurn = History(
      role: "user",
      parts: [Part(text: text)],
    );

    final message = Message(
      message: text,
      history: List.from(InsightHistoryState.history),
    );

    InsightHistoryState.history.add(userTurn);

    try {
      final res = await Utils.getResponse(
        message,
        ref,
        onIntent: (intent, {bool isDone = false}) {
          setState(() {
            if (isDone) {
              final index = messages.lastIndexWhere((m) => m.type == MessageType.intent);
              if (index != -1) {
                messages[index] = messages[index].copyWith(message: intent);
              } else {
                messages.add(UiMessage.intent(intent));
              }
            } else {
              messages.add(UiMessage.intent(intent));
            }
          });
          scrolltoBottom();
        },
      );

      if (res.trim().isEmpty) {
        throw "Empty response received";
      }

      setState(() {
        isThinking = false;
        messages.add(UiMessage.ai(res));

        InsightHistoryState.history.add(
          History(
            role: "model",
            parts: [Part(text: res)],
          ),
        );
      });
    } catch (e) {
      setState(() {
        isThinking = false;
        messages.add(UiMessage.ai("Something went wrong. Please try again."));
      });
      debugPrint(e.toString());
    } finally {
      scrolltoBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Trackr")),
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ...messages.map((m) {
                            if (m.type == MessageType.intent) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  "Trackr is ${m.message}",
                                  style: TextStyle(
                                    color: CupertinoColors.systemGrey,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: m.isUser
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
                                        ),
                                        child: ChatBubble(message: m.message),
                                      ),
                                    )
                                  : AiResponse(response: m.message),
                            );
                          }),
                          if (isThinking)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Image(
                                    image: AssetImage("assets/logo/trackr.png"),
                                    height: 30,
                                    width: 30,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Thinking...",
                                    style: TextStyle(
                                      color: CupertinoColors.systemGrey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: CupertinoColors.black,
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
                        onPressed: isThinking
                            ? null
                            : () {
                                sendMessage();
                              },
                        child: isThinking
                            ? const CupertinoActivityIndicator()
                            : const Icon(
                                CupertinoIcons.arrow_up_circle_fill,
                                size: 32,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
