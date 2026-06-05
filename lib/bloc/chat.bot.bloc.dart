import 'package:chat_bot_app/model/chat.bot.model.dart';
import 'package:chat_bot_app/repository/chat.bot.repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── EVENTS ──────────────────────────────────────
abstract class ChatBotEvent {}

class AskLLMEvent extends ChatBotEvent {
  final String query;
  AskLLMEvent({required this.query});
}

// ── STATES ──────────────────────────────────────
abstract class ChatBotState {
  final List<Message> messages;
  ChatBotState({required this.messages});
}

class ChatBotInitialState extends ChatBotState {
  ChatBotInitialState()
      : super(messages: [
          Message(message: "Hello", type: "user"),
          Message(message: "How can i help you", type: "assistant"),
        ]);
}

class ChatBotPendingState extends ChatBotState {
  ChatBotPendingState({required super.messages});
}

class ChatBotSuccessState extends ChatBotState {
  ChatBotSuccessState({required super.messages});
}

class ChatBotErrorState extends ChatBotState {
  final String errorMessage;
  ChatBotErrorState({
    required super.messages,
    required this.errorMessage,
  });
}

// ── BLOC ────────────────────────────────────────
class ChatBotBloc extends Bloc<ChatBotEvent, ChatBotState> {
  final ChatBotRepository chatBotRepository = ChatBotRepository();
  ChatBotEvent? lastEvent;

  ChatBotBloc() : super(ChatBotInitialState()) {
    on<AskLLMEvent>((event, emit) async {
      print("AskLLMEvent occured");
      lastEvent = event;

      List<Message> currentMessages = List.from(state.messages);
      emit(ChatBotPendingState(messages: state.messages));
      currentMessages.add(Message(message: event.query, type: "user"));

      try {
        Message responseMessage =
            await chatBotRepository.askLargeLangueModelGPT(event.query);
        currentMessages.add(responseMessage);
        emit(ChatBotSuccessState(messages: currentMessages));
      } catch (e) {
        emit(ChatBotErrorState(
          messages: state.messages,
          errorMessage: e.toString(),
        ));
      }
    });
  }
}
