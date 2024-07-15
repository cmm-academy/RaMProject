import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ram_project/bloc/character/character_bloc.dart';
import 'package:ram_project/bloc/episode/episode_bloc.dart';
import 'package:ram_project/character_details_screen.dart';

import 'model/character.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => CharacterBloc()),
    BlocProvider(create: (context) => EpisodeBloc())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick And Morty Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF70b3c5)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: BlocBuilder<CharacterBloc, CharacterState>(builder: (context, state) {
        if (state is CharacterLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CharacterLoadedState) {
          return buildItemList(state.characters);
        } else if (state is CharacterErrorState) {
          return Center(child: Text(state.errorMessage));
        } else {
          return const Center(child: Text("Unknown state"));
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchCharacters,
        tooltip: 'FetchChars',
        child: const Icon(Icons.refresh_outlined),
      ),
    );
  }

  fetchCharacters() {
    context.read<CharacterBloc>().add(FetchCharactersEvent());
  }

  buildEmptyMessage() {
    return const Center(
      child: Text("No characters"),
    );
  }

  buildItemList(List<Character> characters) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
                onPressed: () {
                  context.read<CharacterBloc>().add(FilterCharactersEvent(Status.all));
                },
                child: Text(Status.all.name)),
            OutlinedButton(
                onPressed: () {
                  context.read<CharacterBloc>().add(FilterCharactersEvent(Status.alive));
                },
                child: Text(Status.alive.name)),
            OutlinedButton(
                onPressed: () {
                  context.read<CharacterBloc>().add(FilterCharactersEvent(Status.dead));
                },
                child: Text(Status.dead.name)),
            OutlinedButton(
                onPressed: () {
                  context.read<CharacterBloc>().add(FilterCharactersEvent(Status.unknown));
                },
                child: Text(Status.unknown.name)),
          ],
        )),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final character = characters[index];
              return Card(
                  clipBehavior: Clip.hardEdge,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CharacterDetailsScreen(character: character),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Image(
                          image: NetworkImage(character.image),
                          width: 80,
                        ),
                        const SizedBox(width: 8),
                        Text(character.name)
                      ],
                    ),
                  ));
            },
            childCount: characters.length,
          ),
        ),
      ],
    );
  }
}
