

import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

// Can plug in direct listener if wanted
JavascriptChannel callNumberChannel(BuildContext context) {
  return JavascriptChannel(
    name: 'NATIVE',
    onMessageReceived: (JavascriptMessage message) {
      launchCaller();

      print(message.message);
    }
  );
}

Future<Null>launchCaller() async {
  const url = "tel:1234567";   
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }   
}