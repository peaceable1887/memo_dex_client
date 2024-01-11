import 'package:flutter/material.dart';

class Filters
{
  void FilterStacks(List<Widget> content ,List<dynamic> fileContent, String selection, bool order)
  {
    if(selection == "STACKNAME" && order == false)
    {
      fileContent.sort((a, b) => a['stackname'].compareTo(b['stackname']));
      content.clear();
    }
    if(selection == "STACKNAME" && order == true)
    {
      fileContent.sort((a, b) => b['stackname'].compareTo(a['stackname']));
      content.clear();
    }
    if(selection == "CREATION DATE" && order == false)
    {
      fileContent.sort((a, b) => DateTime.parse(a['creation_date']).compareTo(DateTime.parse(b['creation_date'])));
      content.clear();
    }
    if(selection == "CREATION DATE" && order == true)
    {
      fileContent.sort((a, b) => DateTime.parse(b['creation_date']).compareTo(DateTime.parse(a['creation_date'])));
      content.clear();
    }
    else
    {
      content.clear();
    }
  }

  void FilterCards(List<Widget> content ,List<dynamic> fileContent, String selection, bool order)
  {
    if(selection == "QUESTION" && order == false)
    {
      fileContent.sort((a, b) => a['question'].compareTo(b['question']));
      content.clear();
    }
    if(selection == "QUESTION" && order == true)
    {
      fileContent.sort((a, b) => b['question'].compareTo(a['question']));
      content.clear();
    }
    if(selection == "CREATION DATE" && order == false)
    {
      fileContent.sort((a, b) => DateTime.parse(a['creation_date']).compareTo(DateTime.parse(b['creation_date'])));
      content.clear();
    }
    if(selection == "CREATION DATE" && order == true)
    {
      fileContent.sort((a, b) => DateTime.parse(b['creation_date']).compareTo(DateTime.parse(a['creation_date'])));
      content.clear();
    }
    if(selection == "NOTICED" && order == false)
    {
      fileContent.sort((a, b) => b['remember'].compareTo(a['remember']));
      content.clear();
    }
    if(selection == "NOTICED" && order == true)
    {
      fileContent.sort((a, b) => a['remember'].compareTo(b['remember']));
      content.clear();
    }
    else
    {
      content.clear();
    }
  }
}