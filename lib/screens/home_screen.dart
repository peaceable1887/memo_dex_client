import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/widgets/stack_view_grid.dart';
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
  String sortValue = "ASC";

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
                                  sortValue = "DESC";
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Name",
                                    style: TextStyle(
                                      color: selectedOption == "name"
                                          ? Color(0xFFE59113)
                                          : Colors.black,
                                      fontWeight: selectedOption == "name"
                                          ?  FontWeight.w600
                                          :  FontWeight.w400,
                                    ),
                                  ),
                                  Icon(
                                    Icons.sort_by_alpha_rounded,
                                    size: 20.0,
                                    color: selectedOption == "name"
                                        ? Color(0xFFE59113)
                                        : Colors.black,
                                  ),
                                ],
                              ),
                              value: "name",
                            ),
                            PopupMenuItem(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Creation Date",
                                    style: TextStyle(
                                      color: selectedOption == "date"
                                          ? Color(0xFFE59113)
                                          : Colors.black,
                                      fontWeight: selectedOption == "date"
                                          ?  FontWeight.w600
                                          :  FontWeight.w400,
                                    ),
                                  ),
                                  Icon(
                                    Icons.date_range_rounded,
                                    size: 20.0,
                                    color: selectedOption == "date"
                                        ? Color(0xFFE59113)
                                        : Colors.black,
                                  ),
                                ],
                              ),
                              value: "date",
                            ),
                            if (selectedOption == "name" || selectedOption == "date")
                              PopupMenuItem(
                                onTap: (){
                                  setState(() {
                                    sortValue = "";
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
                                      Icons.cancel,
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
                            selectedOption = value!;
                          });
                        });
                      },
                      child: Icon(
                        Icons.filter_alt,
                        size: 32.0,
                        color: selectedOption == "name" || selectedOption == "date"
                            ? Color(0xFFE59113)
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: StackViewGrid(sortValue: sortValue),
              ),
            ],
          ),
        ),
    );

  }
}