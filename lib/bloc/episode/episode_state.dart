part of 'episode_bloc.dart';

@immutable
sealed class EpisodeState {}

final class EpisodeInitial extends EpisodeState {}

final class EpisodeLoaded extends EpisodeState {
  final Episode episode;

  EpisodeLoaded(this.episode);
}

final class EpisodeError extends EpisodeState {}
