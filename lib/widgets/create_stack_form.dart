import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../screens/bottom_navigation_screen.dart';
import '../services/rest_services.dart';

class CreateStackForm extends StatefulWidget {
  const CreateStackForm({Key? key}) : super(key: key);

  @override
  State<CreateStackForm> createState() => _CreateStackFormState();
}

class _CreateStackFormState extends State<CreateStackForm> {

  Color color = Colors.red;
  late TextEditingController _stackname;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    _stackname = TextEditingController();
    _stackname.addListener(updateButtonState);
    super.initState();
  }

  @override
  void dispose() {
    _stackname.dispose();
    super.dispose();
  }
  void updateButtonState() {
    setState(() {
      if(_stackname.text.isNotEmpty){
        _isButtonEnabled = true;
      }else{
        _isButtonEnabled = false;
      }
    });
  }

  Widget buildColorPicker(){
    return Container(
      height: 330,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(10),
      child: BlockPicker(
        pickerColor: color,
        onColorChanged: (color) => setState(() => this.color = color),
      ),
    );
  }

  void pickColor(BuildContext context){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Color(0xFF00324E),
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(10.0)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                    "Select a Color",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                    ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildColorPicker(),
              Container(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    fixedSize: const Size(300, 50),
                    backgroundColor: Color(0xFFE59113),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  child: Text(
                    "Select",
                    style: TextStyle(
                      color: Color(0xFF00324E),
                      fontSize: 20,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20,0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: TextFormField(
              maxLength: 100,
              controller: _stackname,
              decoration: InputDecoration(
                labelText: "Stackname",
                contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                counterText: "",
                labelStyle: TextStyle(
                  color: Colors.white.withOpacity(0.50),
                  fontSize: 16,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: Icon(Icons.folder_outlined, color: Colors.white, size: 30,),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _stackname.text = "";
                    });
                  },
                  child: Icon(
                    _stackname.text.isNotEmpty ? Icons.cancel : null,
                    color: Colors.white.withOpacity(0.50),
                  ),
                ),// Icon hinzufügen
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF8597A1),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white, // Ändern Sie hier die Farbe des Rahmens im Fokus
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                filled: true,
                fillColor: Color(0xFF33363F),
              ),
              style: TextStyle(
                color: Colors.white, // Ändern Sie die Textfarbe auf Weiß
                fontSize: 16,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF33363F), // Verwenden Sie die ausgewählte Farbe
                  minimumSize: Size(double.infinity, 55),
                  padding: EdgeInsets.fromLTRB(11, 0, 13, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  side: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                  elevation: 0,
                ),
                onPressed: () => pickColor(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.colorize,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "#${color.value.toRadixString(16).substring(2)}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                    Container(
                      width: 22, // Ändern Sie die Breite nach Bedarf
                      height: 22, // Ändern Sie die Höhe nach Bedarf
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
// Container Login or Google Login
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: Container(
              child:
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled
                        ? Color(int.parse("0xFFE59113"))
                        : Color(0xFF8597A1),
                    minimumSize: Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    side: BorderSide(
                      color: _isButtonEnabled
                          ? Color(int.parse("0xFFE59113"))
                          : Color(0xFF8597A1), // Button-Rahmenfarbe ändern, wenn nicht aktiviert
                      width: 2.0,
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isButtonEnabled
                      ? () {
                    setState(() {
                      RestServices(context).createStack(_stackname.text, "${color.value.toRadixString(16).substring(2)}");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavigationScreen(),
                        ),
                      );
                    });
                  }
                      : null, // deaktivert den Button, wenn nicht aktiviert
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create Stack",
                        style: TextStyle(
                          color: _isButtonEnabled
                              ? Color(int.parse("0xFF00324E"))
                              : Color(0xFF8597A1), // Textfarbe ändern, wenn nicht aktiviert
                          fontSize: 20,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ),
          ),// Container Login or Google Login
        ],
      ),
    );
  }
}
