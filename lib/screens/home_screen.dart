import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/widgets/stack_grid.dart';
import 'package:memo_dex_prototyp/widgets/text/headlines/headline_medium.dart';
import '../utils/divide_painter.dart';
import '../widgets/dialogs/custom_snackbar.dart';
import '../widgets/custom_search_delegate.dart';
import '../widgets/text/headlines/headline_large.dart';

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
          extendBodyBehindAppBar: true,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0,
                scrolledUnderElevation: 0,
                centerTitle: true,
                expandedHeight: 130,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                floating: false,
                pinned: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,10,0),
                    child: IconButton(
                      color: Theme.of(context).colorScheme.surface,
                      icon: Icon(Icons.search, size: 32.0,),
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(),
                        );
                      },
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  expandedTitleScale: 2,
                  titlePadding: EdgeInsets.only(bottom: 15),
                  centerTitle: true,
                  title: const HeadlineLarge(text: "Home", isInSliverAppBar: true,),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                          showModalBottomSheet(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            context: context,
                            builder: (BuildContext context){
                              return SizedBox(
                                height: 250,
                                child: Column(
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: Container(
                                          height: 7,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).scaffoldBackgroundColor,
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 45),
                                    CustomPaint(
                                      size: Size(MediaQuery.of(context).size.width, 0.2),
                                      painter: DividePainter(Theme.of(context).scaffoldBackgroundColor),
                                    ),
                                    SizedBox(height: 15),
                                    PopupMenuItem(
                                      onTap: (){
                                        setState(() {
                                          selectedOption = "STACKNAME";
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                            child: Icon(
                                              Icons.sort_by_alpha_rounded,
                                              size: 30.0,
                                              color: selectedOption == "STACKNAME"
                                                  ? Theme.of(context).colorScheme.primary
                                                  : Theme.of(context).colorScheme.onSurface,
                                            ),
                                          ),
                                          Text(
                                            "Stackname",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: selectedOption == "STACKNAME"
                                                  ? Theme.of(context).colorScheme.primary
                                                  : Theme.of(context).colorScheme.onSurface,
                                              fontWeight: selectedOption == "STACKNAME"
                                                  ?  FontWeight.w600
                                                  :  FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      value: "STACKNAME",
                                    ),
                                    SizedBox(height: 5),
                                    PopupMenuItem(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                            child: Icon(
                                              Icons.date_range_rounded,
                                              size: 30.0,
                                              color: selectedOption == "CREATION DATE"
                                                  ? Theme.of(context).colorScheme.primary
                                                  : Theme.of(context).colorScheme.onSurface,
                                            ),
                                          ),
                                          Text(
                                            "Creation Date",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: selectedOption == "CREATION DATE"
                                                  ? Theme.of(context).colorScheme.primary
                                                  : Theme.of(context).colorScheme.onSurface,
                                              fontWeight: selectedOption == "CREATION DATE"
                                                  ?  FontWeight.w600
                                                  :  FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      value: "CREATION DATE",
                                    ),
                                    SizedBox(height: 5),
                                    PopupMenuItem(
                                      onTap: (selectedOption == "STACKNAME" || selectedOption == "CREATION DATE") ? (){
                                        setState(() {
                                          selectedOption = "";
                                        });
                                      } : (){},
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                            child: Icon(
                                              Icons.refresh_rounded,
                                              size: 30.0,
                                              color: (selectedOption == "STACKNAME" || selectedOption == "CREATION DATE") ? Colors.white : Theme.of(context).colorScheme.tertiary,
                                            ),
                                          ),
                                          Text(
                                            "Reset",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: (selectedOption == "STACKNAME" || selectedOption == "CREATION DATE") ? Colors.white : Theme.of(context).colorScheme.tertiary,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      value: "ALL STACKS",
                                    ),
                                  ],
                                )
                              );
                            },
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
              ),
              StackGrid(selectedOption: selectedOption, sortValue: asc,),
            ],
          ),
        ),
    );

  }
}