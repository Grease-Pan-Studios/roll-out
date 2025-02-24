
import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {

  final bool isDark;
  final bool isExpanded;
  final String text;
  final Image? icon;
  final VoidCallback onPressed;
  final ColorPaletteLogic colorPalette;


  const Button ({
    super.key,
    required this.text,
    required this.onPressed,
    required this.colorPalette,
    this.icon,
    this.isDark = false,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          isDark ? colorPalette.activeElementBorder : colorPalette.activeElementBackground
        ),
        overlayColor: WidgetStateProperty.all<Color>(colorPalette.primary.withAlpha(40)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        side: WidgetStateProperty.all<BorderSide>(
          BorderSide(
            color: colorPalette.activeElementBorder,
            width: 3.0,
            strokeAlign: BorderSide.strokeAlignCenter
          ),
        ),
        splashFactory: InkRipple.splashFactory,
        fixedSize: isExpanded ? null : WidgetStateProperty.all<Size>(Size(220, 36)),
        padding: isExpanded ? null : WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(0)),
        // alignment: Alignment.topCenter,
      ),
      child: FittedBox(

        child: Row(
          mainAxisSize: isExpanded? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Text(
                text,
                style: TextStyle(
                  fontFamily: 'Advent',
                  color: isDark ? colorPalette.activeElementBackground:
                    colorPalette.activeElementText,
                  fontSize: 24,
                  fontWeight: isDark? FontWeight.w800 : FontWeight.w700,
                  letterSpacing: -0.72,
                )
            ),
            if (icon != null) icon!,
          ],
        ),
      ),
    );
  }
}
