import 'package:co_cook/screens/image_result_screen/image_result_screen.dart';
import 'package:co_cook/services/image_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:co_cook/utils/route.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'dart:io';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:co_cook/screens/camera_screen/camera_screen.dart';
import 'package:co_cook/screens/voice_search_screen/voice_search_screen.dart';

class AiRecommend extends StatefulWidget {
  const AiRecommend({super.key});

  @override
  State<AiRecommend> createState() => _AiRecommendState();
}

class _AiRecommendState extends State<AiRecommend> {
  // 사진 검색용 변수
  XFile? imgFile;
  bool _isImageSearchLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.width / 2 + 80,
      child: Stack(children: [
        Positioned(
          right: 0,
          child: SizedBox(
              height: 120,
              child:
                  Image.asset("assets/images/background/ai_background_TR.png")),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: SizedBox(
              height: 120,
              child:
                  Image.asset("assets/images/background/ai_background_BL.png")),
        ),
        Positioned(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                        height: 24,
                        child: Image.asset("assets/images/logo/logo_ai.png")),
                    Container(
                      margin: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                      child: Text("AI로 추천받는 레시피",
                          style: const CustomTextStyles().subtitle2.copyWith(
                                color: CustomColors.monotoneBlack,
                              )),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [AiRecommendVoiceCard(), AiRecommendPhotoCard()],
              )
            ],
          ),
        ),
      ]),
    );
  }

  Widget AiRecommendVoiceCard() {
    return ZoomTapAnimation(
      end: 0.98,
      onTap: () => pushScreen(
          context,
          VoiceSearchScreen(
            isPushed: true,
          )),
      child: Stack(children: [
        Container(
          width: (MediaQuery.of(context).size.width / 2 - 24), // 부모 요소의 너비를 가져옴
          height: (MediaQuery.of(context).size.width / 2 -
              24), // 부모 요소의 너비와 같은 값으로 설정
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 239, 151, 84),
                Color.fromARGB(255, 246, 90, 142)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                  "assets/images/background/search_voice_foreground.png"),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(1, 1),
                blurRadius: 6.0,
                spreadRadius: 0.0,
              )
            ],
          ),
        ),
        Positioned(
            top: 20,
            left: 20,
            child: Center(
                child: Text("냉장고 속 재료를\n말해보세요",
                    style: const CustomTextStyles().subtitle1.copyWith(
                        color: CustomColors.monotoneLight,
                        height: 1.2,
                        shadows: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(1, 1),
                            blurRadius: 6.0,
                            spreadRadius: 0.0,
                          )
                        ])))),
      ]),
    );
  }

  Widget AiRecommendPhotoCard() {
    return ZoomTapAnimation(
      end: 0.98,
      onTap: () {
        if (Platform.isAndroid) {
          _getImage(ImageSource.camera);
        } else {
          pushScreen(context, CameraScreen(isNext: true));
        }
      },
      child: Stack(children: [
        Container(
          width: (MediaQuery.of(context).size.width / 2 - 24), // 부모 요소의 너비를 가져옴
          height: (MediaQuery.of(context).size.width / 2 -
              24), // 부모 요소의 너비와 같은 값으로 설정
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                  "assets/images/background/search_photo_background.png"),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(1, 1),
                blurRadius: 6.0,
                spreadRadius: 0.0,
              )
            ],
          ),
        ),
        Positioned(
            top: 24,
            left: 0,
            right: 0,
            child: Center(
                child: Text("내 앞에 있는 음식의",
                    style: CustomTextStyles().subtitle1.copyWith(
                        color: CustomColors.monotoneLight,
                        shadows: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(1, 1),
                            blurRadius: 6.0,
                            spreadRadius: 0.0,
                          )
                        ])))),
        Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
                child: Text("레시피가 궁금하다면?",
                    style: CustomTextStyles().subtitle1.copyWith(
                        color: CustomColors.monotoneLight,
                        shadows: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(1, 1),
                            blurRadius: 6.0,
                            spreadRadius: 0.0,
                          )
                        ])))),
      ]),
    );
  }

  /////////////////////////////// 사진 검색용 코드입니다.

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) {
      return;
    }
    imgFile = XFile(pickedFile.path);

    // 로딩 스피너 표시
    _showLoadingSpinner(context);

    getImgData();
  }

  Future getImgData() async {
    String fileName = imgFile!.path.split('/').last;
    MultipartFile multipartFile =
        await MultipartFile.fromFile(imgFile!.path, filename: fileName);
    print(fileName);

    FormData formData = FormData.fromMap({
      "image": multipartFile,
    });

    // API 요청
    ImageService searchService = ImageService();
    Response? response = await searchService.postImage(formData);
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!$response');
    if (response?.statusCode == 200) {
      if (response!.data != null) {
        // 로딩 스피너 닫기
        Navigator.of(context).pop();
        // 이미지 결과 페이지로 이동
        Route imageResult = MaterialPageRoute(
            builder: (context) => ImageResultScreen(searchWord: response.data));
        Navigator.push(context, imageResult);
      }
    }
  }

  void _showLoadingSpinner(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(color: CustomColors.redPrimary),
        );
      },
    );
  }
}
