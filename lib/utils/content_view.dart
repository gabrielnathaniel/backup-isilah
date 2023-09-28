import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';

class MyWebview extends StatefulWidget {
  const MyWebview({
    Key? key,
    this.url,
    this.title,
  }) : super(key: key);

  final String? url;
  final String? title;

  @override
  MyWebviewState createState() => MyWebviewState();
}

class MyWebviewState extends State<MyWebview> {
  bool isLoading = true;
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: ColorPalette.neutral_90),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: isLoading
                ? Align(
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator(
                      backgroundColor: ColorPalette.mainColor.withOpacity(0.5),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          ColorPalette.mainColor),
                    ))
                : Container()),
      ),
      body: InAppWebView(
        key: webViewKey,
        initialOptions: options,
        initialUrlRequest: URLRequest(url: Uri.parse(widget.url!)),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onProgressChanged: (controller, progress) {
          if (progress == 100) {
            setState(() {
              isLoading = false;
            });
          }
        },
      ),
    );
  }
}
