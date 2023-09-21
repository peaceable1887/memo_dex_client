import 'package:flutter/material.dart';

class ValidationMessageScreen extends StatelessWidget {
  final String errorText;

  ValidationMessageScreen({required this.errorText});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            height: 90,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Fehler:",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        errorText,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: "Inter",
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}
