import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/features/auth/data/services/auth_service.dart';
import 'package:car_rental_app/features/profile/presentation/cubit/customer_profile_cubit.dart';
import 'package:car_rental_app/features/profile/presentation/widgets/profile_avatar_editor.dart';
import 'package:car_rental_app/features/profile/presentation/widgets/profile_info_row.dart';
import 'package:car_rental_app/features/profile/presentation/widgets/profile_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AdaptiveScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  "Profile",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const SizedBox(height: 16),
                Center(
                  child:
                      BlocBuilder<CustomerProfileCubit, CustomerProfileState>(
                        buildWhen: (previous, current) =>
                            previous.profilePictureUrl !=
                                current.profilePictureUrl ||
                            previous.isFetchingProfilePicture !=
                                current.isFetchingProfilePicture,
                        builder: (context, state) {
                          return state.isFetchingProfilePicture
                              ? ProfileAvatarEditor(
                                  isFetchingProfilePicture: true,
                                )
                              : ProfileAvatarEditor(
                                  imageUrl: state.profilePictureUrl,
                                );
                        },
                      ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<CustomerProfileCubit, CustomerProfileState>(
                  buildWhen: (previous, current) =>
                      previous.displayName != current.displayName ||
                      previous.email != current.email ||
                      previous.phoneNumber != current.phoneNumber ||
                      previous.isLoading != current.isLoading,
                  builder: (context, state) {
                    return ProfileSectionCard(
                      title: "Basic Details",
                      children: [
                        ProfileInfoRow(
                          label: "Name",
                          value: state.displayName ?? "N/A",
                          noBackgroundColor: true,
                        ),
                        ProfileInfoRow(
                          label: "Email",
                          value: state.email ?? "N/A",
                          noBackgroundColor: true,
                        ),
                        ProfileInfoRow(
                          label: "Phone Number",
                          value: state.phoneNumber ?? "N/A",
                          noBackgroundColor: true,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                ProfileSectionCard(
                  title: "Preferences",
                  children: [
                    ProfileInfoRow(
                      label: "Dark Mode",
                      showChevron: false,
                      trailing: AdaptiveSwitch(
                        value: isDarkMode,
                        onChanged: (value) {
                          setState(() {
                            isDarkMode = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ProfileSectionCard(
                  title: "Legal",
                  children: const [
                    ProfileInfoRow(label: "Terms and Agreements"),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: size.width,
                  child: AdaptiveButton(
                    style: AdaptiveButtonStyle.prominentGlass,
                    textColor: Colors.white,
                    minSize: Size(size.width * 0.5, 44),
                    color: AppColors.primary,
                    onPressed: () async {
                      final response = await AuthService.signOut();
                      if (!mounted) return;
                      if (response.success) {
                        context.go(AppRoutes.login);
                      }
                    },
                    label: "Log out",
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
