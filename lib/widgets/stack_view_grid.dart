import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/widgets/create_stack_btn.dart';
import 'package:memo_dex_prototyp/widgets/stack_btn.dart';

class StackViewGrid extends StatelessWidget {

  final List<Widget> exampleList = [
    StackBtn(iconColor: "E51313",stackName: "Computer Science",),
    StackBtn(iconColor: "34A853",stackName: "Geographic",),
    StackBtn(iconColor: "00A399",stackName: "IT Secruity",),
    CreateStackBtn(),
  ];

  StackViewGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index){
          return exampleList[index];
        },
      itemCount: exampleList.length,
    );
  }
}
