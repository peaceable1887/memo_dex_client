import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/services/rest_services.dart';
import 'package:memo_dex_prototyp/widgets/create_stack_btn.dart';
import 'package:memo_dex_prototyp/widgets/stack_btn.dart';

class StackViewGrid extends StatefulWidget {
  StackViewGrid({Key? key}) : super(key: key);

  @override
  State<StackViewGrid> createState() => _StackViewGridState();
}

class _StackViewGridState extends State<StackViewGrid> {

  final List<Widget> stackButtons = [];

  @override
  void initState() {
    super.initState();
    loadStacks();
  }

  Future<void> loadStacks() async {
    try {

      final stacksData = await RestServices(context).getAllStacks();

      for (var stack in stacksData) {
        stackButtons.add(StackBtn(stackId: stack['stack_id'],iconColor: stack['color'], stackName: stack['stackname']));
      }

      stackButtons.add(CreateStackBtn());

      // Widget wird aktualisiert nnach dem Laden der Daten.
      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      print('Fehler beim Laden der Daten: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 2.3),
      ),
      itemBuilder: (context, index) {
        return stackButtons[index];
      },
      itemCount: stackButtons.length,
    );
  }
}