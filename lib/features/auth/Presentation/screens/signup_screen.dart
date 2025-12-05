import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/features/auth/data/services/auth_service.dart';
import 'package:car_rental_app/features/auth/Presentation/widgets/action_button.dart';
import 'package:car_rental_app/features/auth/Presentation/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              SizedBox(
                // width: double.infinity,
                // color: Colors.red,
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 250,
                  height: 85,
                  fit: BoxFit.cover,
                  ),
              ),
              const SizedBox(height: 20,),
              Text("Let's create your account",style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
              ),),
              Text("Tag along with our 100,000+ users today",style: TextStyle(
                fontSize: 16,
                // fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
                letterSpacing: 0,
                
              ),),
              const SizedBox(height: 35,),
              CustomTextfield(
                controller: _emailController,
                cursorColor: AppColors.textPrimary,
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
                obscureText: false,
              ),
              const SizedBox(height: 15,),
              CustomTextfield(
                controller: _passwordController,
                cursorColor: AppColors.textPrimary,
                hintText: "Enter your password",
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: Icons.lock_outline,
                obscureText: false,
              ),
            const SizedBox(height: 20,),
             SizedBox(
               width: double.infinity,
               child: ActionButton(
                label: "Create Account",
                onPressed: () async {
                  print("click");
                  final res = await AuthService.signUpWithEmail(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(res.message),
                      backgroundColor: res.success ? Colors.green : Colors.red,
                    ),
                  );
                },
               ),
             ),
             const SizedBox(height: 8,),
             Row(
              children: [
                Expanded(
                child: Divider(color: Colors.grey.shade800,),
                
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:  8.0),
                child: Text("or"),
              ),
              Expanded(
                child: Divider(color: Colors.grey.shade800,),
                
              ),
              ] 
             ),
             const SizedBox(height: 10,),
             SizedBox(
              width: double.infinity,
              child: ActionButton(
                isDense: true,
                label: "Sign Up with Apple",
                imagePath: "assets/icons/apple.png",
                backgroundColor: Colors.black,
                 onPressed: (){}
                 ),
                ),
                const SizedBox(height: 10,),
              SizedBox(
              width: double.infinity,
              child: ActionButton(
                isDense: true,
                label: "Continue with Phone",
                imagePath: "assets/icons/phone.png",
                backgroundColor: Colors.black,
                 onPressed: (){
                  context.push(
                    AppRoutes.phoneAuth
                  );
                 }
                 ),
                ),
              const SizedBox(height: 5,),
              PlatformTextButton(
                child:  Text("Already have an account?"),
                onPressed: () {
                  context.go("/login");
                },
                )
            ],
          ),
        ),
      )
    );
  }
}
