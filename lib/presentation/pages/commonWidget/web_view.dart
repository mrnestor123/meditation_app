import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final String selectedUrl;

  CustomWebView({this.selectedUrl});

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {

  @override
  void initState() {
    super.initState();
     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  denied() {
    Navigator.pop(context);
  }

  succeed(String url) {
    var params = url.split("access_token=");

    var endparam = params[1].split("&");

    Navigator.pop(context, endparam[0]);
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
          onPageFinished: (url){
            print('PAGEFINISHED');
            if (url.contains("#access_token")) {
              succeed(url);
            }

            if (url.contains(
              "https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
              denied();
            }
          },
          javascriptMode: JavascriptMode.unrestricted,    
          initialUrl: widget.selectedUrl,
      );
  }
}
