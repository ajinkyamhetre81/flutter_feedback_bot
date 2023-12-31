import 'package:bloc/bloc.dart';
import 'package:feedback_bot/presentation/bloc/chatbloc_event.dart';
import 'chatbloc_state.dart';
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitialState());

  
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is SendMessageEvent) {
      try {
        // Simulate an API call delay (replace with actual API call)
        await Future.delayed(const Duration(seconds: 2));

        // Simulate success
        yield ChatMessageSentState(event.message);
      } catch (e) {
        // Simulate error
        yield ChatErrorState("Error sending message: $e");
      }
    }
  }
}

