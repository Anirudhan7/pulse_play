
import 'package:flutter/material.dart';
import 'package:pluseplay/database/function/playlists/plaListfunc.dart';
import 'package:pluseplay/database/models/playlist/playList.dart';

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
                  leading: const Icon(Icons.music_note, color: Colors.blue),
                  title: Text(
                    song.songTitle,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () async {
                      await removeSongFromPlaylist(currentPlaylist.name, song);
                      setState(() {
                        currentPlaylist.songs.remove(song);
                      });
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
