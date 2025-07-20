import 'package:flutter/material.dart';

import 'package:nova_ai/Components/create_character_tab.dart';
import 'package:nova_ai/Components/my_third_button.dart';
import 'package:nova_ai/Pages/chat_page.dart';
import 'package:nova_ai/Pages/create_character_page.dart';
import 'package:nova_ai/Providers/chat_provider.dart';

import 'package:nova_ai/Providers/persona_provider.dart';
import 'package:provider/provider.dart';

class PickACharacterPage extends StatefulWidget {
  const PickACharacterPage({super.key});

  @override
  State<PickACharacterPage> createState() => _PickACharacterPageState();
}

class _PickACharacterPageState extends State<PickACharacterPage> {
  @override
  Widget build(BuildContext context) {
    final personaProvider = Provider.of<PersonaProvider>(context);
    final characters = personaProvider.characters;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Select a Character')),
          scrolledUnderElevation: 0,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: MyThirdButton(
                color: Theme.of(context).colorScheme.primary,
                height: 60,
                icon: const Icon(Icons.add_circle_outline),
                title: "Create New Character",
                width: 300,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateCharacterPage(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: GridView.builder(
                  itemCount: characters.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final character = characters[index];
                    return CreateCharacterTab(
                      describtion: character.role,
                      title: character.name,
                      img: character.avatar,
                      role: character.role,
                      onTap: () => _onCharacterTap(context, character),
                    );
                  },
                ),
              ),
            ),
          ],
        ),

        // CustomScrollView(
        //   slivers: [
        //     SliverPadding(
        //       padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        //       sliver: SliverToBoxAdapter(
        //         child: MyThirdButton(
        //           color: Theme.of(context).colorScheme.primary,
        //           height: 60,
        //           icon: const Icon(Icons.add_circle_outline),
        //           title: "Create New Character",
        //           width: 200,
        //           onTap: () {
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => const CreateCharacterPage(),
        //               ),
        //             );
        //           },
        //         ),
        //       ),
        //     ),
        //     SliverPadding(
        //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        //       sliver: SliverGrid(
        //         delegate: SliverChildBuilderDelegate((context, index) {
        //           final character = characters[index];
        //           return CreateCharacterTab(
        //             onTap: () async {
        //               final personaProvider = Provider.of<PersonaProvider>(
        //                 context,
        //                 listen: false,
        //               );
        //               personaProvider.setPersona(character);

        //               final chatProvider = Provider.of<ChatProvider>(
        //                 context,
        //                 listen: false,
        //               );

        //               final sessionPrefix =
        //                   'persona||${character.name.replaceAll(' ', '-')}';

        //               final lastSessionKey =
        //                   await chatProvider.getLastSessionFor(sessionPrefix) ??
        //                   '';

        //               if (!mounted) return;

        //               // Now it's safe to use context
        //               if (!context.mounted) return;

        //               showDialog(
        //                 context: context,
        //                 builder: (context) => AlertDialog(
        //                   title: const Text("Continue or Start A New Chat?"),
        //                   content: Text(
        //                     lastSessionKey.isNotEmpty
        //                         ? "Would you like to continue your last session with ${character.name}?"
        //                         : "No previous chat found for ${character.name}. Start a new session?",
        //                   ),
        //                   actions: [
        //                     if (lastSessionKey.isNotEmpty)
        //                       TextButton(
        //                         onPressed: () {
        //                           if (context.mounted) {
        //                             Navigator.pop(context);
        //                             Navigator.push(
        //                               context,
        //                               MaterialPageRoute(
        //                                 builder: (context) => ChatPage(
        //                                   sessionKey: lastSessionKey,
        //                                 ),
        //                               ),
        //                             );
        //                           }
        //                         },
        //                         child: const Text("Continue last chat"),
        //                       ),
        //                     TextButton(
        //                       onPressed: () async {
        //                         Navigator.pop(context);
        //                         await chatProvider.createNewSession(
        //                           character.name,
        //                           isTopic: false,
        //                         );
        //                         if (!mounted) return;
        //                         Navigator.push(
        //                           context,
        //                           MaterialPageRoute(
        //                             builder: (context) => ChatPage(
        //                               sessionKey:
        //                                   chatProvider.currentSessionKey!,
        //                             ),
        //                           ),
        //                         );
        //                       },
        //                       child: const Text("Start new Session"),
        //                     ),
        //                   ],
        //                 ),
        //               );
        //             },
        //             role: character.name,
        //             describtion: character.systemPrompt,
        //             title: character.name,
        //             img: character.avatar,
        //           );
        //         }, childCount: characters.length),
        //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //           crossAxisCount: 2,
        //           mainAxisSpacing: 12,
        //           crossAxisSpacing: 12,
        //           childAspectRatio: 0.7,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  Future<void> _onCharacterTap(BuildContext context, dynamic character) async {
    final localContext = context;
    final personaProvider = Provider.of<PersonaProvider>(
      localContext,
      listen: false,
    );
    personaProvider.setPersona(character);

    final chatProvider = Provider.of<ChatProvider>(localContext, listen: false);
    final sessionPrefix = 'persona||${character.name.replaceAll(' ', '-')}';

    final lastSessionKey =
        await chatProvider.getLastSessionFor(sessionPrefix) ?? '';

    if (!mounted) return;

    showDialog(
      context: localContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Continue or Start A New Chat?"),
        content: Text(
          lastSessionKey.isNotEmpty
              ? "Would you like to continue your last session with ${character.name}?"
              : "No previous chat found for ${character.name}. Start a new session?",
        ),
        actions: [
          if (lastSessionKey.isNotEmpty)
            TextButton(
              onPressed: () {
                if (!mounted) return;
                Navigator.pop(dialogContext);
                Navigator.push(
                  localContext,
                  MaterialPageRoute(
                    builder: (_) => ChatPage(
                      sessionKey: lastSessionKey,
                      title: character.name,
                      avatarPath: character.avatar,
                    ),
                  ),
                );
              },
              child: const Text("Continue last chat"),
            ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await chatProvider.createNewSession(
                character.name,
                isTopic: false,
                isDefaultCharacter: true, // <-- important flag
              );
              if (!mounted) return;
              Navigator.push(
                localContext,
                MaterialPageRoute(
                  builder: (_) => ChatPage(
                    sessionKey: chatProvider.currentSessionKey!,
                    title: character.name,
                    avatarPath: character.avatar,
                  ),
                ),
              );
            },
            child: const Text("Start new Session"),
          ),
        ],
      ),
    );
  }
}
