import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/stack/create_stack_screen.dart';

class CreateStackBtn extends StatelessWidget {
  const CreateStackBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CreateStackScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        child: Icon(
          Icons.add_rounded,
          size: 100.0,
          color: Theme.of(context).colorScheme.tertiary,
        ),
    );
  }
}
