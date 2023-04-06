import 'dart:io';
import 'dart:convert'; // decode 가져오기
import 'package:co_cook/screens/photo_card_screen/photo_card_screen.dart';
import 'package:co_cook/services/detail_service.dart';
import 'package:dio/dio.dart'; // Response 가져오기 위함.
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:co_cook/widgets/button/button.dart';
import 'package:co_cook/widgets/text_field/custom_text_field.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen(
      {Key? key,
      required this.recipeIdx,
      required this.recipeName,
      required this.startTime})
      : super(key: key);
  final int recipeIdx;
  final String recipeName;
  final DateTime startTime;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  String _text = '';
  bool _isError = false;
  String _errorMessage = '';
  final _focusNode = FocusNode(); // 포커싱 여부를 추적하는 클래스 인스턴스
  XFile? _image; // 이미지를 저장
  int _runningTime = 0;
  late DateTime _endTime;
  bool isSend = false;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    Duration runningTime = widget.startTime.difference(now);
    int minutes = runningTime.inMinutes.remainder(60);
    setState(() {
      _runningTime = minutes;
      _endTime = now;
    });
  }

  // 위젯이 소멸될 때 호출되는 메서드
  @override
  void dispose() {
    _focusNode.dispose(); // 현재 위젯에서 포커스 해제
    super.dispose();
  }

  // 키보드 외 화면을 눌렀을 때, 포커스 해제
  void _dismissKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context); // 현재 포커싱된 위젯을 반환
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      // 현재 포커싱된 위젯이 최상위 FocusScope가 아니면서, 포커싱이 존재한다면.
      currentFocus.focusedChild?.unfocus(); // 현재 포커싱된 자식 위젯의 포커싱을 해제
    }
  }

  // 커스텀 텍스트 필드에 내려주기 위한 onChange-setState 함수
  void onTextChanged(String value) {
    setState(() {
      _text = value;
      _isError = false;
      _errorMessage = '';
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = image;
      });
    } else {
      print('이미지 선택이 취소되었습니다.');
    }
  }

  void _deleteImage() {
    setState(() {
      _image = null;
      isSend = false;
    });
  }

  Future<void> CreateReview() async {
    // 이미지를 MultipartFile로 변환
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("이미지를 등록해주세요."),
        duration: Duration(seconds: 1),
      ));
      return;
    }

    if (_text == '') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("한줄평을 입력해주세요."),
        duration: Duration(seconds: 1),
      ));
      return;
    }

    String fileName = _image!.path.split('/').last;
    MultipartFile multipartFile =
        await MultipartFile.fromFile(_image!.path, filename: fileName);

    // API 요청
    DetailService apiService = DetailService();
    Map reviewDetail = {
      "content": _text,
      "runningTime": _runningTime,
      "recipeIdx": widget.recipeIdx
    };

    String jsonString = jsonEncode(reviewDetail);

    // reviewData와 multipartFile을 함께 전송하기 위해 FormData를 사용합니다.
    FormData formData = FormData.fromMap({
      "reviewDetail": jsonString,
      // 여기서 'reviewImg'는 서버에서 요구하는 파일의 키값입니다. 서버 요구에 따라 적절하게 변경해 주세요.
      "reviewImg": multipartFile,
    });
    setState(() {
      isSend = true;
    });
    Response? response = await apiService.createReview(formData);
    if (response?.statusCode == 200) {
      isSend = false;
      gotoPhotoCard(context, _text, _image!, widget.recipeName,
          widget.startTime, _endTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        onTap: () {
          _dismissKeyboard(context);
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: CustomColors.greenPrimary,
            elevation: 0.5,
            toolbarHeight: 80,
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                '완성!',
                style: const CustomTextStyles()
                    .title1
                    .copyWith(color: CustomColors.monotoneLight),
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '내가 만든 음식을\n사진으로 남겨보세요',
                      style: CustomTextStyles().subtitle1.copyWith(
                          color: CustomColors.monotoneBlack, height: 1.5),
                    ),
                    SizedBox(height: 16),
                    LayoutBuilder(builder: (context, constraints) {
                      return GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            Container(
                              width: constraints.maxWidth,
                              height: constraints.maxWidth * 0.7,
                              decoration: BoxDecoration(
                                color: CustomColors.monotoneLight,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: CustomColors.monotoneLightGray,
                                  width: 1,
                                ),
                              ),
                              child: _image == null
                                  ? const Icon(Icons.add_a_photo,
                                      size: 20,
                                      color: CustomColors.monotoneGray)
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.file(
                                        File(_image!.path),
                                        fit: BoxFit.cover,
                                        width: constraints.maxWidth,
                                        height: constraints.maxWidth * 0.7,
                                      ),
                                    ),
                            ),
                            if (_image != null)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.cancel,
                                      color: CustomColors.monotoneLight),
                                  onPressed: _deleteImage,
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 40),
                    Text(
                      '이 레시피는 어떠셨나요?\n한줄평을 남겨주세요',
                      style: CustomTextStyles().subtitle1.copyWith(
                          color: CustomColors.monotoneBlack, height: 1.5),
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                        onChanged: onTextChanged,
                        isFocus: false,
                        isFormat: false),
                    SizedBox(height: 8),
                    Text(
                      '예시\n  ·  난이도가 적절한 좋은 레시피에요!\n  ·  생각보다 너무 쉬웠어요.\n  ·  시간이 예상보다 오래 걸렸어요.',
                      style: CustomTextStyles().caption.copyWith(
                          color: CustomColors.monotoneGray, height: 1.5),
                    ),
                    SizedBox(height: 24),
                    Center(
                        child: isSend
                            ? Container(
                                width: 20.0,
                                height: 20.0,
                                child: CircularProgressIndicator(
                                  color: CustomColors.redPrimary,
                                ),
                              )
                            : CommonButton(
                                label: '저장',
                                color: ButtonType.red,
                                onPressed: () {
                                  CreateReview();
                                })),
                    SizedBox(height: 8),
                    Center(
                      child: CommonButton(
                          label: '취소',
                          color: ButtonType.none,
                          onPressed: () {
                            showCloseConfirmDialog(context);
                          }),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

void gotoPhotoCard(BuildContext context, String _text, XFile _image,
    String recipeName, DateTime startTime, DateTime endTime) {
  Route photoCardScreen = MaterialPageRoute(
      builder: (context) => PhotoCardScreen(
            text: _text,
            image: _image,
            startTime: startTime,
            endTime: endTime,
            recipeName: recipeName,
          ));
  Navigator.pushReplacement(context, photoCardScreen);
}

Future<void> showCloseConfirmDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text('한줄평을 저장하지 않으면 이 음식의 한줄평을 다시 남김 수 없습니다.',
            style: CustomTextStyles()
                .body1
                .copyWith(color: CustomColors.monotoneBlack)),
        actions: [
          TextButton(
            child: Text('취소',
                style: CustomTextStyles()
                    .body1
                    .copyWith(color: CustomColors.monotoneBlack)),
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          TextButton(
            child: Text('확인',
                style: CustomTextStyles()
                    .body1
                    .copyWith(color: CustomColors.redPrimary)),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      );
    },
  );
}
