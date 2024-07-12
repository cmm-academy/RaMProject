import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ram_project/response_wrapper.dart';

import '../character.dart';

part 'character_event.dart';
part 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  List<Character> characterList = List.empty();

  CharacterBloc() : super(CharacterLoadingState()) {
    on<FetchCharactersEvent>((event, emit) async {
      final response = await http.get(Uri.parse('https://rickandmortyapi.com/api/character'));
      if (response.statusCode == 200) {
        characterList = ResponseWrapper.fromJson(jsonDecode(response.body)).results;
        emit(CharacterLoadedState(characterList));
      } else {
        emit(CharacterErrorState('Error fetching characters'));
      }
    });
    on<FilterCharactersEvent>((event, emit) {
      if (event.status == Status.all) {
        emit(CharacterLoadedState(characterList));
      } else {
        final filteredList =
            characterList.where((element) => element.status == event.status).toList();
        emit(CharacterLoadedState(filteredList));
      }
    });
  }
}
