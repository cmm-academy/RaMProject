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
  Status selectedStatus = Status.all;

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
            child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          children: Status.values
              .map((status) => ChoiceChip(
                    label: Text(status.name),
                    selected: selectedStatus == status,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedStatus = status;
                        context.read<CharacterBloc>().add(FilterCharactersEvent(status));
                      });
                    },
                  ))
              .toList(),
        )),
        buildExpandedView(characters)
      ],
    );
  }

  buildExpandedView(List<Character> characters) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final character = characters[index];
          return Card(
              clipBehavior: Clip.hardEdge,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CharacterDetailsScreen(character: character),
                    ),
                  );
                },
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Flexible(
                      child: Image(
                        image: NetworkImage(character.image),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(character.name),
                    const SizedBox(height: 8),
                  ],
                ),
              ));
        },
        childCount: characters.length,
      ),
    );
  }
}
