import 'package:co_cook/screens/cook_screen/widgets/cook_screen_sound_meter.dart';
import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

class VoiceSearchScreen extends StatefulWidget {
  const VoiceSearchScreen({super.key});

  @override
  State<VoiceSearchScreen> createState() => _VoiceSearchScreenState();
}

class _VoiceSearchScreenState extends State<VoiceSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: CustomColors.redLight,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70.0),
          color: CustomColors.monotoneLight,
          border: Border.all(
              color: CustomColors.monotoneLightGray,
              width: 8,
              strokeAlign: BorderSide.strokeAlignOutside),
          boxShadow: const [
            BoxShadow(
              color: CustomColors.redPrimary,
              offset: Offset(0, 0),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            )
          ],
        ),
        alignment: Alignment.center,
        child: CookScreenSoundMeter(
          volume: 0,
          isSpeak: false,
          isSay: false,
          dotSize: 12,
          size: 72,
        ),
      ),
    );
  }
}
