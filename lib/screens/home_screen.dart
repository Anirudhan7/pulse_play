import 'package:flutter/material.dart';
import 'package:pluseplay/database/function/hive_store.dart';
import 'package:pluseplay/database/function/internal_storage.dart';
import 'package:pluseplay/database/models/all_song_model.dart';
import 'package:pluseplay/screens/allsongs/allsongs.dart';
import 'package:pluseplay/screens/favourites/favorites_screen.dart';
import 'package:pluseplay/screens/search/search.dart';
import 'package:pluseplay/screens/settings/settings_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:pluseplay/screens/widgets/all_songs_widget.dart';
import 'package:pluseplay/screens/nowPlaying/now_play.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  final List<Map<String, String>> recentPlays = [
    {
      'title': 'Believer',
      'artist': 'Imagine Dragon',
      'image': 'lib/assets/images/believer.jpeg'
    },
    {
      'title': 'Chaff & Dust',
      'artist': 'Hyonna',
      'image': 'lib/assets/images/chaff and dust.webp'
    },
  ];

  final List<Map<String, String>> artists = [
    {'name': 'Drake', 'image': 'lib/assets/images/download.jpeg'},
    {'name': 'Eminem', 'image': 'lib/assets/images/eminem.webp'},
    {'name': 'Chainsmokers', 'image': 'lib/assets/images/chainsmokers.jpg'},
  ];
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    fetch();
    getAllSongs();
    super.initState();
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
                                        builder: (context) => PlayingNow(song: song),
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
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.recentPlays.length,
                    itemBuilder: (context, index) {
                      final play = widget.recentPlays[index];
                      return Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                play['image']!,
                                height: 100,
                                width: 160,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              play['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              play['artist']!,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.artists.length,
                    itemBuilder: (context, index) {
                      final artist = widget.artists[index];
                      return Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                artist['image']!,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              artist['name']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
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
