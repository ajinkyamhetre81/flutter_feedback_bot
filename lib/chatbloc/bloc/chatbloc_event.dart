abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String message;

  SendMessageEvent(this.message);
}

class ChatErrorEvent extends ChatEvent {
  final String message;

  ChatErrorEvent(this.message);
}