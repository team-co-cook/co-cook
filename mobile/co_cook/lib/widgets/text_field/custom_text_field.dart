import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 정규식 메서드 가져오기
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

class CustomTextField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool isError;

  CustomTextField({required this.onChanged, this.isError = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        autofocus: true,
        textAlignVertical: TextAlignVertical.center,
        maxLength: 16,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[ㄱ-ㅎ|ㅏ-ㅣ|가-힣a-zA-Z]')),
        ],
        onChanged: onChanged,
        cursorColor: Colors.black,
        style: const CustomTextStyles()
        .subtitle1
        .copyWith(color: CustomColors.monotoneBlack),
        decoration: InputDecoration(
          suffixIcon: isError
              ? const Icon(Icons.error_outline, color: CustomColors.redPrimary)
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: CustomColors.redPrimary, width: 4.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: CustomColors.redPrimary, width: 4.0),
          ),
        ),
      ),
    );
  }
}