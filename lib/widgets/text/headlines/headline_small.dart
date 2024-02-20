import 'package:flutter/material.dart';

class HeadlineSmall extends StatelessWidget
{
  final String text;

  const HeadlineSmall({super.key, required this.text});

  @override
  Widget build(BuildContext context)
  {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}
