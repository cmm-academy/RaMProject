import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ram_project/model/character.dart';
import 'package:ram_project/repository/rick_and_morty_repository.dart';

part 'character_event.dart';
part 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  List<Character> characterList = List.empty();
  RickAndMortyRepository repository = RickAndMortyRepository();

  CharacterBloc() : super(CharacterLoadingState()) {
    on<FetchCharactersEvent>((event, emit) async {
      final response = await repository.getCharacters();

      if (response.isSuccessful()) {
        characterList = response.data ?? [];
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
