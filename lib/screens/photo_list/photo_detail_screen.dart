import 'dart:ui';
import 'package:flutter/material.dart';
import '../../model/photo.dart';
import '../../widgets/network_image_with_fade_in.dart.dart';

class PhotoDetailScreen extends StatelessWidget {
  final Photo photo; // Holds the photo object

  const PhotoDetailScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark; // Check if dark mode is active

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Text(
          photo.title, // Display photo title in app bar
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Rounded corners for image
                    child: NetworkImageWithFadeIn(
                      imageUrl: photo.url, // Display photo image
                      width: double.infinity,
                      height: 300,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15), // Rounded corners for text container
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5.0,
                          sigmaY: 5.0,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.black.withOpacity(0.7) // Background color for dark mode
                                : Colors.white.withOpacity(0.7), // Background color for light mode
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: isDarkMode
                                    ? Colors.black26
                                    : Colors.black12,
                                blurRadius: 10.0,
                                offset: const Offset(0.0, 2.0),
                              ),
                            ],
                          ),
                          child: Text(
                            photo.title, // Display photo title
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black, // Text color based on theme
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Photo ID: ${photo.id}', // Display photo ID
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
