import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwitchBtn extends StatefulWidget
{
  final String buttonText;
  final List<double> buttonBorderRadius;

  const SwitchBtn({
    super.key,
    required this.buttonText,
    required this.buttonBorderRadius,});

  @override
  State<SwitchBtn> createState() => _SwitchBtnState();
}

class _SwitchBtnState extends State<SwitchBtn>
{
  late SharedPreferences _prefs;

  @override
  void initState()
  {
    super.initState();
    init();
  }

  Future init() async
  {
    _prefs = await SharedPreferences.getInstance();
  }

  void toggleDarkMode(bool value)
  {
    if(value == true)
    {
      _prefs.setBool("isDarkMode", true);
    }else
    {
      _prefs.setBool("isDarkMode", false);
    }
  }

  final MaterialStateProperty<Icon?> thumbIcon =
    MaterialStateProperty.resolveWith<Icon?>((Set<MaterialState> states)
    {
      if (states.contains(MaterialState.selected))
      {
        return const Icon(Icons.dark_mode_rounded, color: Color(0xFFE59113));
      }
      return const Icon(Icons.light_mode_rounded, color: Color(0xFFE59113));
    },
  );

  @override
  void dispose()
  {
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.buttonBorderRadius[1]),
          topRight: Radius.circular(widget.buttonBorderRadius[0]),
          bottomRight: Radius.circular(widget.buttonBorderRadius[2]),
          bottomLeft: Radius.circular(widget.buttonBorderRadius[3]),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            blurRadius: 15.0,
            offset: Offset(4, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.buttonText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Container(
                height: 5,
                child: Switch(
                  thumbIcon: thumbIcon,
                  value: isDarkMode,
                  activeColor: Color(0xFF001E2F),
                  inactiveThumbColor: Colors.white,
                  activeTrackColor: Color(0xFF00324E),
                  inactiveTrackColor: Color(0xFF63ABFD),
                  trackOutlineColor: Theme.of(context).switchTheme.trackOutlineColor,
                  thumbColor: Theme.of(context).switchTheme.thumbColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (bool value)
                  {
                    toggleDarkMode(value);
                    setState(()
                    {
                      Get.changeThemeMode(
                          _prefs.getBool("isDarkMode")! ? ThemeMode.dark : ThemeMode.light
                      );
                    });
                  }
                ),
              )
            ],
          ),
      ),
      );
  }
}
