import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:car_rental_app/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, this.conversationId});

  final String? conversationId;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const SizedBox(height: 10),
      // const ChatDayDivider(label: "Today"),
      const SizedBox(height: 16),
      const ChatMessageBubble(
        message: "Hi Karen, Ciara here!",
        timeText: "9:25 am",
        isMe: false,
      ),
      const SizedBox(height: 14),
      const ChatMessageBubble(
        message: "Hey Jana, nice to meet you!",
        timeText: "10:15 am",
        isMe: true,
      ),
      const SizedBox(height: 14),
      const ChatMessageBubble(
        message: "Nice to meet you too! How are you doing?",
        timeText: "10:25 am",
        isMe: false,
      ),
      const SizedBox(height: 14),
      const ChatMessageBubble(
        message: "All good. I’m browsing cars for the weekend.",
        timeText: "10:45 am",
        isMe: true,
      ),
      const SizedBox(height: 18),
    ];

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
          CircleAvatar(radius: 25, backgroundImage: AssetImage("assets/images/profile.jpg")),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "John Doe",
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
                  child: ListView(
                    padding: const EdgeInsets.only(top: 120),
                    children: items,
                  ),
                ),
                const ChatInputBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
