import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:pluseplay/database/models/all_song_model.dart';
import 'package:pluseplay/database/function/favourite/favourite.dart';
import 'package:pluseplay/database/models/favourites/favourite_model.dart';

class PlayingNow extends StatefulWidget {
  final AllSongModel song;

  const PlayingNow({
    super.key,
    required this.song,
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

  @override
  void initState() {
    super.initState();
    isPlayingNotifier = ValueNotifier(false);
    durationNotifier = ValueNotifier(Duration.zero);
    positionNotifier = ValueNotifier(Duration.zero);
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
      if (widget.song.uri.isNotEmpty) {
        await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(widget.song.uri)));
        await _audioPlayer.play();
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
        songPath: widget.song.songPath,
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
                id: widget.song.id!,
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
              widget.song.songTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              widget.song.artist,
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
                      onPressed: () {},
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
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
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
