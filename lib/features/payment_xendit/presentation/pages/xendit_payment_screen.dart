import 'package:flutter/material.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class XenditPaymentScreen extends StatefulWidget {
  const XenditPaymentScreen({super.key, required this.invoiceUrl});

  final String invoiceUrl;

  @override
  State<XenditPaymentScreen> createState() => _XenditPaymentScreenState();
}

class _XenditPaymentScreenState extends State<XenditPaymentScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onNavigationRequest: (request) {
            if (request.url.startsWith(
              'https://your-app-domain.com/payment-success',
            )) {
              Navigator.of(context).pop(true); // success
              return NavigationDecision.prevent;
            }
            if (request.url.startsWith(
              'https://your-app-domain.com/payment-failure',
            )) {
              Navigator.of(context).pop(false); // failure/cancelled
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.invoiceUrl));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: GeneralAppBar(title: 'Complete Payment'),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
