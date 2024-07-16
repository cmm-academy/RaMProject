import 'package:ram_project/model/character.dart';

class ResponseWrapper {
  final List<Character> results;

  ResponseWrapper({required this.results});

  factory ResponseWrapper.fromJson(Map<String, dynamic> json) {
    return ResponseWrapper(
      results: Character.fromJsonList(json['results']),
    );
  }
}