import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:pluseplay/database/models/all_songs/all_song_model.dart';
import 'package:pluseplay/database/function/favourite/favourite.dart';
import 'package:pluseplay/database/models/favourites/favourite_model.dart';
import 'package:pluseplay/screens/playList/playlist.dart';
import 'package:pluseplay/database/models/recent_play/recent_play.dart';
import 'package:pluseplay/database/function/recent_play/recent_play.dart';

class PlayingNow extends StatefulWidget {
  final dynamic song;
  final List<dynamic> allSongs; // List of all songs
  final List<dynamic> recentPlays; // List of recent plays
  final bool isFromRecent; // Determine if playing from recent plays

  const PlayingNow({
    super.key,
    required this.song,
    required this.allSongs,
    required this.recentPlays,
    required this.isFromRecent,
  });

  @override
  _PlayingNowState createState() => _PlayingNowState();
}

class _PlayingNowState extends State<PlayingNow> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late ValueNotifier<bool> isPlayingNotifier;
  late ValueNotifier<Duration> durationNotifier;
  late ValueNotifier<Duration> positionNotifier;
  bool isFavorite = false;
  late List<dynamic> currentPlaylist; // Current playlist
  late int currentIndex; // Current song index

  @override
  void initState() {
    super.initState();
    isPlayingNotifier = ValueNotifier(false);
    durationNotifier = ValueNotifier(Duration.zero);
    positionNotifier = ValueNotifier(Duration.zero);
    
    // Initialize current playlist based on where the song is coming from
    currentPlaylist = widget.isFromRecent ? widget.recentPlays : widget.allSongs;
    currentIndex = currentPlaylist.indexWhere((song) => song.id == widget.song.id);
    
    _initializePlayer();
    
    isFavorite = favoriteNotifier.value.any((fav) => fav.id == widget.song.id);
    favoriteNotifier.addListener(() {
      if (mounted) {
        setState(() {
          isFavorite = favoriteNotifier.value.any((fav) => fav.id == widget.song.id);
        });
      }
    });

    _audioPlayer.positionStream.listen((newPosition) {
      if (mounted) positionNotifier.value = newPosition;
    });
    _audioPlayer.durationStream.listen((newDuration) {
      if (mounted) durationNotifier.value = newDuration ?? Duration.zero;
    });
    _audioPlayer.playingStream.listen((isPlaying) {
      if (mounted) isPlayingNotifier.value = isPlaying;
    });
  }

  Future<void> _initializePlayer() async {
    try {
      if (currentPlaylist.isNotEmpty && currentIndex >= 0) {
        await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(currentPlaylist[currentIndex].uri)));
        await _audioPlayer.play();
        await addRecentPlay(RecentPlayModel(
          id: widget.song.id!,
          songTitle: widget.song.songTitle,
          artist: widget.song.artist,
          uri: widget.song.uri,
          imageUri: widget.song.imageBytes!,
          timestamp: DateTime.now(),
          songPath: widget.song.songPath,
        ));
      } else {
        throw Exception("Invalid song URI!");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error playing song: $e')),
        );
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final songId = widget.song.id!;
    if (isFavorite) {
      await deleteFromFavorites(songId);
      favoriteNotifier.value = favoriteNotifier.value.where((fav) => fav.id != songId).toList();
    } else {
      final newFavorite = FavoriteModel(
        id: songId,
        songTitle: widget.song.songTitle,
        artist: widget.song.artist,
        uri: widget.song.uri,
        imageUri: widget.song.imageBytes!,
        songPath: widget .song.songPath,
      );
      await addSongToFavorites(newFavorite);
      favoriteNotifier.value = [...favoriteNotifier.value, newFavorite];
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void _playPause() {
    if (isPlayingNotifier.value) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void _playNext() async {
    if (currentIndex < currentPlaylist.length - 1) {
      setState(() {
        currentIndex++;
      });
      await _initializePlayer();
    }
  }

  void _playPrevious() async {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      await _initializePlayer();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    isPlayingNotifier.dispose();
    durationNotifier.dispose();
    positionNotifier.dispose();
    super.dispose();
  }

  void _addToPlaylist() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PlaylistScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Playing Now"),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 1) _addToPlaylist();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Add to Playlist"),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: 300,
              child: QueryArtworkWidget(
                id: currentPlaylist[currentIndex].id!,
                type: ArtworkType.AUDIO,
                artworkFit: BoxFit.cover,
                nullArtworkWidget: Icon(
                  Icons.music_note,
                  size: 100,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              currentPlaylist[currentIndex].songTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              currentPlaylist[currentIndex].artist,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<Duration>(
              valueListenable: positionNotifier,
              builder: (context, position, _) {
                return ValueListenableBuilder<Duration>(
                  valueListenable: durationNotifier,
                  builder: (context, duration, _) {
                    return Column(
                      children: [
                        Slider(
                          activeColor: Colors.white,
                          inactiveColor: Colors.grey,
                          value: position.inSeconds.toDouble(),
                          max: duration.inSeconds.toDouble(),
                          onChanged: (value) async {
                            final position = Duration(seconds: value.toInt());
                            await _audioPlayer.seek(position);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(position),
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              _formatDuration(duration),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<bool>(
              valueListenable: isPlayingNotifier,
              builder: (context, isPlaying, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shuffle, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white),
                      onPressed: _playPrevious,
                    ),
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: _playPause,
                      iconSize: 64,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white),
 onPressed: _playNext,
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.blue : Colors.white,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}