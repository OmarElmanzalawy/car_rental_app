import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        leading: Row(
          children: [
            const SizedBox(width: 12,),
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/images/profile.jpg"),
            ),
            SizedBox(width: 5,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("John Doe",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                Text("online"),
              ],
            )
          ],
        ),
        actions: [
          AdaptiveAppBarAction(
            onPressed: (){
              
            },
            iosSymbol: "ellipsis",
            icon: Icons.more_horiz
            )
        ]
      ),
      body: Container(),
    );
  }
}