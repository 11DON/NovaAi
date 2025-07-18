import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jarvis/Providers/chat_provider.dart';
import 'package:jarvis/Providers/persona_provider.dart';
import 'package:jarvis/components/my_third_button.dart';
import 'package:jarvis/models/persona.dart';
import 'package:jarvis/pages/chat_page.dart';
import 'package:provider/provider.dart';

class CreateCharacterPage extends StatefulWidget {
  const CreateCharacterPage({super.key});

  @override
  State<CreateCharacterPage> createState() => _CreateCharacterPageState();
}

class _CreateCharacterPageState extends State<CreateCharacterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Create New Character")),
        ),
        body: CustomScrollView(
          slivers: [
            /* 
              
              
              
              upload the chracter Img using Image_picker
              
              
               */
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Character Image",
                  style: TextStyle(
                      fontFamily: 'Roboto-Regular',
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              sliver: SliverToBoxAdapter(
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.tertiary),
                  child: GestureDetector(
                    onTap: () async {
                      final pickedFile =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          _pickedImage = File(pickedFile.path);
                          print("THIS IS THE IMG PATH$_pickedImage");
                        });
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_pickedImage != null)
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _pickedImage!,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        else ...[
                          Icon(Icons.image_search,
                              size: 48,
                              color: Theme.of(context).colorScheme.secondary),
                          Text(
                            "Upload Character Image",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          Text(
                            "Tap to add image",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /* 
              
              
              
              Upload the Character's Name
              
              
               */
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Character Name",
                  style: TextStyle(
                      fontFamily: 'Roboto-Regular',
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              sliver: SliverToBoxAdapter(
                child: TextField(
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.tertiary,
                      hintText: "e.g., Professor Wisdom",
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .inversePrimary
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.4)),
                      )),
                  controller: nameController,
                ),
              ),
            ),
            /* 
              
              
              
              Upload the Character's describtion
              
              

               */
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Personality Describtion",
                  style: TextStyle(
                      fontFamily: 'Roboto-Regular',
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  height: 150,
                  child: TextField(
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                        hintText:
                            "Describe the character's traits and behavior. Max 500 words.",
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .inversePrimary
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.4)),
                        )),
                    controller: descController,
                    maxLines: 9,
                  ),
                ),
              ),
            ),
            /* 
              
              
              
              Confirm
              
              
              
               */
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              sliver: SliverToBoxAdapter(
                child: MyThirdButton(
                  color: Theme.of(context).colorScheme.primary,
                  height: 60,
                  icon: const Icon(Icons.add_circle_outline),
                  title: "Create Character",
                  width: 200,
                  onTap: () {
                    final name = nameController.text.trim();
                    final describtion = descController.text.trim();
                    final chatProvider =
                        Provider.of<ChatProvider>(context, listen: false);
                    final personaProvider =
                        Provider.of<PersonaProvider>(context, listen: false);
                    final systemPrompt =
                        "Your name is $name. and u  $describtion. Only talk like that person. Never mention you are an AI.";
                    final avatarPath = _pickedImage?.path;
                    final newPersona = Persona(
                        name: name,
                        role: name,
                        systemPrompt: systemPrompt,
                        avatar: avatarPath.toString());
                    print(_pickedImage);
                    personaProvider.setPersona(newPersona);
                    personaProvider.addPersona(newPersona);
                    chatProvider.startPersonaSession(newPersona);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatPage(sessionKey: newPersona.sessionKey),
                      ),
                    );
                  },
                ),
              ),
            ),
            /* 
              
              
              
              Cancel
              
              
              
               */
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              sliver: SliverToBoxAdapter(
                child: MyThirdButton(
                    color: Theme.of(context).colorScheme.tertiary,
                    height: 60,
                    icon: const Icon(Icons.cancel_outlined),
                    title: "Cancel",
                    width: 200,
                    onTap: () {
                      nameController.clear();
                      descController.clear();
                      Navigator.pop(context);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
