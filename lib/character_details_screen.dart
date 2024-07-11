import 'package:flutter/material.dart';

import 'character.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailsScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(character.name),
          centerTitle: false,
        ),
        body: Column(
          children: [
            AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  character.image,
                )),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text("Current Location: ${character.location.name}")),
            Text("Origin: ${character.origin.name}")
          ],
        ));
  }
}
