import 'dart:io';
import 'package:flutter/material.dart';

class ImageGridView extends StatelessWidget {
  final List<File> capturedImages; // List of captured images
  final ScrollController controller; // Scroll controller for lazy loading

  const ImageGridView({
    super.key,
    required this.capturedImages,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return capturedImages.isEmpty
        ? const Center(child: Text('No images captured yet.'))
        : GridView.builder(
            controller: controller, // Assign scroll controller
            itemCount: capturedImages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemBuilder: (context, index) {
              final file = capturedImages[index];

              // Check if the file exists before rendering
              if (file.existsSync() && file.lengthSync() > 0) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      file,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              } else {
                // Placeholder for empty files
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                );
              }
            },
          );
  }
}
