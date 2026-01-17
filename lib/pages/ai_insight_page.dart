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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: MarkdownBody(
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  color: CupertinoColors.extraLightBackgroundGray,
                ), // Standard paragraph text
                h1: TextStyle(color: CupertinoColors.extraLightBackgroundGray),
                h2: TextStyle(color: CupertinoColors.extraLightBackgroundGray),
                listBullet: TextStyle(
                  color: CupertinoColors.extraLightBackgroundGray,
                ),
                h3: TextStyle(color: CupertinoColors.extraLightBackgroundGray),
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
          ),
        ),
      ),
    );
  }
}
