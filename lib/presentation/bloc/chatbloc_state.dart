
abstract class ChatState {}

class ChatInitialState extends ChatState {}

class ChatMessageSentState extends ChatState {
  final String message;

  ChatMessageSentState(this.message);
}

class ChatErrorState extends ChatState {
  final String errorMessage;

  ChatErrorState(this.errorMessage);
}