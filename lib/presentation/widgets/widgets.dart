import 'package:flutter/material.dart';

class SentWidget extends StatelessWidget {
  const SentWidget({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(233, 236, 244, 1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(message),
            ),
          ),
        ],
      ),
    );
  }
}

class ReceivedWidget extends StatelessWidget {
  const ReceivedWidget({Key? key, required this.msg}) : super(key: key);

  final String msg;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.asset(
                "assets/logo.png",
                height: 30,
                width: 30,
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(233, 236, 244, 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    msg,
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
