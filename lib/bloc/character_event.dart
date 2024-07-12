part of 'character_bloc.dart';

sealed class CharacterEvent {}

final class FetchCharactersEvent extends CharacterEvent {}

final class FilterCharactersEvent extends CharacterEvent {
  final Status status;

  FilterCharactersEvent(this.status);
}