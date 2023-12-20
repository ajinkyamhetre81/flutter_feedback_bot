import 'package:feedback_bot/presentation/bloc/chatbloc_bloc.dart';
import 'package:feedback_bot/presentation/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FeedBack Bot', 
      home: BlocProvider(
        create: (context) => ChatBloc(),
        child: const ChatScreen(),
      ),
    );
  }
}

