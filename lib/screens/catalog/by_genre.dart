import 'package:flutter/material.dart';

import 'package:project_manga/widgets/anime_grid.dart';
import 'package:project_manga/models/manga.dart';
import 'by_title.dart';

class Bygenre extends StatefulWidget {
  final Set genre;
  final List<Manga> manga;
  const Bygenre({super.key, required this.manga, required this.genre});

  @override
  State<Bygenre> createState() => _BygenreState();
}

class _BygenreState extends State<Bygenre> {
  List<Manga> komik = allKomik;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchController.clear();
      }
    });
  }

  void cariKomik(String titlek) {
    final cari =
        komik.where((manga) {
          final komiktitle = manga.title.toLowerCase();
          final inputtitle = titlek.toLowerCase();
          return komiktitle.contains(inputtitle);
        }).toList();

    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MangaByTitle(title: titlek, komikS: cari),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            bottom: PreferredSize(
              preferredSize: const Size(30.0, 55.0),
              child: Row(
                children: [
                  const Expanded(child: Text("")),
                  SizedBox(
                    width: 250,
                    child:
                        _isSearchActive
                            ? SizedBox(
                              width: 50,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 10,
                                  left: 10,
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  onSubmitted: (title) => cariKomik(title),
                                  decoration: InputDecoration(
                                    hintText: 'Search...',
                                    hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      onPressed: _toggleSearch,
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                            : Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                onPressed: _toggleSearch,
                              ),
                            ),
                  ),
                ],
              ),
            ),
            title: const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Image(image: AssetImage('assets/logo/LogoM1.png'), width: 40),
                  Text(
                    "Mangatsu",
                    style: TextStyle(
                      fontFamily: 'Tilt',
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu, color: Colors.white, size: 50),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person),
                color: Colors.white,
                iconSize: 50,
              ),
            ],
          ),
          widget.manga.isEmpty
              ? SliverToBoxAdapter(
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "Tidak ditemukan manga bergenre ${widget.genre.join(', ')}",
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                        ),
                      ),
                      const Icon(Icons.search_off),
                    ],
                  ),
                ),
              )
              : SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    "Ditemukan Manga Bergenre : ${widget.genre.join(', ')}\nSebanyak : ${widget.manga.length}",
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          AnimeGrid(komik: widget.manga),
        ],
      ),
    );
  }
}
