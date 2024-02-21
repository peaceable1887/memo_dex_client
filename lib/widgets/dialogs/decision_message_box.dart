import 'package:flutter/material.dart';

class DecisionMessageBox extends StatelessWidget
{
  final String headline;
  final String message;
  final String firstButtonText;
  final String secondButtonText;
  final Function(bool) onPressed;

  const DecisionMessageBox({super.key,
    required this.headline,
    required this.message,
    required this.firstButtonText,
    required this.secondButtonText,
    required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: 200.0,
        height: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0,30,0,0),
              child: Column(
                children: [
                  Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 80,
                  ),
                  SizedBox(height: 0),
                  Text(
                    headline,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 27),
            Padding(
              padding: const EdgeInsets.fromLTRB(10,0,10,0),
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: "Inter",
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                borderRadius:  BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft:  Radius.circular(10),
                ),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 140,
                    child: TextButton(
                      onPressed: () => onPressed(true),
                      child: Text(
                        firstButtonText,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 140,
                    child: TextButton(
                      onPressed: () => onPressed(false),
                      child: Text(
                        secondButtonText,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 18,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
