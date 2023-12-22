
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:feedback_bot/presentation/bloc/chatbloc_bloc.dart';
import 'package:feedback_bot/presentation/bloc/chatbloc_event.dart';
import 'package:feedback_bot/presentation/bloc/chatbloc_state.dart';
import 'package:feedback_bot/data/api_service.dart';
import 'package:feedback_bot/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController textEditingController;
  List<Map<String, String>> messages = [
    {
      "type": "received",
      "msg": "Hi, Welcome to Centralogic Feedback Agent! Thank you for your interest in CentraLogic!",
    }
  ];
  final String apiUrl = "https://sapdos-api.azurewebsites.net/api/Credentials/FeedbackJoiningBot";

  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    checkConnectivity();
    apiService = ApiService(apiUrl);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // Show snackbar
      const snackBar = SnackBar(
        content: Text('No internet connection'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    double dividerWidth = MediaQuery.of(context).size.width * 0.5;
    checkConnectivity();

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to CentraLogic!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
            ),
            Text(
              'Hi, Charles',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatErrorState) {
            if (state.errorMessage.toLowerCase().contains("network")) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please connect to the internet.'),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Divider(
                        thickness: 1,
                      ),
                      Image.asset(
                        "assets/logo.png",
                        height: 64,
                        width: 64,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'CentraLogic BOT',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text("Hi, I'm your feedback agent"),
                      SizedBox(
                        width: dividerWidth,
                        child: const Divider(
                          thickness: 1,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        constraints: const BoxConstraints(maxWidth: 936),
                        child: Column(
                          children: [
                            // Combined messages
                            ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                if (message["type"] == "received") {
                                  return ReceivedWidget(
                                    msg: message["msg"]!,
                                  );
                                } else {
                                  return SentWidget(
                                    message: message["msg"]!,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 936),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        color: const Color.fromRGBO(233, 236, 244, 1),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.black),
                          controller: textEditingController,
                          onFieldSubmitted: (value) {
                            // to send message
                            sendMessage(value);
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.link),
                            hintText: "How can I help you ?",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CupertinoButton(
                      onPressed: () {
                        sendMessage(textEditingController.text);
                      },
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                      color: const Color.fromARGB(255, 21, 70, 95),
                      borderRadius: BorderRadius.circular(8.0),
                      child: const Text(
                        "Send",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void sendMessage(String message) async {
    if (message.isNotEmpty) {
      setState(() {
        messages.add({"type": "sent", "msg": message});
        textEditingController.clear();
      });
      await fetchApiData(message);
    }
  }
  Future<void> fetchApiData(String userMessage) async {
    try {
      int step=int.parse(userMessage);
      final Map<String, dynamic>? data = await apiService.fetchData(step);
      if (data != null && data['type'] == 'PROMPT' ) {
        setState(() {
         final String promptMessage = data['message'];
          messages.add({"type": "received", "msg": promptMessage});
        });
      }
    } catch (e) {
      BlocProvider.of<ChatBloc>(context).add(
        ChatErrorEvent(e.toString()),
      );
    }
  }
}
