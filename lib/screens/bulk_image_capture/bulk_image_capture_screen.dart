import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnb_task/provider/bulk_image_provider.dart';
import '../../widgets/image_grid_view.dart';

class BulkImageCaptureScreen extends ConsumerStatefulWidget {
  const BulkImageCaptureScreen({super.key});

  @override
  _BulkImageCaptureScreenState createState() => _BulkImageCaptureScreenState();
}

class _BulkImageCaptureScreenState extends ConsumerState<BulkImageCaptureScreen> {
  int _numberOfImages = 1; // Number of images to capture
  bool _isCapturing = false; // State to indicate capturing process
  final ScrollController _scrollController = ScrollController(); // Controller for scroll events
  int _loadedImageCount = 10; // Initial count of loaded images

  @override
  void initState() {
    super.initState();
    _loadInitialImages(); // Load initial images
    _scrollController.addListener(_onScroll); // Add scroll listener
  }

  // Load the initial set of images
  void _loadInitialImages() async {
    await ref.read(bulkImageProvider.notifier).loadImages(limit: _loadedImageCount);
  }

  // Handle scroll events to load more images
  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreImages(); // Load more images when reaching the bottom
    }
  }

  // Load more images when scrolling down
  void _loadMoreImages() async {
    setState(() {
      _loadedImageCount += 10; // Increment the loaded image count
    });
    await ref.read(bulkImageProvider.notifier).loadImages(limit: 10, offset: _loadedImageCount);
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<File> capturedImages = ref.watch(bulkImageProvider); // Watch the provider for captured images

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk Image Capture'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Number of images:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                DropdownButton<int>(
                  value: _numberOfImages, // Selected number of images
                  items: List.generate(10, (index) => index + 1)
                      .map((e) => DropdownMenuItem<int>(
                            value: e,
                            child: Text(e.toString(),
                                style: const TextStyle(fontSize: 16)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _numberOfImages = value!; // Update number of images
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Show a loading indicator while capturing images
            _isCapturing
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                    onPressed: () async {
                      setState(() => _isCapturing = true); // Start capturing
                      await ref.read(bulkImageProvider.notifier).captureAndSaveImages(_numberOfImages);
                      setState(() => _isCapturing = false); // End capturing
                    },
                    icon: const Icon(Icons.camera_alt, color: Colors.teal),
                    label: const Text('Capture Images',
                        style: TextStyle(fontSize: 16, color: Colors.teal)),
                  ),
            const SizedBox(height: 20),

            // Display captured images in a grid view
            Expanded(
              child: ImageGridView(
                capturedImages: capturedImages,
                controller: _scrollController, // Pass scroll controller
              ),
            ),
          ],
        ),
      ),
    );
  }
}
