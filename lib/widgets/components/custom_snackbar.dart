import 'package:flutter/material.dart';

class CustomSnackbar {
  static void showSnackbar(BuildContext context, String headline, String message, Color backgroundColor, Duration delay) {
    Future.delayed(delay, () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0.0,
          content: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Text(
                          headline,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
      );
    });
  }
}
