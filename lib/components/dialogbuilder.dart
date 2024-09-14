import 'package:flutter/material.dart';

class DialogBuilder extends StatefulWidget {
  const DialogBuilder({super.key});

  @override
  State<DialogBuilder> createState() => _DialogBuilderState();
}

class _DialogBuilderState extends State<DialogBuilder> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  // ignore: unused_element
  static Future<void> _dialogBuilder(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Container(
            width: double.infinity,
            color: Colors.amber,
            height: screenHeight,
          ),
        );
      },
    );
  }
}
