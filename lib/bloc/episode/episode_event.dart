part of 'episode_bloc.dart';

@immutable
sealed class EpisodeEvent {}

final class FetchEpisodeDetailEvent extends EpisodeEvent {
  final int episodeId;

  FetchEpisodeDetailEvent(this.episodeId);
}