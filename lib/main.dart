import 'package:flutter/material.dart';
import 'package:project_manga/screens/home/home.dart';
import 'package:project_manga/screens/catalog/by_genre.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mangatsu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Beranda(),
      onGenerateRoute: (settings) {
        final uri = Uri.tryParse(settings.name ?? '');
        if (uri != null &&
            uri.pathSegments.length == 2 &&
            uri.pathSegments.first == 'genre') {
          return MaterialPageRoute(
            settings: settings,
            builder:
                (_) => Bygenre(
                  genreName: Uri.decodeComponent(uri.pathSegments.last),
                ),
          );
        }
        return null;
      },
    );
  }
}
