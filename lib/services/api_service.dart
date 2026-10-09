import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/manga.dart';
// >>> TAMBAHAN 1: untuk membaca id user yang sedang login
import 'package:project_manga/screens/auth/user/user_session.dart';
// <<< SELESAI TAMBAHAN 1

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
  // >>> TAMBAHAN 2: seluruh blok bookmark ditulis ulang agar membawa user_id

  // Ambil id user yang login; kalau belum login, lempar error
  static int _requireUserId() {
    final id = UserSession.id;
    if (id == null) {
      throw Exception('Login dulu untuk memakai bookmark');
    }
    return id;
  }

  // >>> BARU: menyimpan status baca tiap bookmark (diisi saat getBookmarks dipanggil)
  static final Map<int, String> bookmarkStatus = {};

  // >>> BARU: ubah kode status jadi tulisan yang tampil di layar
  static String statusLabel(String? status) {
    switch (status) {
      case 'reading':
        return 'Sedang dibaca';
      case 'completed':
        return 'Selesai';
      default:
        return 'Ingin dibaca';
    }
  }

  // Simpan bookmark
  static Future<void> addBookmark(Manga manga) async {
    final userId = _requireUserId();
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
  }

  // >>> DIUBAH: sekarang juga mengisi bookmarkStatus
  // Ambil semua bookmark milik user (Rak Buku)
  static Future<List<Manga>> getBookmarks() async {
    final userId = _requireUserId();
    final response = await http
        .get(Uri.parse('$baseUrl/bookmark?user_id=$userId'))
        .timeout(timeout);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> data = jsonData['data'] ?? [];
      bookmarkStatus.clear();
      for (final item in data) {
        final id = item['mal_id'];
        if (id is int) {
          bookmarkStatus[id] = item['read_status']?.toString() ?? 'plan';
        }
      }
      return data.map((item) => Manga.fromApiJson(item)).toList();
    }
    throw Exception('Failed to load bookmarks');
  }

  // Cek apakah manga ini sudah di-bookmark user
  static Future<bool> isBookmarked(int mangaId) async {
    final userId = UserSession.id;
    if (userId == null) return false;
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/bookmark/$mangaId?user_id=$userId'))
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

  // >>> BARU: status baca satu manga; null kalau belum di-bookmark
  static Future<String?> getBookmarkStatus(int mangaId) async {
    final userId = UserSession.id;
    if (userId == null) return null;
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/bookmark/$mangaId?user_id=$userId'))
          .timeout(timeout);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['isBookmarked'] == true) {
          return jsonData['readStatus']?.toString() ?? 'plan';
        }
      }
      return null;
    } catch (e) {
      developer.log('Error checking bookmark: $e', name: 'ApiService');
      return null;
    }
  }

  // >>> BARU (UPDATE): ubah status baca
  static Future<void> updateBookmarkStatus(int mangaId, String status) async {
    final userId = _requireUserId();
    final response = await http
        .put(
          Uri.parse('$baseUrl/bookmark/$mangaId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'user_id': userId, 'read_status': status}),
        )
        .timeout(timeout);

    if (response.statusCode != 200) {
      throw Exception('Failed to update bookmark');
    }
  }

  // Hapus bookmark
  static Future<void> removeBookmark(int mangaId) async {
    final userId = _requireUserId();
    final response = await http
        .delete(Uri.parse('$baseUrl/bookmark/$mangaId?user_id=$userId'))
        .timeout(timeout);

    if (response.statusCode != 200) {
      throw Exception('Failed to remove bookmark');
    }
  }
  // <<< SELESAI TAMBAHAN 2
}