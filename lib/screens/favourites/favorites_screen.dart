import 'package:flutter/material.dart';
import 'package:pluseplay/database/function/favourite/favourite.dart';
import 'package:pluseplay/database/models/favourites/favourite_model.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    getAllSongsFromFavorites(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<FavoriteModel>>(
        valueListenable: favoriteNotifier,
        builder: (context, favoriteSongs, child) {
          if (favoriteSongs.isEmpty) {
            return const Center(
              child: Text(
                "No favorites yet!",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: favoriteSongs.length,
            itemBuilder: (context, index) {
              final song = favoriteSongs[index];
              return Dismissible(
                key: Key(song.id.toString()),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.redAccent,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  await deleteFromFavorites(song.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${song.songTitle} removed from favorites')),
                  );
                },
                child: Card(
                  color: Colors.grey[900],
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      song.songTitle,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      song.artist,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
