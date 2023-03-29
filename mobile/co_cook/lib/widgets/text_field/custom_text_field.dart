import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 정규식 메서드 가져오기
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

class CustomTextField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final bool isFormat;
  final bool isError;
  final bool isFocus;
  final int maxLength; // 글자수 제한, 0일 때 무제한
  final bool isSearch; // 현재 텍스트가 검색용인지 기본은 false
  final void Function(String)? onSubmitted; // 검색 함수 호출
  final TextEditingController? controller;

  CustomTextField(
      {required this.onChanged,
      this.isFormat = true,
      this.isError = false,
      this.isFocus = true,
      this.maxLength = 0,
      this.isSearch = false,
      this.onSubmitted,
      this.controller});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller!.addListener(() {
        widget.onChanged(widget.controller!.text);
      });
    }
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        autofocus: widget.isFocus,
        controller: widget.controller,
        textAlignVertical: TextAlignVertical.center,
        maxLength: widget.maxLength == 0 ? null : widget.maxLength,
        inputFormatters: widget.isFormat
            ? [
                FilteringTextInputFormatter.allow(
                    RegExp('[ㄱ-ㅎ|ㅏ-ㅣ|가-힣a-zA-Z]')),
              ]
            : null,
        onChanged: widget.onChanged,
        cursorColor: Colors.black,
        onSubmitted: widget.onSubmitted,
        textInputAction: widget.isSearch ? TextInputAction.search : null,
        style: const CustomTextStyles()
            .subtitle1
            .copyWith(color: CustomColors.monotoneBlack),
        decoration: InputDecoration(
          suffixIcon: widget.isError
              ? const Icon(Icons.error_outline, color: CustomColors.redPrimary)
              : null,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
                color: CustomColors.monotoneLightGray, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
                color: CustomColors.monotoneLightGray, width: 1.0),
          ),
          hintText: widget.isSearch ? '검색어를 입력해주세요' : null,
        ),
      ),
    );
  }
}
