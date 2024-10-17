// PlaylistScreen.dart
import 'package:flutter/material.dart';
import 'package:pluseplay/database/function/playlists/plaListfunc.dart';
import 'package:pluseplay/database/models/playlist/playList.dart';
import 'package:pluseplay/screens/playList/new_list.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlists'),
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
            return ListView.builder(
              itemCount: playlists.length + 1,
              itemBuilder: (context, index) {
                if (index == playlists.length) {
                  return ListTile(
                    leading: const Icon(Icons.add, color: Colors.green),
                    title: const Text(
                      'Create New Playlist',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          String playlistName = '';
                          return AlertDialog(
                            title: const Text('New Playlist'),
                            content: TextField(
                              decoration: const InputDecoration(
                                  hintText: 'Enter playlist name'),
                              onChanged: (value) {
                                playlistName = value;
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await createPlaylist(
                                      playlistName: playlistName);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Create'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                } else {
                  final playlist = playlists[index];
                  return ListTile(
                    leading: const Icon(Icons.music_note, color: Colors.blue),
                    title: Text(
                      playlist.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PlaylistDetailScreen(playlist: playlist),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        bool? confirmDelete = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Delete Playlist"),
                            content: const Text(
                                "Are you sure you want to delete this playlist?"),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                              TextButton(
                                child: const Text("Delete"),
                                onPressed: () => Navigator.pop(context, true),
                              ),
                            ],
                          ),
                        );

                        if (confirmDelete == true) {
                          await deletePlaylist(playlist.id!);
                        }
                      },
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
