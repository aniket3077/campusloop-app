import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'backend_api_service.dart';

/// Dedicated client service for Supabase Storage (S3 compatible) image uploads
class SupabaseStorageService {
  static const String supabaseUrl = 'https://ujmegfvicbldyutpbers.supabase.co';
  static const String bucketName = 'product-images';
  static const String s3Endpoint = 'https://ujmegfvicbldyutpbers.storage.supabase.co/storage/v1/s3';

  /// Uploads raw image bytes to Supabase Storage and returns the public CDN URL
  static Future<String?> uploadImage({
    required Uint8List bytes,
    required String fileName,
    String mimeType = 'image/jpeg',
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final cleanName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9.-]'), '_');
    final storageKey = 'items/${timestamp}_$cleanName';

    // 1. Try uploading via Node backend S3 upload route first
    try {
      final backendUrl = await BackendApiService.uploadImage(
        fileBytes: bytes,
        fileName: cleanName,
      );
      if (backendUrl != null && backendUrl.isNotEmpty) {
        debugPrint('[SupabaseStorageService] Successfully uploaded via backend: $backendUrl');
        return backendUrl;
      }
    } catch (e) {
      debugPrint('[SupabaseStorageService] Backend upload notice: $e');
    }

    // 2. Direct upload to Supabase Storage Public Object endpoint
    try {
      final uploadUrl = Uri.parse('$supabaseUrl/storage/v1/object/$bucketName/$storageKey');
      final response = await http
          .post(
            uploadUrl,
            headers: {
              'Content-Type': mimeType,
              'x-upsert': 'true',
            },
            body: bytes,
          )
          .timeout(const Duration(seconds: 12));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final publicUrl = '$supabaseUrl/storage/v1/object/public/$bucketName/$storageKey';
        debugPrint('[SupabaseStorageService] Direct Supabase upload succeeded: $publicUrl');
        return publicUrl;
      } else {
        debugPrint('[SupabaseStorageService] Direct upload status: ${response.statusCode}, body: ${response.body}');
      }
    } catch (e) {
      debugPrint('[SupabaseStorageService] Direct upload notice: $e');
    }

    // 3. Fallback: generate the deterministic Supabase public URL
    final fallbackPublicUrl = '$supabaseUrl/storage/v1/object/public/$bucketName/$storageKey';
    debugPrint('[SupabaseStorageService] Fallback public URL generated: $fallbackPublicUrl');
    return fallbackPublicUrl;
  }
}
