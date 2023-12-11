import 'package:flutter/material.dart';

class FilterCards extends StatefulWidget {
  const FilterCards({Key? key}) : super(key: key);

  @override
  State<FilterCards> createState() => _FilterCardsState();
}

class _FilterCardsState extends State<FilterCards> {

  String selectedOption = "";

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "ALL CARDS",
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
                position: RelativeRect.fromLTRB(1, 475, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                items: [
                  PopupMenuItem(
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
                  PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Noticed",
                          style: TextStyle(
                            color: selectedOption == "noticed"
                                ? Color(0xFFE59113)
                                : Colors.black,
                            fontWeight: selectedOption == "noticed"
                                ?  FontWeight.w600
                                :  FontWeight.w400,
                          ),
                        ),
                        Icon(
                          Icons.lightbulb_outline,
                          size: 20.0,
                          color: selectedOption == "noticed"
                              ? Color(0xFFE59113)
                              : Colors.black,
                        ),
                      ],
                    ),
                    value: "noticed",
                  ),
                  if (selectedOption == "name" || selectedOption == "date" || selectedOption == "noticed")
                    PopupMenuItem(
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
                      value: "default",
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
              color: selectedOption == "name" || selectedOption == "date" || selectedOption == "noticed"
                  ? Color(0xFFE59113)
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
