import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  fetchCharacters() async {
    final response = await http.get(Uri.parse('https://rickandmortyapi.com/api/character'));
    if (response.statusCode == 200) {
      setState(() {
        characterList = ResponseWrapper.fromJson(jsonDecode(response.body)).results;
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
    return ListView.builder(
        itemCount: characterList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Image(
                image: NetworkImage(characterList[index].image),
                width: 200,
              ),
              const SizedBox(width: 8),
              Text(characterList[index].name)
            ],
          );
        });
  }
}
