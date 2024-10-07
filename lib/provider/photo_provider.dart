import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../model/photo.dart';

// Notifier for managing photo state
class PhotoNotifier extends StateNotifier<List<Photo>> {
  PhotoNotifier() : super([]); // Initializes state as an empty list

  final Dio _dio = Dio(); // Dio instance for making HTTP requests
  bool _isLoading = false; // Track loading state
  int _page = 1; // Current page for pagination
  final int _limit = 10; // Number of items per page

  // Fetch photos from API
  Future<void> fetchPhotos() async {
    if (_isLoading) return; // Prevent duplicate requests
    _isLoading = true;

    // Check internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    print("connectin =============$connectivityResult");
    if (connectivityResult.first == ConnectivityResult.none) {
      throw Exception('No Internet Connection'); // Throw exception if no connectivity
    }

    try {
      // Make a GET request to the API
      final response = await _dio.get(
        'https://jsonplaceholder.typicode.com/photos',
        queryParameters: {'_page': _page, '_limit': _limit},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        // Map the response to a list of Photo objects
        List<Photo> newPhotos =
            data.map((json) => Photo.fromJson(json)).toList();
        state = [...state, ...newPhotos]; // Update the state with new photos
        _page++; // Increment page number for next fetch
      }
    } catch (e) {
      print('Failed to fetch photos: $e');
      throw Exception('Failed to fetch photos'); 
    } finally {
      _isLoading = false; // Reset loading state
    }
  }
}

// Provider for accessing PhotoNotifier
final photoProvider = StateNotifierProvider<PhotoNotifier, List<Photo>>(
  (ref) => PhotoNotifier(),
);
