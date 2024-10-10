import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:pluseplay/database/function/hive_store.dart';
import 'package:pluseplay/database/models/all_song_model.dart';
import 'package:pluseplay/screens/nowPlaying/now_play.dart';
import 'package:pluseplay/screens/search/search.dart';

class AllSongsPage extends StatefulWidget {
  const AllSongsPage({super.key});

  @override
  _AllSongsPageState createState() => _AllSongsPageState();
}

class _AllSongsPageState extends State<AllSongsPage> {
  int _selectedIndex = 0;
final _audioPlayer =AudioPlayer();
  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 3, 56),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'All Songs',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
        ],
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
        child: ValueListenableBuilder<List<AllSongModel>>(
          valueListenable: allSongNotifier,
          builder: (context, allSongs, child) {
            if (allSongs.isEmpty) {
              return const Center(
                child: Text(
                  'No Songs Found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return ListView.builder(
              itemCount: allSongs.length,
              itemBuilder: (context, index) {
                final song = allSongs[index];
                return ListTile(
                  leading: QueryArtworkWidget(
                    id: song.id!,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: const Icon(Icons.music_note),
                  ),
                  title: Text(
                    song.songTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    song.artist,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {},
                  ),
                  onTap: () async{
                    // await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song.uri)));
                    // _audioPlayer.play();
                    if (song.uri.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayingNow(
                            song: song,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid song URI!')),
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
