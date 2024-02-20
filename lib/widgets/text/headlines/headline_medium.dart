import 'package:flutter/material.dart';

class HeadlineMedium extends StatelessWidget
{
  final String text;

  const HeadlineMedium({super.key, required this.text});

  @override
  Widget build(BuildContext context)
  {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
