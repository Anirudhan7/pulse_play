import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:pluseplay/database/function/internal_storage.dart';
import 'package:pluseplay/database/models/all_song_model.dart';


ValueNotifier<List<AllSongModel>> allSongNotifier = ValueNotifier([]);

Future<void>addToAllsong(List<SongModel> songs1) async{
  Uint8List? imagebyte;
  final openDB = await Hive.openBox<AllSongModel>("All_song");
  await openDB.clear();
  allSongNotifier.value.clear();

  for(var song in songs1){
    var allSong =AllSongModel(
      id: song.id,
      songTitle: song.title,
      artist: song.artist ?? "unknown", 
      uri: song.uri ?? '',
      songPath: song.data 
      );
      await openDB.put(song.id, allSong);
      print(song.id);
  }
  allSongNotifier.value =openDB.values.toList();
  allSongNotifier.notifyListeners();
}

Future<void> getAllSongs() async{
  final songDB = await Hive.openBox<AllSongModel>("All_songs");
  allSongNotifier.value.clear();
  allSongNotifier.value.addAll(songDB.values);
  allSongNotifier.notifyListeners();
}





// Future<List<AllSongModel>> fetchAllSongs() async {
//   print("Requesting permission to fetch songs...");

//   bool permissionGranted = await requestPermission();
//   if (!permissionGranted) {
//     print('Storage permission not granted');
//     return [];
//   }

//   print("Querying songs...");
//    List<SongModel> songs = await _audioQuery.querySongs();

//   if (songs.isEmpty) {
//     print("No songs found on device");
//     return [];
//   }

//   // Open or create a Hive box
//   var box = await Hive.openBox<AllSongModel>('songsBox');

//   // Clear existing data
//   await box.clear();

//   List<AllSongModel> songList = songs.map((song) {
//     final allSong = AllSongModel(
//       id: song.id,
//       songTitle: song.title,
//       artist: song.artist ?? 'Unknown Artist',
//       uri: song.uri ?? '',
//       songPath: song.data,
//     );

//     box.add(allSong);
//     return allSong;
//   }).toList();

//   print("Fetched ${songList.length} songs");
//   return songList;
// }