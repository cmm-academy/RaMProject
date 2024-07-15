
import 'dart:convert';

import 'package:ram_project/model/episode.dart';
import 'package:ram_project/repository/ram_result.dart';
import 'package:ram_project/model/response_wrapper.dart';

import '../model/character.dart';
import 'package:http/http.dart' as http;


class RickAndMortyRepository{
  Future<RamResult<List<Character>>> getCharacters() async {
    final response = await http.get(Uri.parse('https://rickandmortyapi.com/api/character'));
    if (response.statusCode == 200) {
      return RamResult(data: ResponseWrapper.fromJson(jsonDecode(response.body)).results);
    } else {
      return RamResult(error: 'Error fetching characters');
    }
  }

  Future<RamResult<Episode>>getEpisodeDetail(int episodeId) async {
    final response = await http.get(Uri.parse('https://rickandmortyapi.com/api/episode/$episodeId'));
    if (response.statusCode == 200) {
      return RamResult(data: Episode.fromJson(jsonDecode(response.body)));
    } else {
      return RamResult(error: 'Error fetching episode');
    }
  }
}