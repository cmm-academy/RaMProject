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
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.character.image,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.character.name,
                    style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Status: ${widget.character.status.name}")),
              const SizedBox(height: 16),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Current Location",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(widget.character.location.name)),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Origin",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(widget.character.origin.name)),
              const SizedBox(height: 16),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "First Episode",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("${episode.episode} - ${episode.name} - ${episode.airDate}"),
              ),
            ],
          ),
        ));
  }
}
