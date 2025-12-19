import 'dart:io';

import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddListingImagesStep extends StatelessWidget {
  const AddListingImagesStep({
    super.key,
    required this.pickedImages,
    required this.onAddImages,
    required this.onRemovePickedImage,
    required this.thumbnailImage,
    required this.onPickThumbnail,
    required this.onRemoveThumbnail,
  });

  final XFile? thumbnailImage;
  final List<XFile> pickedImages;
  final VoidCallback onAddImages;
  final ValueChanged<int> onRemovePickedImage;
  final VoidCallback onPickThumbnail;
  final VoidCallback onRemoveThumbnail;

  @override
  Widget build(BuildContext context) {
    final gridItemCount =
        (pickedImages.length + 1);
           

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            "Upload Images",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            "Add clear photos of your vehicle. You can upload multiple images.",
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          const SizedBox(height: 16),
          const Text(
            "Thumbnail (optional)",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: thumbnailImage == null ? onPickThumbnail : null,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (thumbnailImage != null)
                      Image.file(
                        File(thumbnailImage!.path),
                        fit: BoxFit.cover,
                      )
                    else
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            color: AppColors.primary,
                            size: 26,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Pick thumbnail",
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    if (thumbnailImage != null)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    if (thumbnailImage != null)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: onRemoveThumbnail,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Best if it is a PNG image.",
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: gridItemCount,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _AddImageTile(onTap: onAddImages);
              }

              // if (showPickedImages) {
                final picked = pickedImages[index - 1];
                final imageWidget =
                    Image.file(File(picked.path), fit: BoxFit.cover);

                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      imageWidget,
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: () => onRemovePickedImage(index - 1),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              // }

              // final path = imagePlaceholders[index - 1];
              // return ClipRRect(
              //   borderRadius: BorderRadius.circular(12),
              //   child: Stack(
              //     fit: StackFit.expand,
              //     children: [
              //       Image.asset(path, fit: BoxFit.cover),
              //       Container(
              //         decoration: BoxDecoration(
              //           gradient: LinearGradient(
              //             begin: Alignment.bottomCenter,
              //             end: Alignment.topCenter,
              //             colors: [
              //               Colors.black.withValues(alpha: 0.4),
              //               Colors.transparent,
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _AddImageTile extends StatelessWidget {
  const _AddImageTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, color: AppColors.primary),
            const SizedBox(height: 6),
            Text(
              "Add",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
