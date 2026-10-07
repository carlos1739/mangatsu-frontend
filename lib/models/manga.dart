class Manga {
  final int id;
  final String title;
  final String linkGambar;
  final String chapter;
  final String status;
  final String sinopsis;
  final String release;
  final List<String> genre;
  final String author;
  final bool bookmark;
  final int likes;
  final int view;
  final double rating;
  
  const Manga({
    required this.id,
    required this.title,
    required this.linkGambar,
    required this.chapter,
    required this.status,
    required this.sinopsis,
    required this.release,
    required this.genre,
    required this.author,
    this.bookmark = false,
    required this.likes,
    required this.view,
    required this.rating,
  });
}

// Empty - Data dari API
final allGenre = <String>[];
final allKomik = <Manga>[];