import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/core/services/dialogue_service.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/features/chat/domain/entities/conversation_model.dart';
import 'package:car_rental_app/features/chat/domain/entities/message_model.dart';
import 'package:car_rental_app/features/chat/presentation/chat_bloc/chat_bloc.dart';
import 'package:car_rental_app/features/chat/presentation/widgets/booking_request_card.dart';
import 'package:car_rental_app/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:car_rental_app/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:car_rental_app/features/chat/presentation/widgets/info_message_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.conversationModel});

  final ConversationModel conversationModel;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    print(conversationModel.otherUserName ?? "not found");
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
       leading: IntrinsicWidth(
         child: Row(
               children: [
          AdaptiveButton.icon(
            onPressed: (){context.pop();},
             icon: Icons.arrow_back_ios_new,
              color: AppColors.silverAccent,
              iconColor: Colors.black,
              style: AdaptiveButtonStyle.glass,
              minSize: Size(35, 35),
              size: AdaptiveButtonSize.small,
             ),
             const SizedBox(width: 8,),
          CircleAvatar(radius: 25, backgroundImage: conversationModel.otherUserProfileImage != null ? NetworkImage(conversationModel.otherUserProfileImage!) : AssetImage("assets/images/profile.jpg")),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  conversationModel.otherUserName ?? "receiver name",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.green.shade500,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "online",
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
               ],
             ),
       ),
        actions: [
          AdaptiveAppBarAction(
            onPressed: () {},
            iosSymbol: "ellipsis",
            icon: Icons.more_horiz,
          ),
        ],
      ),
      body: Material(
        child: Container(
          color: AppColors.background,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Expanded(
                  child: Builder(
                    builder: (context) {
                      return BlocConsumer<ChatBloc, ChatState>( 
                        listenWhen: (previous, current) =>
                            current is ChatBookingActionSuccess ||
                            current is ChatBookingActionFailure,
                        listener: (context, state) {
                          if (state is ChatBookingActionSuccess) {
                            final label = state.status == RentalStatus.approved
                                ? 'Booking approved'
                                : 'Booking rejected';
                            AdaptiveSnackBar.show(
                              context,
                              message: label,
                              type: AdaptiveSnackBarType.info,
                              );
                          }
                          if (state is ChatBookingActionFailure) {
                          }
                        },
                        buildWhen: (previous, current) =>
                            current is ChatMessagesLoading ||
                            current is ChatMessagesLoaded ||
                            current is ChatMessagesFailure ||
                            current is ChatInitial ||
                            current is ChatInitiationLoading,
                        builder: (context, state) {
                          if (state is ChatMessagesLoading ||
                              state is ChatInitial ||
                              state is ChatInitiationLoading) {
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          }

                          if (state is ChatMessagesFailure) {
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

                          if (state is! ChatMessagesLoaded) {
                            return const SizedBox.shrink();
                          }

                          final messages = state.messages;

                          if (messages.isEmpty) {
                            return const Center(
                              child: Text(
                                'No messages yet',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.only(top: 120),
                            itemCount: messages.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              final m = messages[index];
                              final isMe = currentUserId != null &&
                                  m.senderId == currentUserId;
                              return m.messageType == MessageType.bookingRequest
                                  ?  BookingRequestCard(messageModel: m)
                                  : m.messageType == MessageType.info ? 
                                  InfoMessageCard(label: m.content)
                                  : ChatMessageBubble(
                                      message: m.content,
                                      timeText: AppUtils.toReadableTime(m.createdAt),
                                      isMe: isMe,
                                    );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                ChatInputBar(
                  controller: controller,
                  onSubmit: () {
                    if (controller.text.isEmpty) {
                      return;
                    }

                    final messageModel = MessageModel(
                      id: Uuid().v4(),
                      conversationId: conversationModel.id,
                      senderId: Supabase.instance.client.auth.currentUser!.id,
                      messageType: MessageType.text,
                      content: controller.text,
                      createdAt: DateTime.now()
                    );

                    context.read<ChatBloc>().add(
                          SendMessageEvent(
                           messageModel: messageModel,
                          ),
                        );
                    controller.clear();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
