import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/create_stack_screen.dart';

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
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        child: Icon(
          Icons.add_rounded,
          size: 100.0,
          color: Color(0xFF8597A1),
        ),
    );
  }
}
