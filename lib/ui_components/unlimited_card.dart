
import 'package:amaze_game/logical/color_palette_logic.dart';
import 'package:flutter/material.dart';

class UnlimitedCard extends StatelessWidget {

  final ColorPaletteLogic colorPalette;

  const UnlimitedCard({
    super.key,
    required this.colorPalette,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 25.0),
      child: TapRegion(
        onTapInside: (PointerDownEvent event) {},
        child: Material(
          color: colorPalette.activeElementBackground,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: colorPalette.activeElementText,
              strokeAlign: BorderSide.strokeAlignInside,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: TextStyle(
            fontFamily: "Advent",
            color: colorPalette.activeElementText,
            fontSize: 20,
            letterSpacing: -1.2,
            height: 1,
          ),
          child: SizedBox(
            height: 100,
            width: double.infinity,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Unlimited",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "High Score ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -1,
                                ),
                              ),
                              TextSpan(
                                text: "20",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -1,
                                ),
                              ),
                            ]
                          )
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    "assets/images/infinity.png",
                    alignment: Alignment.topRight,
                    height: 150,
                    width: 240,
                  )
                ),
                Align(
                  alignment: Alignment(1, 1.2),
                  child: IconButton(
                    onPressed: () {},
                    icon: ImageIcon(
                      AssetImage("assets/images/ui_elements/trophy.png"),
                      size: 24,
                      color: colorPalette.activeElementText,
                    )
                  ),
                )
              ],
        
            ),
          ),
        ),
      ),
    );
  }
}
