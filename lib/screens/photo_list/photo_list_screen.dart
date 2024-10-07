import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnb_task/screens/bulk_image_capture/bulk_image_capture_screen.dart';
import 'package:gnb_task/screens/profile/profile_screen.dart';
import '../../core/utils/route_helper.dart';
import '../../model/photo.dart';
import '../../provider/photo_provider.dart';
import '../../widgets/network_image_with_fade_in.dart.dart';
import '../settings/settings.dart';
import 'photo_detail_screen.dart';

class PhotoListScreen extends ConsumerStatefulWidget {
  const PhotoListScreen({super.key});

  @override
  _PhotoListScreenState createState() => _PhotoListScreenState();
}

class _PhotoListScreenState extends ConsumerState<PhotoListScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isFetching = false; // Flag to indicate loading state
  String? _errorMessage; // Holds error messages

  @override
  void initState() {
    super.initState();
    _loadMorePhotos(); // Load initial photos

    // Add scroll listener to fetch more photos on scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isFetching) {
        _loadMorePhotos();
      }
    });
  }

  // Function to fetch more photos
  void _loadMorePhotos() {
    setState(() {
      _isFetching = true; // Set loading state
      _errorMessage = null; // Clear previous error
    });

    ref.read(photoProvider.notifier).fetchPhotos().then((_) {
      setState(() {
        _isFetching = false; // Reset loading state
      });
    }).catchError((error) {
      setState(() {
        _isFetching = false; // Reset loading state on error
        _errorMessage = error.toString(); // Capture error message
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of the scroll controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Photo> photos = ref.watch(photoProvider); // Watch photo list

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo List'),
        backgroundColor: Colors.teal,
        actions: [
          // Navigation buttons for various screens
          IconButton(
            icon: const Icon(Icons.camera),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const BulkImageCaptureScreen(),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserProfileScreen(),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ));
            },
          ),
        ],
      ),
      body: _errorMessage != null
          ? _buildErrorState() // Show error state if there's an error
          : photos.isEmpty && !_isFetching
              ? const Center(child: Text('No photos available.')) // Show message if no photos
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: photos.length + (_isFetching ? 1 : 0), // Adjust item count for loading indicator
                  itemBuilder: (context, index) {
                    if (index < photos.length) {
                      return _buildPhotoTile(context, photos[index]); // Build photo tile
                    } else {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(), // Show loading indicator
                        ),
                      );
                    }
                  },
                ),
    );
  }

  // Build individual photo tile
  Widget _buildPhotoTile(BuildContext context, Photo photo) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark; // Check for dark mode

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(createRoute(
            page: PhotoDetailScreen(photo: photo), // Navigate to photo detail screen
            beginOffset: const Offset(0.0, 1.0),
          ));
        },
        child: Card(
          color: isDarkMode ? Colors.grey[850] : Colors.white, // Card color based on theme
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                NetworkImageWithFadeIn(
                  imageUrl: photo.thumbnailUrl, // Display photo thumbnail
                  width: 60,
                  height: 60,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    photo.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Handle long titles
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black, // Text color based on theme
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build error state UI
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? 'An error occurred', // Display error message
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _loadMorePhotos(); // Retry fetching photos
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
