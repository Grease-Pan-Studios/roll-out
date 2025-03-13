
import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:flutter/material.dart';

class IndicatorTag extends StatefulWidget {

  final ColorPaletteLogic colorPalette;

  const IndicatorTag({
    super.key,
    required this.colorPalette,
  });

  @override
  State<IndicatorTag> createState() => IndicatorTagState();

}

class IndicatorTagState extends State<IndicatorTag>
    with TickerProviderStateMixin{

  late AnimationController controller;

  late AnimationController displayController;
  late Animation<double> spacingAnimation;
  late Animation<double> alignmentAnimation;

  void hide(){
    /*setState(() {

    });*/
    displayController.reverse(from: 1);
  }

  void show(){
    // setState(() {
    //
    // });
    displayController.forward(from: 0.0);
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration:  const Duration(seconds: 1),
      reverseDuration: const Duration(milliseconds: 500),
      vsync: this,
    )
      ..forward()
      ..addListener(() {
        if (controller.isCompleted) {
          controller.repeat(reverse: true);
        }
      });

    displayController = AnimationController(
      duration:  const Duration(seconds: 1),
      vsync: this,
    );

    spacingAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOutCirc,
      ),
    );

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: displayController,
      builder: (context, snapshot) {
        return Align(
          alignment: Alignment(5 - 4* displayController.value, 0.4),
          child: Container(
            height: 70,
            width: 250,
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: widget.colorPalette.secondary.withAlpha(153),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  verticalDirection: VerticalDirection.up,
                  spacing: 5,
                  children: [
                    Text(
                      "Swipe for more\nmodes!",
                      maxLines: 2,
                      softWrap: true,
                      style: TextStyle(
                          fontFamily: "Advent",
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.72,
                          height: 1,
                          color: widget.colorPalette.activeElementText.withAlpha(180)
                      ),
                    ),
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, snapshot) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: spacingAnimation.value,
                          children: [
                            Image(
                              image: AssetImage("assets/icon/arrow.png"),
                              color: widget.colorPalette.activeElementText.withAlpha(220),
                              height: 20,
                            ),
                            Image(
                              image: AssetImage("assets/icon/arrow.png"),
                              color: widget.colorPalette.activeElementText.withAlpha(220),
                              height: 20,
                            ),
                            Image(
                              image: AssetImage("assets/icon/arrow.png"),
                              color: widget.colorPalette.activeElementText.withAlpha(220),
                              height: 20,
                            ),
                          ],
                        );
                      }
                    ),
                  ],
                ),

              ],
            ),
          ),
        );
      }
    );
  }
}
