import 'package:permission_handler/permission_handler.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:pluseplay/database/models/all_song_model.dart';

class StorageService {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<AllSongModel>> fetchAllSongs() async {
    print("Requesting permission to fetch songs...");

    // bool permissionGranted = await requestPermission();
    // if (!permissionGranted) {
    //   permissionGranted = await requestPermission();
    //   if (!permissionGranted) {
    //     print('Storage permission still not granted');
    //     return [];
    //   }
    // }

    print("Querying songs...");
    List<SongModel> songs = await _audioQuery.querySongs();
      print(songs);
    if (songs.isEmpty) {
      print("No songs found on device");
      return [];
    }

    List<AllSongModel> songList = songs.map((song) {
      return AllSongModel(
        id: song.id,
        songTitle: song.title,
        artist: song.artist ?? 'Unknown Artist',
        uri: song.uri ?? '',
        songPath: song.data,
        imageUri: null,
      );
    }).toList();

    print("Fetched ${songList.length} songs ascasdcacsxaSxazxZXZXZXZXsdx");
    return songList;
  }
}

Future<bool> requestPermission() async {
  if (await Permission.audio.isGranted) {
    print("Permission already granted");
    return true;
  }

  var result = await Permission.audio.request();

  if (result.isGranted) {
    print("Permission granted");
    return true;
  } else {
    print("Permission denied");
    return false;
  }
}

Future<void> fetch() async {
  List<SongModel> songs1 = await audioquery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true);
    
  print(",,,,,, ${songs1}");
}

final audioquery = OnAudioQuery();
