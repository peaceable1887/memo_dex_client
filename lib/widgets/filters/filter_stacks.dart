import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/services/rest_services.dart';

class FilterStacks extends StatefulWidget {
  const FilterStacks({Key? key}) : super(key: key);

  @override
  State<FilterStacks> createState() => _FilterStacksState();
}

class _FilterStacksState extends State<FilterStacks> {

  String selectedOption = "ALL STACKS";

  @override
  void initState() {
    super.initState();
  }

  String getSortAlgo(sort)
  {
    if(sort == "ASC")
    {
      return "ASC";
    }
    if(sort == "DESC")
    {
      return "DESC";
    }else
    {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
