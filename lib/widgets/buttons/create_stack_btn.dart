import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/stack/create_stack_screen.dart';

class CreateStackBtn extends StatelessWidget {
  const CreateStackBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            blurRadius: 15.0,
            offset: Offset(4, 10),
          ),
        ],
      ),
      child: ElevatedButton(
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
            elevation: 0
          ),
          child: Icon(
            Icons.add_rounded,
            size: 100.0,
            color: Theme.of(context).colorScheme.tertiary,
          ),
      ),
    );
  }
}
