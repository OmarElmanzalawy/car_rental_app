import 'package:app_links/app_links.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/features/auth/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  void _handleUri(Uri uri, BuildContext context) async{
    debugPrint("Deep link received: $uri");
    final type = uri.queryParameters["type"];
    final code = uri.queryParameters["code"] ?? uri.queryParameters['access_token'];
    final isAuthCallback = uri.host == 'auth-callback' || uri.path == '/auth-callback';

    if (type == "signup" || type == "email_verification" || (isAuthCallback && code != null)) {
      if (code != null) {
        await Supabase.instance.client.auth.exchangeCodeForSession(code);
      }
      await AuthService.completeEmailVerification();
      final navCtx = AppRoutes.rootNavigatorKey.currentContext;
      final user = Supabase.instance.client.auth.currentUser;
      final roleName = user?.userMetadata?['role'] as String? ?? 'customer';
      final target = roleName == 'seller' ? AppRoutes.sellerHome : AppRoutes.customerHome;
      if (navCtx != null) {
        navCtx.go(target);
      }
    }
  }
}
