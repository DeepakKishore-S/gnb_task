import 'package:flutter/material.dart';

class NetworkImageWithFadeIn extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const NetworkImageWithFadeIn({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeInImage.assetNetwork(
        placeholder: 'assets/images/image_placeholder.png', // Placeholder image
        image: imageUrl, // Image URL
        width: width,
        height: height,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(seconds: 1), // Fade-in duration
        fadeOutDuration: const Duration(milliseconds: 300), // Fade-out duration
      ),
    );
  }
}
