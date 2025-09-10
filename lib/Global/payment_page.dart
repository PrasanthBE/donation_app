import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';

class PaymentPageView extends StatefulWidget {
  final String url;
  PaymentPageView(this.url);
  @override
  State<PaymentPageView> createState() => CardExample(url);
}

class CardExample extends State<PaymentPageView> {
  final String url;
  CardExample(this.url);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.1),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Payment', style: theme.title3),
          backgroundColor: Colors.white,
        ),
        body: InAppWebView(initialUrlRequest: URLRequest(url: WebUri(url))),
      ),
    );
  }
}
