import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart'; // For QueryArtworkWidget
import 'package:pluseplay/database/function/favourite/favourite.dart';
import 'package:pluseplay/database/function/playlists/plaListfunc.dart';
import 'package:pluseplay/database/models/playlist/playList.dart';
import 'package:pluseplay/database/models/favourites/favourite_model.dart'; // Import your FavoriteModel
import 'package:pluseplay/screens/nowPlaying/now_play.dart'; 

class PlaylistDetailScreen extends StatefulWidget {
  final Playlist playlist;

  const PlaylistDetailScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  _PlaylistDetailScreenState createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  late Playlist currentPlaylist;

  @override
  void initState() {
    super.initState();
    currentPlaylist = widget.playlist;
    getPlaylists(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentPlaylist.name),
        backgroundColor: const Color.fromARGB(255, 13, 3, 56),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Color.fromARGB(255, 12, 5, 144)],
          ),
        ),
        child: ValueListenableBuilder<List<Playlist>>(
          valueListenable: playlistsNotifier,
          builder: (context, playlists, child) {
            currentPlaylist = playlists.firstWhere(
              (p) => p.id == widget.playlist.id,
              orElse: () => currentPlaylist,
            );

            return ListView.builder(
              itemCount: currentPlaylist.songs.length,
              itemBuilder: (context, index) {
                final song = currentPlaylist.songs[index];
                return ListTile(
                  leading: QueryArtworkWidget(
                    id: song.id, // Assuming song.id is the ID for the artwork
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: Icon(
                      Icons.music_note,
                      size: 50,
                      color: Colors.grey[700],
                    ),
                  ),
                  title: Text(
                    song.songTitle,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    song.artist,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayingNow(
                          song: song,
                          allSongs: currentPlaylist.songs, 
                          recentPlays: [], 
                          isFromRecent: false, 
                        ),
                      ),
                    );
                  },
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem<String>(
                          value: 'remove',
                          child: Text('Remove from Playlist'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'favorite',
                          child: Text('Add to Favorites'),
                        ),
                      ];
                    },
                    onSelected: (value) async {
                      if (value == 'remove') {
                        await removeSongFromPlaylist(currentPlaylist.name, song);
                        setState(() {
                          currentPlaylist.songs.remove(song);
                        });
                      } else if (value == 'favorite') {
                        // Create a FavoriteModel instance from the song
                        final favoriteSong = FavoriteModel(
                          id: song.id,
                          songTitle: song.songTitle,
                          artist: song.artist,
                          uri: song.uri,
                          imageUri: song.imageBytes ?? Uint8List(0), // Use a default value if null
                          songPath: song.songPath, // Use the correct property for the song path
                        );

                        // Add the song to favorites
                        await addSongToFavorites(favoriteSong); // Pass the FavoriteModel instance
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}