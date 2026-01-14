import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:app_links/app_links.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/core/services/dialogue_service.dart';
import 'package:car_rental_app/features/auth/data/auth_service.dart';
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
    final isAuthCallback = uri.host == 'auth-callback' || uri.path == '/auth-callback';

    Map<String, String> fragmentParams = {};
    if (uri.fragment.isNotEmpty && uri.fragment.contains('=')) {
      try {
        fragmentParams = Uri.splitQueryString(uri.fragment);
      } catch (_) {
        fragmentParams = {};
      }
    }

    final mergedParams = <String, String>{
      ...uri.queryParameters,
      ...fragmentParams,
    };

    if (isAuthCallback) {
      final error = mergedParams['error'] ?? mergedParams['error_code'];
      if (error != null) {
        final description = (mergedParams['error_description'] ??
                mergedParams['error_code'] ??
                mergedParams['error'] ??
                'Email link is invalid or has expired.')
            .replaceAll('+', ' ');

        DialogueService.showAdaptiveSnackBar(
          context,
          message: description,
          type: AdaptiveSnackBarType.error,
        );

        final navCtx = AppRoutes.rootNavigatorKey.currentContext;
        if (navCtx != null) {
          navCtx.go(AppRoutes.signup);
        } else {
          context.go(AppRoutes.signup);
        }
        return;
      }

      final code = mergedParams['code'] ?? mergedParams['access_token'];
      if (code == null) {
        DialogueService.showAdaptiveSnackBar(
          context,
          message: 'Email link is invalid or has expired.',
          type: AdaptiveSnackBarType.error,
        );
        final navCtx = AppRoutes.rootNavigatorKey.currentContext;
        if (navCtx != null) {
          navCtx.go(AppRoutes.signup);
        } else {
          context.go(AppRoutes.signup);
        }
        return;
      }

      await Supabase.instance.client.auth.exchangeCodeForSession(code);
      await AuthDataSourceImpl(Supabase.instance.client).completeEmailVerification();

      final navCtx = AppRoutes.rootNavigatorKey.currentContext;
      final user = Supabase.instance.client.auth.currentUser;
      final roleName = user?.userMetadata?['role'] as String? ?? 'customer';
      final target = roleName == 'seller' ? AppRoutes.sellerHome : AppRoutes.customerHome;
      if (navCtx != null) {
        navCtx.go(target);
      } else {
        context.go(target);
      }
      return;
    }

    final type = uri.queryParameters["type"];
    final code = uri.queryParameters["code"] ?? uri.queryParameters['access_token'];
    if (type == "signup" || type == "email_verification") {
      if (code != null) {
        await Supabase.instance.client.auth.exchangeCodeForSession(code);
      }
      await AuthDataSourceImpl(Supabase.instance.client).completeEmailVerification();
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
