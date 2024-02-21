import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/widgets/stack_grid.dart';
import 'package:memo_dex_prototyp/widgets/text/headlines/headline_medium.dart';
import '../widgets/dialogs/custom_snackbar.dart';
import '../widgets/custom_search_delegate.dart';
import '../widgets/text/headlines/headline_large.dart';
import '../widgets/header/top_search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String selectedOption = "ALL STACKS";
  bool asc = false;
  final storage = FlutterSecureStorage();

  @override
  void initState()
  {
    super.initState();
    showSnackbarInformation();
  }

  void showSnackbarInformation() async
  {
    String? stackCreated = await storage.read(key: 'stackCreated');
    if(stackCreated == "true")
    {
      CustomSnackbar.showSnackbar(
        context,
        Icons.check_rounded,
        "A stack was successfully created.",
        Colors.green,
        Duration(milliseconds: 500),
        Duration(milliseconds: 1500),
      );
      await storage.write(key: 'stackCreated', value: "false");
    }
  }

  @override
  void dispose()
  {
    showSnackbarInformation();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Column(
            children: [
              TopSearchBar(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(),
                  );
                },
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const HeadlineLarge(text: "Home"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        HeadlineMedium(text: selectedOption),
                        InkWell(
                          onTap: ()
                          {
                            setState(()
                            {
                              asc =! asc;
                            });
                          },
                          child: asc == false ? Icon(
                            Icons.arrow_downward_rounded,
                            size: selectedOption == "ALL STACKS" ? 0.0 : 28.0,
                            color: Theme.of(context).colorScheme.primary,
                          ) : Icon(
                            Icons.arrow_upward_rounded,
                            size: selectedOption == "ALL STACKS" ? 0.0 : 28.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        showMenu(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          context: context,
                          position: RelativeRect.fromLTRB(1, 220, 0, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          items: [
                            PopupMenuItem(
                              onTap: (){
                                setState(() {
                                  selectedOption = "STACKNAME";
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Stackname",
                                    style: TextStyle(
                                      color: selectedOption == "STACKNAME"
                                          ? Theme.of(context).colorScheme.primary
                                          : Theme.of(context).colorScheme.surface,
                                      fontWeight: selectedOption == "STACKNAME"
                                          ?  FontWeight.w600
                                          :  FontWeight.w400,
                                    ),
                                  ),
                                  Icon(
                                    Icons.sort_by_alpha_rounded,
                                    size: 20.0,
                                    color: selectedOption == "STACKNAME"
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.surface,
                                  ),
                                ],
                              ),
                              value: "STACKNAME",
                            ),
                            PopupMenuItem(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Creation Date",
                                    style: TextStyle(
                                      color: selectedOption == "CREATION DATE"
                                          ? Theme.of(context).colorScheme.primary
                                          : Theme.of(context).colorScheme.surface,
                                      fontWeight: selectedOption == "CREATION DATE"
                                          ?  FontWeight.w600
                                          :  FontWeight.w400,
                                    ),
                                  ),
                                  Icon(
                                    Icons.date_range_rounded,
                                    size: 20.0,
                                    color: selectedOption == "CREATION DATE"
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.surface,
                                  ),
                                ],
                              ),
                              value: "CREATION DATE",
                            ),
                            if (selectedOption == "STACKNAME" || selectedOption == "CREATION DATE")
                              PopupMenuItem(
                                onTap: (){
                                  setState(() {
                                    selectedOption = "";
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Reset",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.tertiary,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Icon(
                                      Icons.refresh_rounded,
                                      size: 20.0,
                                      color: Theme.of(context).colorScheme.tertiary,
                                    ),
                                  ],
                                ),
                                value: "ALL STACKS",
                              ),
                          ],
                        ).then((value) {
                          setState(() {
                            print(selectedOption);
                            selectedOption = value!;
                          });
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_alt,
                            size: 32.0,
                            color: selectedOption == "STACKNAME" || selectedOption == "CREATION DATE"
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surface,
                            /*selectedOption == "STACKNAME" || selectedOption == "CREATION DATE"
                                ? Icons.filter_alt : Icons.filter_alt_outlined,
                            size: 32.0,
                            color: Colors.white,*/
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: StackGrid(selectedOption: selectedOption, sortValue: asc,),
              ),
            ],
          ),
        ),
    );

  }
}