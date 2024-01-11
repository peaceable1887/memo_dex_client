import 'package:flutter/material.dart';

class CustomSnackbar {
  static void showSnackbar(BuildContext context, IconData iconType, String message, Color backgroundColor, Duration delay, Duration duration) {
    Future.delayed(delay, () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0.0,
          content: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Row(
                      children: [
                        Icon(
                          iconType,
                          size: 22.0,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Text(
                            message,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          duration: duration,
        ),
      );
    });
  }
}
