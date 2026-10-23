import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bar_title.dart';

/// `AppRoutes.paymentGateway` — RapidGateway's hosted checkout page
/// (card / wallet / bank / Raast) in a WebView, pushed by `CheckoutView`.
///
/// Pops as soon as the gateway redirects to the backend's
/// `/payments/return` page, with that URL's `result` query value
/// (`success`/`failure`), or `null` if the student closes it first. The
/// result is UX only — it can be tampered with, so `CheckoutView` still
/// waits for the webhook-settled purchase via `paymentConfirmationProvider`.
class PaymentGatewayView extends StatefulWidget {
  const PaymentGatewayView({super.key, required this.checkoutUrl});

  final String checkoutUrl;

  @override
  State<PaymentGatewayView> createState() => _PaymentGatewayViewState();
}

class _PaymentGatewayViewState extends State<PaymentGatewayView> {
  static const _returnPath = '/payments/return';

  late final WebViewController _controller;

  // Ephemeral page-load progress only (0..1) — no business state here.
  double _progress = 0;
  bool _returned = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) => _handleUrl(request.url)
              ? NavigationDecision.prevent
              : NavigationDecision.navigate,
          // Server-side redirects don't always surface as a navigation
          // request on every platform — catch them here too.
          onPageStarted: _handleUrl,
          onUrlChange: (change) {
            if (change.url != null) _handleUrl(change.url!);
          },
          onProgress: (progress) {
            if (mounted) setState(() => _progress = progress / 100);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  /// Returns true (and closes the WebView) when [url] is the backend's
  /// post-payment return page.
  bool _handleUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.path.endsWith(_returnPath)) return false;
    if (!_returned && mounted) {
      _returned = true;
      context.pop(uri.queryParameters['result']);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(context.l10n.paymentGatewayTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: () => context.pop(),
        ),
        bottom: _progress < 1
            ? PreferredSize(
                preferredSize: const Size.fromHeight(2),
                child: LinearProgressIndicator(
                  value: _progress == 0 ? null : _progress,
                  minHeight: 2,
                  color: context.colors.primary,
                ),
              )
            : null,
      ),
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
