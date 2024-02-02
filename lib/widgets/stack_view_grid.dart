import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/services/api/api_client.dart';
import 'package:memo_dex_prototyp/services/local/upload_to_database.dart';
import 'package:memo_dex_prototyp/widgets/create_stack_btn.dart';
import 'package:memo_dex_prototyp/widgets/stack_btn.dart';
import '../utils/filters.dart';
import '../services/local/file_handler.dart';

class StackViewGrid extends StatefulWidget {
  final String? selectedOption;
  final bool? sortValue;

  StackViewGrid({Key? key, this.selectedOption, this.sortValue}) : super(key: key);

  @override
  State<StackViewGrid> createState() => _StackViewGridState();
}

class _StackViewGridState extends State<StackViewGrid> {
  List<Widget> stackButtons = [];
  FileHandler fileHandler = FileHandler();
  final filter = Filters();
  bool showLoadingCircular = true;
  late StreamSubscription subscription;
  final storage = FlutterSecureStorage();

  @override
  void initState()
  {
    super.initState();
    loadStacks(widget.selectedOption, widget.sortValue);
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result)
    {
      loadStacks(widget.selectedOption, widget.sortValue);
    });
  }

  @override
  void didUpdateWidget(covariant StackViewGrid oldWidget)
  {
    if (oldWidget.selectedOption != widget.selectedOption || oldWidget.sortValue != widget.sortValue) {
      loadStacks(widget.selectedOption, widget.sortValue);
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> loadStacks(String? selectedOption, bool? sortValue) async
  {
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);

    if(isConnected == false)
    {
      setState(()
      {
        showLoadingCircular = false;
      });

      String localStackContent = await fileHandler.readJsonFromLocalFile("allStacks");

      // Überprüfe ob der Inhalt Liste ist
      if (localStackContent.isNotEmpty) {

        List<dynamic> stackContent = jsonDecode(localStackContent);

        filter.FilterStacks(stackButtons, stackContent, selectedOption!, sortValue!);

        for (var stack in stackContent)
        {
          if (stack['is_deleted'] == 0) {
            stackButtons.add(StackBtn(
              stackId: stack['stack_id'],
              iconColor: stack['color'],
              stackName: stack['stackname'],
            ));
          }
        }
        stackButtons.add(CreateStackBtn());
      } else
      {
        // Handle den Fall, wenn eine der Dateien leer ist
      }

    }else
    {
      await UploadToDatabase(context).allLocalStackContent();
      await UploadToDatabase(context).updateAllLocalStacks();
      await ApiClient(context).stackApi.getAllStacks();

      setState(()
      {
        showLoadingCircular = false;
      });

      String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");
      // Überprüfe ob der Inhalt eine Liste ist
      if (fileContent.isNotEmpty)
      {
        List<dynamic> stackFileContent = jsonDecode(fileContent);

        filter.FilterStacks(stackButtons, stackFileContent, selectedOption!, sortValue!);

        for (var stack in stackFileContent)
        {
          if (stack['is_deleted'] == 0)
          {
            stackButtons.add(StackBtn(
                stackId: stack['stack_id'],
                iconColor: stack['color'],
                stackName: stack['stackname']
            ));

            //Updated alle Karten die Offline erstellt wurden, bei dem der Stack Online erstellt wurde
            //kann eventuell raus
            await UploadToDatabase(context).allLocalCards(stack['stack_id'], stack['stack_id']);

            await UploadToDatabase(context).updateAllLocalCards(stack['stack_id']);

            await UploadToDatabase(context).updateAllLocalCardStatistic(stack['stack_id']);
          }

        }
        stackButtons.add(CreateStackBtn());

      }else{}

    }
    // Widget wird aktualisiert nach dem Laden der Daten.
    if (mounted)
    {
      setState((){});
    }
  }

  @override
  void dispose()
  {
    print("dispose stackviewgrid");
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return showLoadingCircular ?
      Container(
          height: MediaQuery.of(context).size.height/2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ],
          )
      )
      : GridView.builder(
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