import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/manga.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:5000/api';
  static const Duration timeout = Duration(seconds: 30);

  // ============ MANGA ENDPOINTS ============

  static Future<List<Manga>> getAllManga() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/manga'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];
        return data.map((item) => Manga.fromApiJson(item)).toList();
      } else {
        throw Exception('Failed to load manga: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Error: $e', name: 'ApiService');
      rethrow;
    }
  }

  static Future<List<Manga>> searchManga(String query) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/manga/search?q=$query'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];
        return data.map((item) => Manga.fromApiJson(item)).toList();
      } else {
        throw Exception('Search failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Manga> getMangaDetail(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/manga/$id'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return Manga.fromApiJson(jsonData['data']);
      } else {
        throw Exception('Manga not found');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Manga>> getMangaByGenre(List<String> genres) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/manga'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];

        return data
            .map((item) => Manga.fromApiJson(item))
            .where(
              (manga) => genres.every((genre) => manga.genre.contains(genre)),
            )
            .toList();
      } else {
        throw Exception('Failed to load by genre');
      }
    } catch (e) {
      rethrow;
    }
  }

  // ============ BOOKMARK ENDPOINTS ============

  static Future<void> addBookmark(Manga manga) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/bookmark'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'manga_id': manga.id,
              'title': manga.title,
              'image_url': manga.linkGambar,
            }),
          )
          .timeout(timeout);

      if (response.statusCode != 201) {
        throw Exception('Failed to bookmark');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Manga>> getBookmarks() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/bookmark'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];
        return data.map((item) => Manga.fromApiJson(item)).toList();
      } else {
        throw Exception('Failed to load bookmarks');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> isBookmarked(int mangaId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/bookmark/$mangaId'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['isBookmarked'] ?? false;
      }
      return false;
    } catch (e) {
      developer.log('Error checking bookmark: $e', name: 'ApiService');
      return false;
    }
  }

  static Future<void> removeBookmark(int mangaId) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/bookmark/$mangaId'))
          .timeout(timeout);

      if (response.statusCode != 200) {
        throw Exception('Failed to remove bookmark');
      }
    } catch (e) {
      rethrow;
    }
  }
}
