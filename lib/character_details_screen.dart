import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ram_project/bloc/episode/episode_bloc.dart';
import 'package:ram_project/model/episode.dart';

import 'model/character.dart';

class CharacterDetailsScreen extends StatefulWidget {
  final Character character;

  const CharacterDetailsScreen({super.key, required this.character});

  @override
  State<StatefulWidget> createState() => _CharacterDetailsScreenState();
}

class _CharacterDetailsScreenState extends State<CharacterDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EpisodeBloc>().add(FetchEpisodeDetailEvent(widget.character.episodes.first));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EpisodeBloc, EpisodeState>(builder: (context, state) {
      if (state is EpisodeInitial) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is EpisodeLoaded) {
        return buildDetailsScreen(state.episode);
      } else if (state is EpisodeError) {
        return const Center(child: Text("Error"));
      } else {
        return const Center(child: Text("Unknown state"));
      }
    });
  }

  Widget buildDetailsScreen(Episode episode) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.character.name),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    widget.character.image,
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text("Current Location: ${widget.character.location.name}")),
              Text("Origin: ${widget.character.origin.name}"),
              const SizedBox(height: 16),
              const Text("First Episode"),
              Text(episode.episode),
              Text("Title: ${episode.name}"),
              Text("Release date: ${episode.airDate}"),
            ],
          ),
        ));
  }
}
