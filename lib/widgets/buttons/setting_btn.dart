import 'package:flutter/material.dart';

class SettingBtn extends StatefulWidget {

  final String buttonText;
  final List<double> buttonBorderRadius;
  final Widget pushToContent;
  final bool? showSwitch;

  const SettingBtn({
    super.key,
    required this.buttonBorderRadius,
    required this.pushToContent,
    required this.buttonText,
    this.showSwitch});

  @override
  State<SettingBtn> createState() => _SettingBtnState();
}

class _SettingBtnState extends State<SettingBtn>
{
  bool _autocorrectDisabled = true;

  @override
  void initState()
  {
    super.initState();
  }

  bool showSwitch(value)
  {
    try
    {
      return value;
    }catch(error)
    {
      value = false;
      return value;
    }
  }

  void pushToContent()
  {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => widget.pushToContent,
      ),
    );
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
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: showSwitch(widget.showSwitch) ? (){} : pushToContent,
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(widget.buttonBorderRadius[0]),
                topLeft: Radius.circular(widget.buttonBorderRadius[1]),
                bottomRight: Radius.circular(widget.buttonBorderRadius[2]),
                bottomLeft: Radius.circular(widget.buttonBorderRadius[3])
            ),
          ),
          padding: EdgeInsets.fromLTRB(15, 10, 10, 10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.buttonText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          showSwitch(widget.showSwitch) ? Container(
            height: 5,
            child: Switch(
                thumbIcon: thumbIcon,
                value: _autocorrectDisabled,
                activeColor: Theme.of(context).colorScheme.secondary,
                activeTrackColor: Theme.of(context).colorScheme.primary,
                inactiveTrackColor: Theme.of(context).colorScheme.tertiary,
                trackOutlineColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states)
                {
                  if (states.contains(MaterialState.selected)) {
                    return Theme.of(context).colorScheme.primary;
                  }
                  return Theme.of(context).colorScheme.tertiary;
                }),
                thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states)
                {
                  if (states.contains(MaterialState.disabled)) {
                    return Theme.of(context).colorScheme.tertiary;
                  }
                  return Theme.of(context).colorScheme.secondary;
                }),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (bool value)
                {
                  setState(() {
                    _autocorrectDisabled = value;
                  });
                }
            ),
          ) : Row(
            children: [
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 22.0,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
