import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/core/constants/app_theme.dart';
import 'package:car_rental_app/core/services/routing_service.dart';
import 'package:car_rental_app/features/home/data/geocoding_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:car_rental_app/core/services/startup_service.dart';

void main() async{
  await StartupService.init();
  // await StartupService.insertCarsIntoSupabase();
  runApp(const MainApp());
}

final _router = GoRouter(
  navigatorKey: AppRoutes.rootNavigatorKey,
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
      //Add user to database
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
     WidgetsBinding.instance.addPostFrameCallback((_) async{
      await DeepLinkHandler().init(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveApp.router(
      routerConfig: _router,
      themeMode: ThemeMode.light,
      cupertinoLightTheme: CupertinoThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
      ),
      materialLightTheme: AppTheme.lightTheme.copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            iconColor: Colors.white,
            surfaceTintColor: AppColors.primary,
          ),
        ),
        timePickerTheme: TimePickerThemeData(
          backgroundColor: AppColors.background,
          hourMinuteColor: AppColors.silverAccent,
          dialBackgroundColor: AppColors.silverAccent,
          confirmButtonStyle: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
          ),
          cancelButtonStyle: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          dayPeriodColor: Colors.blue,
          dayPeriodTextColor: Colors.black,
          hourMinuteTextColor: Colors.black,
          dialHandColor: AppColors.primary,
        ),
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            overlayColor: Colors.transparent,  
            splashFactory: NoSplash.splashFactory,
          ),
        ),
      ),
      localizationsDelegates: const [
        // Add material localizations
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', 'US')],
    );
  }
}
