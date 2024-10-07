import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

// Notifier for managing bulk image capture and storage
class BulkImageNotifier extends StateNotifier<List<File>> {
  BulkImageNotifier() : super([]); // Initializes state as an empty list

  final ImagePicker _picker = ImagePicker(); 

  // Capture and save a specified number of images
  Future<void> captureAndSaveImages(int numberOfImages) async {
    List<File> savedImages = []; // List to hold successfully saved images
    for (int i = 0; i < numberOfImages; i++) {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        // Save the picked image to local storage
        final File? savedImage =
            await _saveImageToLocalStorage(File(image.path));
        if (savedImage != null && await savedImage.length() > 0) {
          savedImages.add(savedImage); 
        }
      }
    }
    state = [...state, ...savedImages]; // Update state with new images
  }

  // Save image to local storage
  Future<File?> _saveImageToLocalStorage(File image) async {
    try {
      if (await image.length() == 0) {
        print('File is empty and will not be saved: ${image.path}');
        return null; // Return null if the file is empty
      }

      // Get application documents directory
      final directory = await getApplicationDocumentsDirectory();
      final imagesDirectory = Directory('${directory.path}/images');

      // Create images directory if it does not exist
      if (!await imagesDirectory.exists()) {
        await imagesDirectory.create(recursive: true);
      }

      // Generate a unique image path
      final imagePath = path.join(
          imagesDirectory.path, '${DateTime.now().millisecondsSinceEpoch}.png');
      final File localImage = await image.copy(imagePath); 
      return localImage; 
    } catch (e) {
      print('Error saving image to local storage: $e');
      return null; 
    }
  }

  // Load images from local storage with optional pagination
  Future<void> loadImages({int limit = 10, int offset = 0}) async {
    try {
      // Get application documents directory
      final directory = await getApplicationDocumentsDirectory();
      final imagesDirectory = Directory('${directory.path}/images');

      // Check if images directory exists
      if (!await imagesDirectory.exists()) {
        print("Images directory does not exist.");
        return;
      }

      // Load files from the images directory
      final List<FileSystemEntity> files =
          await imagesDirectory.list().toList();
      final List<File> images = files
          .whereType<File>() // Filter for files
          .where((file) {
            // Check file extension
            final extension = file.path.split('.').last.toLowerCase();
            return ['jpg', 'jpeg', 'png', 'gif'].contains(extension);
          })
          .skip(offset) // Skip files based on offset
          .take(limit) // Limit the number of files
          .map((file) => File(file.path)) // Convert to File
          .toList();

      print("Loaded images: $images");
      state = images; // Update state with loaded images
    } catch (e) {
      print("Error loading images: $e"); 
    }
  }
}

// Provider for accessing BulkImageNotifier
final bulkImageProvider = StateNotifierProvider<BulkImageNotifier, List<File>>(
  (ref) => BulkImageNotifier(),
);
