import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc_management/conversation_cubit.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mesajlar'),
        centerTitle: true,
      ),
      body: BlocBuilder<ConversationCubit, ConversationState>(
        builder: (context,state) {
          if(state.isLoading){
            return const Center(child: CircularProgressIndicator());
          }
          if(state.error != null){
            return Center(child: Text(state.error!));
          }
          return ListView.builder(
            itemCount: state.conversations.length,
            itemBuilder: (context, index) {
              final conversation = state.conversations;
              return ConversationItem(
                conversation: conversation[index],
                onTap: () {
                 context.push('/chatScreen',extra: {
                   'conversation_id': conversation[index].id,
                   'product_id': conversation[index].productId,
                   'seller_id': conversation[index].sellerId
                 });
                },
              );
            },
          );
        }
      ),
    );
  }
}


class ConversationItem extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ConversationItem({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    //final lastMessage = '';

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Text(
          conversation.productId[0].toUpperCase(),
          style: const TextStyle(color: Colors.black),
        ),
      ),
      title: Text(
        conversation.sellerId,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
     /* subtitle: Text(
        lastMessage.text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey[600]),
      ),trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(lastMessage.time),
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
          if (lastMessage.isMe)
            const Icon(
              Icons.done_all,
              size: 16,
              color: Colors.blue,
            ),
        ],
      ),*/
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      return 'Dünən';
    } else {
      return '${time.day}.${time.month}';
    }
  }
}




