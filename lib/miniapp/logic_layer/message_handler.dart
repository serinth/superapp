import 'package:superapp/miniapp/jsbridge.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_liquidcore/liquidcore.dart';
import 'package:flutter/services.dart';
import 'dart:async';


JavascriptChannel logicMessageHandler(BuildContext context, Completer<WebViewController> controller) {
  return JavascriptChannel(
    name: 'SUPA',
    onMessageReceived: (JavascriptMessage message) async {
      print(message.message);
      switch(message.message) {
        case 'onMyFunc': {
          JSContext _jsContext;
          String _jsContextResponse = '<empty>';

          _jsContextResponse = await _executeJavascriptEngine(_jsContext, 'onMyFunc');
          // Logic layer needs to run this registered js callback in miniapp/index.js
          print('Response from isolated js code was: $_jsContextResponse');
          // Return this to the renderer to call re-render
          
          controller.future.then((webviewController){
            webviewController.evaluateJavascript('document._observer.notify("$_jsContextResponse")');
          });
        }
        break;

        case 'phoneCall': {
          launchCaller();
        }
        break;

        default: {
          // do nothing
        }
        break;
      }
    }
  );
}

Future<String> _executeJavascriptEngine(JSContext context, String funcName) async {
  String _response = '<empty>';

  try {
    if (context == null) {
      context = new JSContext();
    }

  String _pageCode = await rootBundle.loadString('assets/miniapp/index.js');

  _response = await context.evaluateScript("""
    (function(){ 
      var _page = {};
      var Page = function(params){
        _page = params;
      }; 
      $_pageCode 
      return _page.$funcName(); 
    })();
    """);

  } catch(e) {
    print('Got script exception: $e');
  }

  return _response;

}