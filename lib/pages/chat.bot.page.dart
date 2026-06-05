import 'package:chat_bot_app/bloc/chat.bot.bloc.dart';
import 'package:chat_bot_app/model/chat.bot.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(BuildContext context) {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    context.read<ChatBotBloc>().add(AskLLMEvent(query: query));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Chat Bot",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text("DEBUG",
                style: TextStyle(color: Colors.white, fontSize: 10)),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Liste des messages ──
          Expanded(
            child: BlocBuilder<ChatBotBloc, ChatBotState>(
              builder: (context, state) {
                _scrollToBottom();

                // ── PENDING STATE ──
                if (state is ChatBotPendingState) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                // ── ERROR STATE ──
                if (state is ChatBotErrorState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          state.errorMessage,
                          style:
                              const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final last =
                              context.read<ChatBotBloc>().lastEvent;
                          if (last != null) {
                            context
                                .read<ChatBotBloc>()
                                .add(last);
                          }
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  );
                }

                // ── SUCCESS / INITIAL STATE ──
                final messages = state.messages;
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final Message msg = messages[index];
                    final isUser = msg.type == "user";

                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          if (!isUser)
                            const Padding(
                              padding: EdgeInsets.only(
                                  right: 8, top: 4),
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.smart_toy,
                                    size: 18,
                                    color: Colors.white),
                              ),
                            ),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? Colors.green.shade400
                                    : Colors.white,
                                borderRadius:
                                    BorderRadius.circular(12),
                                border: isUser
                                    ? null
                                    : Border.all(
                                        color:
                                            Colors.grey.shade200),
                              ),
                              child: Text(
                                msg.message,
                                style: TextStyle(
                                  color: isUser
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          if (isUser)
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: 8, top: 4),
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.person,
                                    size: 18,
                                    color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // ── Barre de saisie ──
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Votre message...",
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(context),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_red_eye_outlined,
                      color: Colors.grey),
                  onPressed: () {},
                ),
                IconButton(
                  icon:
                      const Icon(Icons.send, color: Colors.teal),
                  onPressed: () => _sendMessage(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
