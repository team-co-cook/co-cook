import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 정규식 메서드 가져오기
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

class CustomTextField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool isError;
  final bool isFocus;
  final int maxLength; // 글자수 제한, 0일 때 무제한
  final bool isSearch; // 현재 텍스트가 검색용인지 기본은 false
  final void Function(String)? onSubmitted; // 검색 함수 호출

  CustomTextField(
      {required this.onChanged,
      this.isError = false,
      this.isFocus = true,
      this.maxLength = 0,
      this.isSearch = false,
      this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        autofocus: isFocus,
        textAlignVertical: TextAlignVertical.center,
        maxLength: maxLength == 0 ? null : maxLength,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[ㄱ-ㅎ|ㅏ-ㅣ|가-힣a-zA-Z]')),
        ],
        onChanged: onChanged,
        cursorColor: Colors.black,
        onSubmitted: onSubmitted,
        textInputAction: isSearch ? TextInputAction.search : null,
        style: const CustomTextStyles()
            .subtitle1
            .copyWith(color: CustomColors.monotoneBlack),
        decoration: InputDecoration(
          suffixIcon: isError
              ? const Icon(Icons.error_outline, color: CustomColors.redPrimary)
              : null,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide:
                const BorderSide(color: CustomColors.redPrimary, width: 4.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide:
                const BorderSide(color: CustomColors.redPrimary, width: 4.0),
          ),
        ),
      ),
    );
  }
}
