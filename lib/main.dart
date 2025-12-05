import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/core/constants/app_theme.dart';
import 'package:car_rental_app/core/services/routing_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  await Supabase.initialize(
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhndnZ0dnJidnd1dXpveHh5bnRrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ3NzYzNTUsImV4cCI6MjA4MDM1MjM1NX0.4T2uHbXlaukVXLDXvoJ4gMJq8ZTFONLMlcIPqAGv4AI",
    url: "https://xgvvtvrbvwuuzoxxyntk.supabase.co"
  );
  
  runApp(const MainApp());
}

final _router = GoRouter(
  initialLocation: AppRoutes.signup,
  routes: kappRoutes,
  redirect: (context, state) {
    print("full location: ${state.uri.toString()}");
    print("matched location: ${state.matchedLocation}");
    final uri = state.uri.toString();
    final loc = state.matchedLocation;
    final isLoggedIn = Supabase.instance.client.auth.currentSession != null;

    // 1) Deep link handling takes priority
    if (uri.startsWith('com.meshwari.app://auth-callback')) {
      // Route only once and allow /verified through
      if (loc != AppRoutes.verified) return AppRoutes.verified;
      return null;
    }

    // 2) Session-based gating
    final isAuthRoute = {
      AppRoutes.signup,
      AppRoutes.login,
      AppRoutes.phoneAuth,
      AppRoutes.verifyOtp,
    }.contains(loc);

    // Not logged in → gate non-auth routes to signup
    if (!isLoggedIn && !isAuthRoute && loc != AppRoutes.signup) {
      return AppRoutes.signup;
    }

    // Logged in → skip signup/login screens
    if (isLoggedIn && (loc == AppRoutes.signup || loc == AppRoutes.login)) {
      return AppRoutes.home;
    }

    return null;
  },
);

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  @override
  void initState() {
     WidgetsBinding.instance.addPostFrameCallback((_) {
      DeepLinkHandler().init(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformProvider(
          builder: (context) => PlatformTheme(
            themeMode: ThemeMode.light,
            materialLightTheme: AppTheme.lightTheme.copyWith(
              scaffoldBackgroundColor: AppColors.background,
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  overlayColor: Colors.transparent,  
                  splashFactory: NoSplash.splashFactory,
                ),
              ),
            ),
            builder: (context) => PlatformApp.router(
              routerConfig: _router,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                // Add material localizations
                DefaultMaterialLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en', 'US')],
            ),
          )
    );
  }
}
