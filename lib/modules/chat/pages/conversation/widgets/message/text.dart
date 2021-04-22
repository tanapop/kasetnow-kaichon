import 'package:flutter/material.dart';

import 'package:flutter_linkify/flutter_linkify.dart';
import '../../../../../../imports.dart';
import '../../../../models/message.dart';

class TextMsgItem extends StatelessWidget {
  final Message msg;

  const TextMsgItem(
    this.msg, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      constraints: BoxConstraints(maxWidth: context.width - 100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: msg.isFromMe
            ? AppStyles.primaryColorRedKnow
            : AppStyles.primaryColorTextField,
      ),
      child: Linkify(
          onOpen: (l) => launchURL(l.url),
          text: msg.content,
          style: TextStyle(color: AppStyles.primaryColorWhite)
          //  GoogleFonts.basic(
          //     textStyle: theme.textTheme.subtitle1, color: Colors.white),
          ),
    );
  }
}
