import 'package:ram_project/character.dart';

class ResponseWrapper {
  final List<Character> results;

  ResponseWrapper({required this.results});

  factory ResponseWrapper.fromJson(Map<String, dynamic> json) {
    return ResponseWrapper(
      results: Character.fromJsonList(json['results']),
    );
  }
}