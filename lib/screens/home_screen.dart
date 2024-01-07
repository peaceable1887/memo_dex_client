import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/widgets/stack_view_grid.dart';
import '../widgets/custom_search_delegate.dart';
import '../widgets/headline.dart';
import '../widgets/filters/filter_stacks.dart';
import '../widgets/top_search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String selectedOption = "ALL STACKS";
  bool asc = false;

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Color(0xFF00324E),
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
                    Headline(text: "Home"),
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
                        Text(
                          selectedOption,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600
                          ),
                        ),
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
                            color: Color(0xFFE59113),
                          ) : Icon(
                            Icons.arrow_upward_rounded,
                            size: selectedOption == "ALL STACKS" ? 0.0 : 28.0,
                            color: Color(0xFFE59113),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(1, 240, 0, 0),
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
                                          ? Color(0xFFE59113)
                                          : Colors.black,
                                      fontWeight: selectedOption == "STACKNAME"
                                          ?  FontWeight.w600
                                          :  FontWeight.w400,
                                    ),
                                  ),
                                  Icon(
                                    Icons.sort_by_alpha_rounded,
                                    size: 20.0,
                                    color: selectedOption == "STACKNAME"
                                        ? Color(0xFFE59113)
                                        : Colors.black,
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
                                          ? Color(0xFFE59113)
                                          : Colors.black,
                                      fontWeight: selectedOption == "CREATION DATE"
                                          ?  FontWeight.w600
                                          :  FontWeight.w400,
                                    ),
                                  ),
                                  Icon(
                                    Icons.date_range_rounded,
                                    size: 20.0,
                                    color: selectedOption == "CREATION DATE"
                                        ? Color(0xFFE59113)
                                        : Colors.black,
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
                                        color: Colors.grey,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Icon(
                                      Icons.refresh_rounded,
                                      size: 20.0,
                                      color: Colors.grey,
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
                                ? Color(0xFFE59113)
                                : Colors.white,
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
                child: StackViewGrid(selectedOption: selectedOption, sortValue: asc,),
              ),
            ],
          ),
        ),
    );

  }
}