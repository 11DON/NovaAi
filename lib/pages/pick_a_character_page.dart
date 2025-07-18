import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jarvis/Providers/chat_provider.dart';
import 'package:jarvis/Providers/persona_provider.dart';
import 'package:jarvis/components/create_character_tab.dart';
import 'package:jarvis/components/my_third_button.dart';
import 'package:jarvis/models/persona.dart';
import 'package:jarvis/pages/chat_page.dart';
import 'package:jarvis/pages/create_character_page.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class PickACharacterPage extends StatefulWidget {
  const PickACharacterPage({super.key});

  @override
  State<PickACharacterPage> createState() => _PickACharacterPageState();
}

class _PickACharacterPageState extends State<PickACharacterPage> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    final PersonProvider = Provider.of<PersonaProvider>(context);
    final characters = PersonProvider.characters;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text('Select a Character'),
            ),
            scrolledUnderElevation: 0,
          ),
          body: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                sliver: SliverToBoxAdapter(
                  child: MyThirdButton(
                    color: Theme.of(context).colorScheme.primary,
                    height: 60,
                    icon: const Icon(Icons.add_circle_outline),
                    title: "Create New Character",
                    width: 200,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateCharacterPage(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final character = characters[index];
                    return CreateCharacterTab(
                      onTap: () async {
                        final personaProvider = Provider.of<PersonaProvider>(
                            context,
                            listen: false);
                        personaProvider.setPersona(character);
                        final chatProvider =
                            Provider.of<ChatProvider>(context, listen: false);
                        final sessionPrefix =
                            'persona||${character.name.replaceAll(' ', '-')}';
                        final lastSessionKey =
                            chatProvider.getLastSessionFor(sessionPrefix) ?? '';
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Continue or Start A New Chat?"),
                            content: Text(lastSessionKey.isNotEmpty
                                ? "Would you like to continue your last session with ${character.name}?"
                                : "No previous chat found for ${character.name}. Start a new session?"),
                            actions: [
                              if (lastSessionKey.isNotEmpty)
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                            sessionKey: lastSessionKey),
                                      ),
                                    );
                                  },
                                  child: const Text("continue last chat"),
                                ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    final chatProvider =
                                        Provider.of<ChatProvider>(context,
                                            listen: false);
                                    chatProvider.createNewSession(
                                        character.name,
                                        isTopic: false);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                            sessionKey: chatProvider
                                                .currentSessionKey!),
                                      ),
                                    );
                                  },
                                  child: const Text("Start new Session"))
                            ],
                          ),
                        );
                      },
                      role: character.name,
                      describtion: character.systemPrompt,
                      title: character.name,
                      img: character.avatar,
                    );
                  }, childCount: characters.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.7),
                ),
              ),
            ],
          )),
    );
  }
}
