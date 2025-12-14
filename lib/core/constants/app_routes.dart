import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/features/auth/Presentation/screens/login_screen.dart';
import 'package:car_rental_app/features/auth/Presentation/screens/phone_auth_screen.dart';
import 'package:car_rental_app/features/auth/Presentation/screens/signup_screen.dart';
import 'package:car_rental_app/features/auth/Presentation/screens/verify_otp_screen.dart';
import 'package:car_rental_app/features/bookings/presentation/screens/bookings_screen.dart';
import 'package:car_rental_app/features/home/Presentation/blocs/date_picker_bloc/date_picker_bloc.dart';
import 'package:car_rental_app/features/home/Presentation/screens/book_rental_car_screen.dart';
import 'package:car_rental_app/features/home/Presentation/screens/car_detail_screen.dart';
import 'package:car_rental_app/features/home/Presentation/screens/home_screen.dart';
import 'package:car_rental_app/features/home/Presentation/screens/map_screen.dart';
import 'package:car_rental_app/features/home/domain/entities/car_model.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_rental_app/features/home/Presentation/blocs/book_rental_cubit/book_rental_cubit.dart';
import 'package:flutter/widgets.dart';

class AppRoutes {
  static const String signup = "/signup";
  static const String login = "/login";
  static const String home = "/home";
  static const String verified = "/verified";
  static const String phoneAuth = "/phone-auth";
  static const String verifyOtp = "/verify-otp";
  static const String carDetail = "/car-detail";
  static const String bookRentalCar = "/book-rental-car";
  static const String map = "/map";
  static const String bookings = "/bookings";

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
}

final List<RouteBase> kappRoutes = [
  GoRoute(path: AppRoutes.signup, builder: (context, state) => SignupScreen()),
  GoRoute(path: AppRoutes.login, builder: (context, state) => LoginScreen()),
  GoRoute(path: AppRoutes.home, builder: (context, state) => HomeScreen()),
  GoRoute(path: AppRoutes.verified, builder: (context, state) => HomeScreen()),
  GoRoute(
    path: AppRoutes.phoneAuth,
    builder: (context, state) => PhoneAuthScreen(),
  ),
  GoRoute(
    path: AppRoutes.verifyOtp,
    builder: (context, state) {
      final phoneNumber = state.extra as String;
      // final phoneNumber = "+201066670772";
      return VerifyOtpScreen(phoneNumber: phoneNumber);
    },
  ),
  GoRoute(
    path: AppRoutes.bookRentalCar,
    builder: (context, state) {
     final extra = state.extra as Map<String,dynamic>;
      return BlocProvider(
        create: (context) => BookRentalCubit(context)..getUserCurrentPosition(),
        child: BookRentalCarScreen(datePickerBloc: extra["datePickerBloc"] as DatePickerBloc, carModel: extra["model"] as CarModel),
      );
    },
  ),
  GoRoute(
    path: AppRoutes.carDetail,
    builder: (context, state) {
      final model = state.extra as CarModel;
      return BlocProvider(
        create: (context) => DatePickerBloc()..add(SelectDateEvent(selectedDate: AppUtils.currentDate())),
        child: CarDetailScreen(model: model),
      );
    },
  ),
  GoRoute(
    path: AppRoutes.map,
    builder: (context, state) => BlocProvider.value(
      value: state.extra! as BookRentalCubit,
      child: MapScreen(),
    ),
  ),
  GoRoute(
    path: AppRoutes.bookings,
    builder: (context, state) => BookingsScreen(),
  ),
];
