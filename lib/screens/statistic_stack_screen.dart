import 'package:flutter/material.dart';

class StatisticStackScreen extends StatefulWidget {

  final dynamic stackId;

  const StatisticStackScreen({super.key, this.stackId});

  @override
  State<StatisticStackScreen> createState() => _StatisticStackScreenState();
}

class _StatisticStackScreenState extends State<StatisticStackScreen> {
  @override
  Widget build(BuildContext context) {
    return Text('${widget.stackId}');
  }
}
