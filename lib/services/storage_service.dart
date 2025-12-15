import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    'dfx6dw55x',
    'boi_binimoy_preset',
    cache: false,
  );

  // Upload multiple images and return their URLs
  Future<List<String>> uploadBookImages({
    required String bookId,
    required List<XFile> imageFiles,
  }) async {
    List<String> downloadUrls = [];

    try {
      for (int i = 0; i < imageFiles.length; i++) {
        final file = imageFiles[i];
        final bytes = await file.readAsBytes();

        // Upload to Cloudinary
        CloudinaryResponse response = await _cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(
            bytes,
            identifier: 'book_${bookId}_image_$i',
            folder: 'books/$bookId',
            resourceType: CloudinaryResourceType.Image,
          ),
        );

        downloadUrls.add(response.secureUrl);
      }

      return downloadUrls;
    } catch (e) {
      throw Exception('Error uploading images: $e');
    }
  }

  // Delete images (Cloudinary deletion requires API key, this is optional)
  Future<void> deleteBookImages(String bookId) async {
    // Cloudinary public package doesn't support deletion
    // Deletion requires using admin API with api_key and api_secret
    // For now, images will remain in Cloudinary
    print('Image deletion not implemented for Cloudinary public API');
  }
}
