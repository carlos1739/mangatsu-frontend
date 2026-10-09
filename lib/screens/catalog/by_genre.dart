import 'package:flutter/material.dart';

import 'package:project_manga/widgets/anime_grid.dart';
import 'package:project_manga/models/manga.dart';
import 'package:project_manga/services/api_service.dart';

class Bygenre extends StatefulWidget {
  final String genreName;
  final List<Manga>? manga;

  const Bygenre({super.key, required this.genreName, this.manga});

  @override
  State<Bygenre> createState() => _BygenreState();
}

class _BygenreState extends State<Bygenre> {
  late final Future<List<Manga>> _mangaFuture;

  @override
  void initState() {
    super.initState();
    _mangaFuture =
        widget.manga != null
            ? Future.value(widget.manga)
            : ApiService.getMangaByGenre([widget.genreName]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff101014),
      appBar: AppBar(
        backgroundColor: const Color(0xff17131d),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Genre: ${widget.genreName}',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: FutureBuilder<List<Manga>>(
        future: _mangaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xffb77cff)),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Genre gagal dimuat: ${snapshot.error}',
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            );
          }
          final manga = snapshot.data ?? <Manga>[];
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                    child: Text(
                      '${manga.length} manga dalam genre ${widget.genreName}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ),
              if (manga.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'Tidak ditemukan manga untuk genre ini.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                )
              else
                AnimeGrid(komik: manga),
            ],
          );
        },
      ),
    );
  }
}
