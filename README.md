# ChatBot Flutter - BLOC Pattern (Partie 2)

## Objectif
Refactoring du ChatBot (TP2) en appliquant le **BLOC State Management Pattern** pour séparer la logique UI de la logique applicative.

## Architecture BLOC
lib/
├── main.dart
├── model/
│   └── chat.bot.model.dart          # Modèle Message
├── repository/
│   └── chat.bot.repository.dart     # Appel API (OpenAI/Ollama)
├── bloc/
│   └── chat.bot.bloc.dart           # Events + States + Bloc
└── pages/
├── login.page.dart              # Login (admin/1234)
└── chat.bot.page.dart           # UI avec BlocBuilder
## Events
- `AskLLMEvent(query)` — envoi d'une question

## States
| State | Description |
|-------|-------------|
| `ChatBotInitialState` | Messages initiaux Hello/How can i help you |
| `ChatBotPendingState` | Chargement en cours (CircularProgressIndicator) |
| `ChatBotSuccessState` | Réponse reçue avec succès |
| `ChatBotErrorState` | Erreur API + bouton Retry |

## Dépendances
- `flutter_bloc: ^8.1.3`
- `http: ^1.2.0`

## Lancer le projet
```bash
flutter pub get
flutter run
```

## Références
- Part 1 Counter: https://www.youtube.com/watch?v=PtYSPm8KWxw
- Part 2 ChatBot: https://www.youtube.com/watch?v=rXwIwp_lJu8
