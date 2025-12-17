import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileSectionCard extends StatelessWidget {
  const ProfileSectionCard({
    super.key,
    required this.title,
    required this.children,
    this.isLoading = false
  });

  final String title;
  final List<Widget> children;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return isLoading ? 
      Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12)
          ),
        ),
        )
     : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
                  decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)
      ),
            child: Column(
              children: children
                  .expand((w) => [
                        w,
                        const SizedBox(height: 10),
                      ])
                  .toList()
                ..removeLast(),
            ),
          ),
        ],
      
    );
  }
}
