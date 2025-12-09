import 'package:app_links/app_links.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeepLinkHandler {
  final AppLinks _appLinks = AppLinks();

  Future<void> init(BuildContext context) async {
    // Cold-start link
    final uri = await _appLinks.getInitialLink();
    if (uri != null) {
      _handleUri(uri, context);
    }

    // Runtime links
    _appLinks.uriLinkStream.listen((uri) {
      _handleUri(uri, context);
    });
  }

  void _handleUri(Uri uri, BuildContext context) {
    debugPrint("Deep link received: $uri");
    // Supabase email verification link example:
    // https://project.supabase.co/auth/v1/callback?type=signup
    final type = uri.queryParameters["type"];
    final code = uri.queryParameters["code"];
    final isAuthCallback = uri.host == 'auth-callback' || uri.path == '/auth-callback';

    if (type == "signup" || type == "email_verification" || (isAuthCallback && code != null)) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Email verified. You can now log in.")),
      // );
      context.go(AppRoutes.verified);
    }
  }
}
