import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwitchButtonColorBtn extends StatefulWidget
{
  final String buttonText;
  final List<double> buttonBorderRadius;

  const SwitchButtonColorBtn({
    super.key,
    required this.buttonText,
    required this.buttonBorderRadius});

  @override
  State<SwitchButtonColorBtn> createState() => _SwithcButtonColorBtnState();
}

class _SwithcButtonColorBtnState extends State<SwitchButtonColorBtn>
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
    //S_prefs = await SharedPreferences.getInstance();
  }

  void toggleButtonColor(bool value)
  {
    if(value == true)
    {
      //_prefs.setBool("isDarkMode", true);
    }else
    {
      //_prefs.setBool("isDarkMode", false);
    }
  }

  final MaterialStateProperty<Icon?> thumbIcon =
  MaterialStateProperty.resolveWith<Icon?>((Set<MaterialState> states)
  {
    if (states.contains(MaterialState.selected))
    {
      return const Icon(Icons.check, color: Color(0xFFE59113));
    }
    return const Icon(Icons.close, color: Color(0xFF8597A1));
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
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.15),
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
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Container(
              height: 5,
              child: Switch(
                  thumbIcon: thumbIcon,
                  value: true,
                  activeColor: Theme.of(context).colorScheme.secondary,
                  activeTrackColor: Theme.of(context).colorScheme.primary,
                  inactiveTrackColor: Theme.of(context).colorScheme.tertiary,
                  trackOutlineColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states)
                  {
                    if (states.contains(MaterialState.selected))
                    {
                      return Theme.of(context).colorScheme.primary;
                    }
                    return Theme.of(context).colorScheme.tertiary;
                  }),
                  thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states)
                  {
                    if (states.contains(MaterialState.disabled))
                    {
                      return Theme.of(context).colorScheme.tertiary;
                    }
                    return Theme.of(context).colorScheme.secondary;
                  }),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (bool value)
                  {

                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}
