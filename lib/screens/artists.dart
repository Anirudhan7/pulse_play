import 'package:flutter/material.dart';
import 'package:pluseplay/database/models/all_songs/all_song_model.dart';
import 'package:pluseplay/screens/nowPlaying/now_play.dart';

class ArtistSongsPage extends StatelessWidget {
  final String artistName;
  final List<AllSongModel> songsByArtist;

  ArtistSongsPage({required this.artistName, required this.songsByArtist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artistName),
        backgroundColor: const Color.fromARGB(255, 13, 3, 56),
      ),
      body: ListView.builder(
        itemCount: songsByArtist.length,
        itemBuilder: (context, index) {
          final song = songsByArtist[index];
          return ListTile(
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
                  builder: (context) => PlayingNow(song: song),
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
