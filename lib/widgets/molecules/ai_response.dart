import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_markdown_plus_latex/flutter_markdown_plus_latex.dart';
import 'package:markdown/markdown.dart' as md;

class AiResponse extends StatelessWidget {
  final String response;
  const AiResponse({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .start,
      children: [
        Image(
          image: AssetImage("assets/logo/trackr.png"),
          height: 30,
          width: 30,
        ),
        SizedBox(width: 10),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.7,
          child: MarkdownBody(
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(color: CupertinoColors.extraLightBackgroundGray),

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
              h4: TextStyle(color: CupertinoColors.extraLightBackgroundGray),
              h5: TextStyle(color: CupertinoColors.extraLightBackgroundGray),
              h6: TextStyle(color: CupertinoColors.extraLightBackgroundGray),

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
            data: response,
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
      ],
    );
  }
}
