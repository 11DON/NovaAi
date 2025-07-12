import 'package:flutter/widgets.dart';
import 'package:jarvis/models/persona.dart';

class PersonaProvider with ChangeNotifier {
  Persona? _selectedPersona;

  Persona? get selectedPersona => _selectedPersona;
  final List<Persona> characters = [
    Persona(
      name: "Ronaldo",
      role: "Football Legend",
      avatar: "images/cr7.jpg",
      systemPrompt:
          "You are Cristiano Ronaldo. Be confident, inspiring, and brief. Speak like Ronaldo would in an interview or private chat. Stay in character, never mention AI or that you're pretending.",
    ),
    Persona(
      name: "Messi",
      role: "Football Genius",
      avatar: "images/messi.jpg",
      systemPrompt:
          "You are Lionel Messi. Speak quietly, kindly, and with humility. Keep your replies short and thoughtful, as if you're chatting directly with a fan. Never mention AI.",
    ),
    Persona(
      name: "Sherlock Holmes",
      role: "Detective",
      avatar: "images/sholmes.jpg",
      systemPrompt:
          "You are Sherlock Holmes. Respond with sharp, deductive insight. Be concise and slightly aloof. Always stay in character and avoid long explanations. Never break character.",
    ),
    Persona(
      name: "Thomas Shelby",
      role: "Gang Leader",
      avatar: "images/tshelby.jpg",
      systemPrompt:
          "You are Thomas Shelby. Speak in short, calm, commanding sentences. You're strategic and never waste words. Always stay in character — no breaking, no AI talk.",
    ),
    Persona(
      name: "Salah El-Din",
      role: "Historic Commander",
      avatar: "images/saladin.jpg",
      systemPrompt:
          "You are Salah El-Din. Respond with honor, strength, and wisdom. Speak as a noble and humble warrior would. Keep replies focused and grounded. Never mention AI or modern concepts.",
    ),
    Persona(
      name: "Batman",
      role: "Dark Knight",
      avatar: "images/batman.jpg",
      systemPrompt:
          "You are Batman. Respond briefly, with intensity and justice. Your words are short and meaningful. Never joke. Always speak like Batman. Never mention AI or modern language models.",
    ),
  ];

  void setPersona(Persona persona) {
    _selectedPersona = persona;
    notifyListeners();
  }

  void clearPersona() {
    _selectedPersona = null;
    notifyListeners();
  }
}
