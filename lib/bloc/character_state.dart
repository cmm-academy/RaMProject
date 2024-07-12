part of 'character_bloc.dart';

sealed class CharacterState {}

final class CharacterLoadingState extends CharacterState {}

final class CharacterErrorState extends CharacterState {
  final String errorMessage;

  CharacterErrorState(this.errorMessage);
}

final class CharacterLoadedState extends CharacterState {
  final List<Character> characters;

  CharacterLoadedState(this.characters);
}