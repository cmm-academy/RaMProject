import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ram_project/model/episode.dart';

import '../../repository/rick_and_morty_repository.dart';

part 'episode_event.dart';
part 'episode_state.dart';

class EpisodeBloc extends Bloc<EpisodeEvent, EpisodeState> {
  RickAndMortyRepository repository = RickAndMortyRepository();

  EpisodeBloc() : super(EpisodeInitial()) {
    on<FetchEpisodeDetailEvent>((event, emit) async {
      final episodeResult = await repository.getEpisodeDetail(event.episodeId);
      if (episodeResult.isSuccessful()) {
        emit(EpisodeLoaded(episodeResult.data!));
      } else {
        emit(EpisodeError());
      }
    });
  }
}
