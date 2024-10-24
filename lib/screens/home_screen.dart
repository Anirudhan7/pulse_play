import 'package:flutter/material.dart';
import 'package:pluseplay/database/function/hive_store.dart';
import 'package:pluseplay/database/function/internal_storage.dart';
import 'package:pluseplay/database/function/recent_play/recent_play.dart';
import 'package:pluseplay/database/models/all_songs/all_song_model.dart';
import 'package:pluseplay/database/models/recent_play/recent_play.dart';
import 'package:pluseplay/screens/allsongs/allsongs.dart';
import 'package:pluseplay/screens/favourites/favorites_screen.dart';
import 'package:pluseplay/screens/playList/playlist.dart';
import 'package:pluseplay/screens/search/search.dart';
import 'package:pluseplay/screens/settings/settings_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:pluseplay/screens/widgets/all_songs_widget.dart';
import 'package:pluseplay/screens/nowPlaying/now_play.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'dart:typed_data';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetch();
    await getAllSongs();
    await getRecentPlays();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 13, 3, 56),
          title: const Text(
            "PulsePlay",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "All Songs",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllSongsPage()),
                        );
                      },
                      child: const Text("See More",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<List<AllSongModel>>(
                  valueListenable: allSongNotifier,
                  builder: (context, allSongs, child) {
                    return SizedBox(
                      height: 160,
                      child: allSongs.isEmpty
                          ? const Center(
                              child: Text(
                                "No Songs Found",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: allSongs.length,
                              itemBuilder: (context, index) {
                                final song = allSongs[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PlayingNow(song: song),
                                      ),
                                    );
                                  },
                                  child: AllSongsWidget(song: song),
                                );
                              },
                            ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                
                const Text(
                  "Recent Plays",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<List<RecentPlayModel>>(
                  valueListenable: recentPlayNotifier,
                  builder: (context, recentPlays, child) {
                    return SizedBox(
                      height: 160,
                      child: recentPlays.isEmpty
                          ? const Center(
                              child: Text(
                                "No Recent Plays",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: recentPlays.length,
                              itemBuilder: (context, index) {
                                final play = recentPlays[index];
                                return GestureDetector(
                                  onTap: () {
                                Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PlayingNow(song: play),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 120,
                                    margin: const EdgeInsets.only(right: 16),
                                    child: Column(

                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: QueryArtworkWidget(
                                            artworkFit: BoxFit.fill,
                                            id: play.id,
                                            type: ArtworkType.AUDIO,
                                            artworkHeight: 100,
                                            artworkWidth: 120,
                                            nullArtworkWidget: Container(
                                              height: 100,
                                              width: 120,
                                              color: Colors.green,
                                              child: const Icon(
                                                Icons.music_note,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          play.songTitle,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          play.artist,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    );
                  },
                ),
                const SizedBox(height: 24),

               
                const Text(
                  "Artists",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      ArtistCard(artistName: "Artist 1"),
                      ArtistCard(artistName: "Artist 2"),
                      ArtistCard(artistName: "Artist 3"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.black,
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.black,
          color: const Color.fromARGB(255, 27, 9, 163),
          items: const [
            Icon(Icons.home, color: Colors.white),
            Icon(Icons.search, color: Colors.white),
            Icon(Icons.library_music, color: Colors.white),
            Icon(Icons.favorite, color: Colors.white),
          ],
          onTap: (int index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlaylistScreen()),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            } else {
              setState(() {
                _selectedIndex = index;
              });
            }
          },
          height: 60,
        ),
      ),
    );
  }
}

class ArtistCard extends StatelessWidget {
  final String artistName;

  const ArtistCard({Key? key, required this.artistName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 100,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          artistName,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
