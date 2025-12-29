import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/features/auth/Presentation/screens/login_screen.dart';
import 'package:car_rental_app/features/auth/Presentation/screens/phone_auth_screen.dart';
import 'package:car_rental_app/features/auth/Presentation/screens/signup_screen.dart';
import 'package:car_rental_app/features/auth/Presentation/screens/verify_otp_screen.dart';
import 'package:car_rental_app/features/bookings/presentation/screens/bookings_screen.dart';
import 'package:car_rental_app/features/bookings/presentation/blocs/date_picker_bloc/date_picker_bloc.dart';
import 'package:car_rental_app/features/bookings/presentation/screens/book_rental_car_screen.dart';
import 'package:car_rental_app/features/chat/domain/entities/conversation_model.dart';
import 'package:car_rental_app/features/chat/presentation/chat_bloc/chat_bloc.dart';
import 'package:car_rental_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:car_rental_app/features/home/Presentation/customer/screens/car_detail_screen.dart';
import 'package:car_rental_app/features/home/Presentation/customer/screens/customer_home_screen.dart';
import 'package:car_rental_app/features/bookings/presentation/screens/map_screen.dart';
import 'package:car_rental_app/features/home/Presentation/seller/blocs/add_listing_bloc/add_listing_bloc.dart';
import 'package:car_rental_app/features/home/Presentation/seller/screens/add_car_listing_screen.dart';
import 'package:car_rental_app/features/home/Presentation/seller/screens/seller_home_screen.dart';
import 'package:car_rental_app/features/home/domain/entities/car_model.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_rental_app/features/bookings/presentation/blocs/book_rental_cubit/book_rental_cubit.dart';
import 'package:flutter/widgets.dart';

class AppRoutes {
  static const String signup = "/signup";
  static const String login = "/login";
  static const String customerHome = "/customer-home";
  static const String sellerHome = "/seller-home";
  static const String verified = "/verified";
  static const String phoneAuth = "/phone-auth";
  static const String verifyOtp = "/verify-otp";
  static const String carDetail = "/car-detail";
  static const String bookRentalCar = "/book-rental-car";
  static const String map = "/map";
  static const String bookings = "/bookings";
  static const String addCarListing = "/add-car-listing";
  static const String chat = "/chat";

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
}

final List<RouteBase> kappRoutes = [
  GoRoute(path: AppRoutes.signup, builder: (context, state) => SignupScreen()),
  GoRoute(path: AppRoutes.login, builder: (context, state) => LoginScreen()),
  GoRoute(
    path: AppRoutes.customerHome,
    builder: (context, state) => CustomerHomeScreen(),
  ),
  GoRoute(
    path: AppRoutes.verified,
    builder: (context, state) => CustomerHomeScreen(),
  ),
  GoRoute(
    path: AppRoutes.chat,
    builder: (context, state) {
      
      final extra = state.extra as Map<String,dynamic>;

        final conversationModel = extra['conversationModel'] as ConversationModel?;
        return BlocProvider(
          create: (context) {
            final bloc = ChatBloc();
            if (conversationModel != null) {
              bloc.add(ChatMessagesSubscribed(conversationId: conversationModel.id!));
            }
            return bloc;
          },
          child: ChatScreen(conversationModel: conversationModel!),
        );
    },
    ),
  GoRoute(
    path: AppRoutes.sellerHome,
    builder: (context, state) => SellerHomeScreen(),
  ),
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
      final extra = state.extra as Map<String, dynamic>;
      return BlocProvider(
        create: (context) => BookRentalCubit(context)..getUserCurrentPosition(),
        child: BookRentalCarScreen(
          datePickerBloc: extra["datePickerBloc"] as DatePickerBloc,
          carModel: extra["model"] as CarModel,
        ),
      );
    },
  ),
  GoRoute(
    path: AppRoutes.carDetail,
    builder: (context, state) {
      final model = state.extra as CarModel;
      return BlocProvider(
        create: (context) =>
            DatePickerBloc()
              ..add(SelectDateEvent(selectedDate: AppUtils.currentDate())),
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
  GoRoute(
    path: AppRoutes.addCarListing,
    builder: (context, state) => BlocProvider(
      create: (context) => AddListingBloc(),
      child: AddCarListingScreen(),
    ),
  ),
];
