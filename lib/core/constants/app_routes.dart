import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/features/auth/Presentation/screens/login_screen.dart';
import 'package:car_rental_app/features/auth/Presentation/screens/phone_auth_screen.dart';
import 'package:car_rental_app/features/auth/Presentation/screens/signup_screen.dart';
import 'package:car_rental_app/features/auth/Presentation/screens/verify_otp_screen.dart';
import 'package:car_rental_app/features/bookings/data/models/RentalWithCarDto.dart';
import 'package:car_rental_app/features/bookings/presentation/customer/screens/bookings_screen.dart';
import 'package:car_rental_app/features/bookings/presentation/customer/blocs/date_picker_bloc/date_picker_bloc.dart';
import 'package:car_rental_app/features/bookings/presentation/customer/screens/book_rental_car_screen.dart';
import 'package:car_rental_app/features/chat/domain/entities/conversation_model.dart';
import 'package:car_rental_app/features/chat/presentation/chat_bloc/chat_bloc.dart';
import 'package:car_rental_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:car_rental_app/features/home/Presentation/customer/screens/car_detail_screen.dart';
import 'package:car_rental_app/features/home/Presentation/customer/screens/customer_home_screen.dart';
import 'package:car_rental_app/features/bookings/presentation/customer/screens/map_screen.dart';
import 'package:car_rental_app/features/home/Presentation/seller/blocs/add_listing_bloc/add_listing_bloc.dart';
import 'package:car_rental_app/features/home/Presentation/seller/screens/add_car_listing_screen.dart';
import 'package:car_rental_app/features/home/Presentation/seller/screens/seller_home_screen.dart';
import 'package:car_rental_app/features/home/domain/entities/car_model.dart';
import 'package:car_rental_app/features/payment/presentation/screens/add_payment_card_screen.dart';
import 'package:car_rental_app/features/payment/presentation/screens/payment_method_screen.dart';
import 'package:car_rental_app/features/reviews/presentation/review_cubit/review_cubit.dart';
import 'package:car_rental_app/features/reviews/presentation/screens/review_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_rental_app/features/bookings/presentation/customer/blocs/book_rental_cubit/book_rental_cubit.dart';
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
  static const String review = "/review";
  static const String paymentMethod = "/payment-method";
  static const String addPaymentCard = "/add-payment-card";

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
}

final List<RouteBase> kappRoutes = [
  GoRoute(path: AppRoutes.signup, builder: (context, state) => SignupScreen()),
  GoRoute(path: AppRoutes.login, builder: (context, state) => LoginScreen()),

  GoRoute(path: AppRoutes.paymentMethod, builder: (context, state) {
    final map = state.extra as Map<String,dynamic>;
    final bookRentalCubit = map["bookRentalCubit"] as BookRentalCubit;
    final carModel = map["carModel"] as CarModel;
    return PaymentMethodScreen(bookRentalCubit: bookRentalCubit,carModel: carModel); 
  }),
  GoRoute(
    path: AppRoutes.customerHome,
    builder: (context, state) => CustomerHomeScreen(),
  ),
  GoRoute(
    path: AppRoutes.addPaymentCard,
    builder: (context, state) => AddPaymentCardScreen(),
  ),
  GoRoute(
    path: AppRoutes.verified,
    builder: (context, state) => CustomerHomeScreen(),
  ),
  GoRoute(
    path: AppRoutes.review,
    builder: (context, state) {
      final extra = state.extra as Rentalwithcardto;
      return ReviewScreen(rental: extra);
    } ,
  ),
  GoRoute(
    path: AppRoutes.chat,
    builder: (context, state) {
      final extra = state.extra;
      final map = extra is Map<String, dynamic> ? extra : null;
      final conversationModel = map?['conversationModel'] as ConversationModel?;

      if (conversationModel == null) {
        return const SizedBox.shrink();
      }

      return BlocProvider(
        create: (context) {
          final bloc = ChatBloc()
            ..add(ChatMessagesSubscribed(conversationId: conversationModel.id));
          return bloc;
        },
        child: ChatScreen(conversationModel: conversationModel),
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
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => DatePickerBloc()),
          BlocProvider(create: (context) => ReviewCubit()..fetchReviews(model.id)),
        ],
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
