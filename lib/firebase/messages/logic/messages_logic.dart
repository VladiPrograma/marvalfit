import 'package:creator/creator.dart';
import 'package:marvalfit/firebase/messages/model/message.dart';
import 'package:marvalfit/firebase/messages/repository/message_repository.dart';


class MessagesLogic{
  MessageRepository repo = MessageRepository();

  void fetchMore(Ref ref, {int? n}) => repo.fetchMore(ref, n: n);
  void fetchReset(Ref ref) => repo.fetchReset(ref);
  List<Message> get(Ref ref, String userId) => repo.getChat(ref, userId);

  List<Message> getUnread(Ref ref) => repo.getUnread(ref);
  List<Message> getUnreadById(Ref ref, String userId) => repo.getUnread(ref).where((msg) => msg.user == userId && !msg.trainer ).toList();

  List<Message> getChat(Ref ref, String userId) => repo.getChat(ref, userId);

  Message? getLastById(Ref ref, String userId){
   List<Message> chat= repo.getChat(ref, userId);
   return chat.isNotEmpty ? chat.first : null;
  }

  Future<void> add(Ref ref, Message message){
    message.date = DateTime.now();
    message.id = message.hashCode.toString();
    return repo.add(ref, message);
  }
  Future<void> read(Message message) =>  repo.update(message.id, {'read': true});

}