import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/features/chat/presentation/chat_bloc/chat_bloc.dart';
import 'package:car_rental_app/features/chat/presentation/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  late final ChatBloc _chatBloc;

  @override
  void initState() {
    super.initState();
    _chatBloc = ChatBloc()..add(const LoadConversationsRequested());
  }

  @override
  void dispose() {
    _chatBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    return BlocProvider.value(
      value: _chatBloc,
      child: AdaptiveScaffold(
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
                  const SizedBox(height: 50),
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
                    child: BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        if (state is ChatConversationsLoading ||
                            state is ChatInitial) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }

                        if (state is ChatConversationsFailure) {
                          return Center(
                            child: Text(
                              state.message,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }

                        if (state is! ChatConversationsLoaded) {
                          return const SizedBox.shrink();
                        }

                        final conversations = state.conversations;

                        if (conversations.isEmpty) {
                          return const Center(
                            child: Text(
                              "No conversations yet",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: conversations.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final c = conversations[index];
                            final otherUserId =
                                currentUserId == null || c.user1 == currentUserId
                                    ? c.user2
                                    : c.user1;
                            final timeText = AppUtils.toDayMonth(c.updatedAt);
                            return ChatUserCard(
                              name: otherUserId,
                              lastMessage: "Tap to open chat",
                              timeText: timeText,
                              avatarImage: const AssetImage(
                                "assets/images/profile.jpg",
                              ),
                              isOnline: false,
                              unreadCount: 0,
                              onTap: () {
                                context.push(
                                  AppRoutes.chat,
                                  extra: {"conversationId": c.id},
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
