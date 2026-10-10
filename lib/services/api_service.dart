import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/manga.dart';
import 'package:project_manga/screens/auth/user/user_session.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:5000/api';
  static const Duration timeout = Duration(seconds: 30);
  static List<Manga>? _mangaCache;

  // ============ MANGA ENDPOINTS ============

  static Future<List<Manga>> getAllManga() async {
    if (_mangaCache != null) {
      return List<Manga>.of(_mangaCache!);
    }
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/manga'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];
        final manga = data.map((item) => Manga.fromApiJson(item)).toList();
        _mangaCache = manga;
        return List<Manga>.of(manga);
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
          .get(
            Uri.parse(
              '$baseUrl/manga/search?q=${Uri.encodeQueryComponent(query)}',
            ),
          )
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
      final manga = await getAllManga();
      final matches = _filterByGenres(manga, genres);
      if (matches.isNotEmpty) return matches;

      final searchResults = <Manga>[];
      for (final genre in genres) {
        searchResults.addAll(await searchManga(genre));
      }
      final unique = <String, Manga>{
        for (final item in searchResults) _mangaKey(item): item,
      };
      return _filterByGenres(unique.values.toList(), genres);
    } catch (e) {
      rethrow;
    }
  }

  static List<Manga> _filterByGenres(List<Manga> manga, List<String> genres) {
    return manga
        .where(
          (item) => genres.every(
            (genre) => item.genre.any(
              (value) =>
                  value.trim().toLowerCase() == genre.trim().toLowerCase(),
            ),
          ),
        )
        .toList();
  }

  static String _mangaKey(Manga manga) =>
      manga.id > 0 ? 'id:${manga.id}' : 'title:${manga.title.toLowerCase()}';

  // ============ BOOKMARK ENDPOINTS ============

  static int _requireUserId() {
    final userId = UserSession.id;
    if (userId == null) {
      throw Exception('Login dulu untuk memakai bookmark');
    }
    return userId;
  }

  static Future<void> addBookmark(Manga manga) async {
    final userId = _requireUserId();
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/bookmark'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'user_id': userId,
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
    final userId = _requireUserId();
    try {
      final response = await http
          .get(
            Uri.parse(
              '$baseUrl/bookmark?user_id=${Uri.encodeQueryComponent('$userId')}',
            ),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];
        return data.map((item) => Manga.fromApiJson(item)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Sesi login tidak valid untuk memuat bookmark');
      } else {
        throw Exception('Failed to load bookmarks');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> isBookmarked(int mangaId) async {
    final userId = UserSession.id;
    if (userId == null) return false;
    try {
      final response = await http
          .get(
            Uri.parse(
              '$baseUrl/bookmark/$mangaId?user_id=${Uri.encodeQueryComponent('$userId')}',
            ),
          )
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
    final userId = _requireUserId();
    try {
      final response = await http
          .delete(
            Uri.parse(
              '$baseUrl/bookmark/$mangaId?user_id=${Uri.encodeQueryComponent('$userId')}',
            ),
          )
          .timeout(timeout);

      if (response.statusCode == 401) {
        throw Exception('Sesi login tidak valid untuk menghapus bookmark');
      }
      if (response.statusCode != 200) {
        throw Exception('Failed to remove bookmark');
      }
    } catch (e) {
      rethrow;
    }
  }
}
