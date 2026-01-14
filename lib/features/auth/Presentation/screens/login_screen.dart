import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/features/auth/Presentation/auth_cubit/auth_cubit.dart';
import 'package:car_rental_app/core/widgets/action_button.dart';
import 'package:car_rental_app/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: Material(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(
                  // width: double.infinity,
                  // color: Colors.red,
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 250,
                    height: 85,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                ),
                Text(
                  "Login to continue your journey",
                  style: TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 35),
                CustomTextfield(
                  controller: _emailController,
                  cursorColor: AppColors.textPrimary,
                  hintText: "Enter your email",
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                CustomTextfield(
                  controller: _passwordController,
                  cursorColor: AppColors.textPrimary,
                  hintText: "Enter your password",
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<AuthCubit, AuthState>(
                    buildWhen: (previous, current) => previous.isLoading != current.isLoading,
                    builder: (context, state) {
                      return SizedBox(
                        child: ActionButton(
                          isLiquidGlass: true,
                          liquidGlasMinimumSize: Size(200, 45),
                          useSmoothRectangleBorder: false,
                          liquidGlassStyle: AdaptiveButtonStyle.prominentGlass,
                          isLoading: state.isLoading,
                          label: "Login",
                          onPressed: () async {
                            await context.read<AuthCubit>().signInWithEmail(
                              context,
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade800)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("or"),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade800)),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ActionButton(
                    isLiquidGlass: true,
                    isDense: true,
                    liquidGlassSize: AdaptiveButtonSize.large,
                    label: "Sign In with Apple",
                    imagePath: "assets/icons/apple.png",
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    useSmoothRectangleBorder: false,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ActionButton(
                    isLiquidGlass: true,
                    isDense: true,
                    liquidGlassSize: AdaptiveButtonSize.large,
                    label: "Sign In with Phone",
                    imagePath: "assets/icons/phone.png",
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    useSmoothRectangleBorder: false,
                    onPressed: () {
                      context.push(AppRoutes.phoneAuth);
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        context.go(AppRoutes.signup);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
