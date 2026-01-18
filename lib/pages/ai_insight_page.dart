import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_markdown_plus_latex/flutter_markdown_plus_latex.dart';
import 'package:markdown/markdown.dart' as md;

class AiInsightPage extends StatelessWidget {
  final String insights;
  const AiInsightPage({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Trackr Insight")),
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: .only(bottom: 60),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    MarkdownBody(
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: CupertinoColors.extraLightBackgroundGray,
                        ),

                        h1: TextStyle(
                          color: CupertinoColors.extraLightBackgroundGray,
                          fontWeight: FontWeight.bold,
                        ),
                        h2: TextStyle(
                          color: CupertinoColors.extraLightBackgroundGray,
                          fontWeight: FontWeight.bold,
                        ),
                        h3: TextStyle(
                          color: CupertinoColors.extraLightBackgroundGray,
                          fontWeight: FontWeight.bold,
                        ),
                        h4: TextStyle(
                          color: CupertinoColors.extraLightBackgroundGray,
                        ),
                        h5: TextStyle(
                          color: CupertinoColors.extraLightBackgroundGray,
                        ),
                        h6: TextStyle(
                          color: CupertinoColors.extraLightBackgroundGray,
                        ),

                        strong: TextStyle(
                          color: CupertinoColors.extraLightBackgroundGray,
                          fontWeight: FontWeight.bold,
                        ),
                        em: TextStyle(
                          color: CupertinoColors.extraLightBackgroundGray,
                          fontStyle: FontStyle.italic,
                        ),

                        listBullet: TextStyle(
                          color: CupertinoColors.extraLightBackgroundGray,
                        ),
                        listIndent: 24,

                        blockquote: TextStyle(
                          color: CupertinoColors.extraLightBackgroundGray,
                          fontStyle: FontStyle.italic,
                        ),

                        code: TextStyle(
                          color: CupertinoColors.extraLightBackgroundGray,
                          fontFamily: 'monospace',
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: CupertinoColors.systemGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),

                        horizontalRuleDecoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: CupertinoColors.extraLightBackgroundGray,
                            ),
                          ),
                        ),

                        a: TextStyle(
                          color: CupertinoColors.extraLightBackgroundGray,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      selectable: true,
                      data: insights,
                      builders: {
                        'latex': LatexElementBuilder(
                          textStyle: TextStyle(
                            color: CupertinoColors.extraLightBackgroundGray,
                          ),
                        ),
                      },
                      extensionSet: md.ExtensionSet(
                        [LatexBlockSyntax()],
                        [LatexInlineSyntax()],
                      ),
                    ),
                  ],
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
                      ),
                    ),
                    const SizedBox(width: 8),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(
                        CupertinoIcons.arrow_up_circle_fill,
                        size: 32,
                      ),
                      onPressed: () {},
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
