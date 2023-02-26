enum MessageType  {TEXT, IMAGE, AUDIO}
class Message {
  String id;
  bool read;
  String content;
  int duration = 0;
  String user;
  bool trainer;
  MessageType type;
  DateTime date;

  Message({required this.id,
    required this.content,
    required this.type,
    required this.user,
    required this.trainer,
    required this.date,
    required this.read });

  Message.empty(this.user)
      : id = '',
        read = false,
        content = '',
        duration = 0,
        trainer = false,
        type = MessageType.TEXT,
        date = DateTime(1000);

  Message.create(this.content,this.type, this.user, {int? duration}):
    trainer = false,
    read= false,
    duration = duration ?? 0,
    id= '',
    date = DateTime.now();

  Message.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        read = map['read'],
        content = map['content'],
        duration = map['duration'],
        user = map['user'],
        trainer = map['trainer'],
        type = MessageType.values.firstWhere((type) => type.name == map['type']),
        date = map['date'].toDate();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'read': read,
      'content': content,
      'duration': duration,
      'user': user,
      'trainer': trainer,
      'type': type.name,
      'date': date,
    };
  }

  @override
  String toString() {
    return 'Message{id: $id, read: $read, content: $content, duration: $duration, user: $user, trainer: $trainer, type: $type, date: $date}';
  }

  @override
  int get hashCode => Object.hash(read, content, user, trainer, type, date, duration);

  @override
  bool operator ==(other) => other is Message && content == other.content && user == other.user && date == date;
}