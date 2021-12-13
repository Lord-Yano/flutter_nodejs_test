import 'package:fluttertoast/fluttertoast.dart';

import '../config.dart';

void toast(String msg, String type) {
  var backgroundColor = darkColor;
  var textColor = whiteColor;
  if (type == "error") {
    backgroundColor = dangerColor;
  }

  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0);
}
