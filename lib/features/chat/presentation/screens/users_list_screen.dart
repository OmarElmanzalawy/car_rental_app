import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/features/chat/presentation/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      (
        name: "Charlotte",
        lastMessage: "Hey, can we confirm the pickup time?",
        timeText: "29 Jun",
        isOnline: true,
        unreadCount: 2,
      ),
      (
        name: "Arafat Khan",
        lastMessage: "Thanks! I’ll take it for 3 days.",
        timeText: "28 Jun",
        isOnline: true,
        unreadCount: 0,
      ),
      (
        name: "Ajoy Mondal",
        lastMessage: "Is the car available this weekend?",
        timeText: "26 Jun",
        isOnline: false,
        unreadCount: 0,
      ),
      (
        name: "Patricia",
        lastMessage: "Got it, I’ll send the details now.",
        timeText: "24 Jun",
        isOnline: false,
        unreadCount: 1,
      ),
      (
        name: "Isabella",
        lastMessage: "Perfect. See you soon!",
        timeText: "20 Jun",
        isOnline: true,
        unreadCount: 0,
      ),
      (
        name: "John Mendala",
        lastMessage: "Thank you.",
        timeText: "20 Jun",
        isOnline: false,
        unreadCount: 0,
      ),
    ];

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: "  Messages  ",
        actions: [
          AdaptiveAppBarAction(
            onPressed: () {},
            iosSymbol: "ellipsis",
            icon: Icons.more_horiz,
          ),
        ],
      ),
      body: Container(
        color: AppColors.background,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              children: [
                const SizedBox(height: 50,),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: AppColors.textSecondary),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Search here",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: users.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final u = users[index];
                      return ChatUserCard(
                        name: u.name,
                        lastMessage: u.lastMessage,
                        timeText: u.timeText,
                        avatarImage: const AssetImage(
                          "assets/images/profile.jpg",
                        ),
                        isOnline: u.isOnline,
                        unreadCount: u.unreadCount,
                        onTap: () {},
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
