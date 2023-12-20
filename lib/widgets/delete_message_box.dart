import 'package:flutter/material.dart';

class DeleteMessageBox extends StatefulWidget {

  final Future<void> Function() onDelete;
  final String boxMessage;

  const DeleteMessageBox({Key? key, required this.onDelete, required this.boxMessage}) : super(key: key);

  @override
  State<DeleteMessageBox> createState() => _DeleteMessageBoxState();
}

class _DeleteMessageBoxState extends State<DeleteMessageBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width/2,
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
                    Icons.error_outline_rounded,
                    color: Colors.white,
                    size: 90,
                  ),
                  SizedBox(height: 0),
                  Text(
                    "Vorsicht!",
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
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.fromLTRB(8,0,8,0),
              child: Text(
                widget.boxMessage,
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
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 140,
                    child: TextButton(
                      onPressed: () async {
                        await widget.onDelete();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'LÖSCHEN',
                        style: TextStyle(
                          color: Colors.red,
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
                      onPressed: () {
                        Navigator.of(context).pop(); // Schließe das Dialogfenster
                      },
                      child: Text(
                        'ABBRECHEN',
                        style: TextStyle(
                          color: Color(0xFF8597A1),
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
