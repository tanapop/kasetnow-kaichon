import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'logger.dart';

Future<void> launchURL(String url) async {
  try {
    await launch(url);
  } catch (e) {
    logError(e);
    BotToast.showText(text: "$e");
  }
}

DateTime timeFromJson(dynamic ts) {
  // ignore: unnecessary_cast
  switch (ts?.runtimeType as Type) {
    case Timestamp:
      return (ts as Timestamp).toDate();
    case DateTime:
      return ts as DateTime;
    case String:
      return DateTime.parse(ts as String).toLocal();
    case int:
      return DateTime.fromMillisecondsSinceEpoch(ts as int).toLocal();
    default:
      return DateTime.now();
  }
}

bool isURL(String s) => RegExp(
      r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-]+))*$",
    ).hasMatch(s ?? '');
