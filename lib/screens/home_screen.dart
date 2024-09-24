import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:pluseplay/database/function/internal_storage.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  // List of songs
  final List<Map<String, String>> allSongs = [
    {
      'title': 'Monster Go Bump',
      'artist': 'Erika Recinos',
      'image': 'lib/assets/images/believer.jpeg'
    },
    {
      'title': 'Short Wave',
      'artist': 'Ryan Grigory',
      'image': 'lib/assets/images/shortwave.jpeg'
    },
    {
      'title': 'Dream On',
      'artist': 'Roger Terry',
      'image': 'lib/assets/images/dream on.jpg'
    },
  ];

  // List of recent plays
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

  // List of artists
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
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            "PlusPlay",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () async{
                // Handle settings
               // StorageService().fetch();
              await fetch();
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
                // All Songs section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "All Songs",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // Text(
                    //   "See More",
                    //   style: TextStyle(
                    //     fontSize: 15,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    TextButton(
                      onPressed: () {},
                      child: Text("Seemore",
                          style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
                const SizedBox(height: 12),

                // All Songs List
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.allSongs.length,
                    itemBuilder: (context, index) {
                      final song = widget.allSongs[index];
                      return Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                song['image']!,
                                height: 100,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              song['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              song['artist']!,
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

                const SizedBox(height: 24), // Space between sections

                // Recent Plays Section
                const Text(
                  "Recent Plays",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                // Recent Plays List (Updated)
                SizedBox(
                  height: 160, // Keeping height as it was
                  child: ListView.builder(
                    scrollDirection:
                        Axis.horizontal, // Enable horizontal scrolling
                    itemCount: widget.recentPlays.length,
                    itemBuilder: (context, index) {
                      final play = widget.recentPlays[index];
                      return Container(
                        width: 160, // Adjust width to display larger items
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

                const SizedBox(height: 24), // Space between sections

                // Artists Section
                const Text(
                  "Artists",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                // Artists List
                SizedBox(
                  height: 120, // Adjust height as needed
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
                              borderRadius: BorderRadius.circular(
                                  50), // Circular artist image
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

        // Bottom Navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ],
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
