import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ram_project/character_details_screen.dart';
import 'package:ram_project/response_wrapper.dart';

import 'character.dart';

void main() {
  runApp(const MyApp());
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
  List<Character> characterList = List.empty();
  List<Character> completeList = List.empty();

  fetchCharacters() async {
    final response = await http.get(Uri.parse('https://rickandmortyapi.com/api/character'));
    if (response.statusCode == 200) {
      completeList = ResponseWrapper.fromJson(jsonDecode(response.body)).results;
      setState(() {
        characterList = completeList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: characterList.isEmpty ? buildEmptyMessage() : buildItemList(),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchCharacters,
        tooltip: 'FetchChars',
        child: const Icon(Icons.refresh_outlined),
      ),
    );
  }

  buildEmptyMessage() {
    return const Center(
      child: Text("No characters"),
    );
  }

  buildItemList() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
                onPressed: () {
                  filterChars(Status.all);
                },
                child: Text(Status.all.name)),
            OutlinedButton(
                onPressed: () {
                  filterChars(Status.alive);
                },
                child: Text(Status.alive.name)),
            OutlinedButton(
                onPressed: () {
                  filterChars(Status.dead);
                },
                child: Text(Status.dead.name)),
            OutlinedButton(
                onPressed: () {
                  filterChars(Status.unknown);
                },
                child: Text(Status.unknown.name)),
          ],
        )),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final character = characterList[index];
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
            childCount: characterList.length,
          ),
        ),
      ],
    );
  }

  void filterChars(Status status) {
    List<Character> filteredList = List.empty();
    switch (status) {
      case Status.all:
        filteredList = completeList;
        break;
      default:
        filteredList = completeList.where((character) {
          return character.status == status;
        }).toList();
    }
    setState(() {
      characterList = filteredList;
    });
  }
}
