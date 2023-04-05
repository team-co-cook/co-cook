import 'package:co_cook/services/image_service.dart';
import 'package:co_cook/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import 'package:co_cook/services/search_service.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:co_cook/widgets/card/list_card.dart';
import 'package:co_cook/widgets/button/button.dart';
import 'package:co_cook/widgets/text_field/custom_text_field.dart';
import 'package:co_cook/screens/camera_screen/camera_screen.dart';
import 'package:co_cook/screens/search_screen/widgets/image_picker_button.dart';
import 'package:image_picker/image_picker.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? _searchWord;
  final _focusNode = FocusNode(); // 포커싱 여부를 추적하는 클래스 인스턴스
  final TextEditingController _customTextFieldController =
      TextEditingController();

  bool isSearch = false;
  List dataList = [];
  List trendWord = [];

  XFile? imgFile;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getTrendData();
  }

  Future<void> getTrendData() async {
    // API 요청
    SearchService searchService = SearchService();
    Response? response = await searchService.getTrendList();
    if (response?.statusCode == 200) {
      if (response!.data['data'] != null) {
        setState(() {
          trendWord = response!.data['data'];
        });
      }
    }
  }

  Future<void> getSearchData(String keyword) async {
    if (keyword == '') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("검색어가 존재하지 않습니다."),
        duration: Duration(seconds: 1),
      ));
      return;
    }

    // API 요청
    SearchService searchService = SearchService();
    Response? response = await searchService.getSearchList(keyword: keyword);
    if (response?.statusCode == 200) {
      if (response!.data['data'] != null) {
        print(response.data['data']["recipeListResDto"]);
        setState(() {
          dataList = response.data['data']["recipeListResDto"];
          isSearch = true;
        });
      }
    }
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

  void _clickSearch(String word) {
    setState(() {
      _searchWord = word;
    });
    _customTextFieldController.text = _searchWord!;
    getSearchData(word);
  }

  // 커스텀 텍스트 필드에 내려주기 위한 onChange-setState 함수
  void _onWordChanged(String value) {
    setState(() {
      _searchWord = value;
    });
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    imgFile = XFile(pickedFile.path);

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
    if (response?.statusCode == 200) {
      if (response!.data != null) {
        _clickSearch(response.data);
      }
    }
    _isLoading = false;
  }

  Widget _buildAndroidButton() {
    return PopupMenuButton<ImageSource>(
      color: CustomColors.monotoneLight,
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(
          child: Text('카메라'),
          value: ImageSource.camera,
        ),
        const PopupMenuItem(
          child: Text('갤러리'),
          value: ImageSource.gallery,
        ),
      ],
      onSelected: _getImage,
      icon: const Icon(CupertinoIcons.camera, color: CustomColors.monotoneGray),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
          return false;
        }
        return true;
      },
      child: GestureDetector(
        onTap: () => _dismissKeyboard(context),
        child: Scaffold(
          backgroundColor: CustomColors.redLight,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: CustomColors.monotoneLight,
            elevation: 0.5,
            toolbarHeight: 100,
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _customTextFieldController,
                      onChanged: _onWordChanged,
                      isFocus: false,
                      isSearch: true,
                      onSubmitted: (value) {
                        getSearchData(value);
                      },
                    ),
                  ),
                  if (_searchWord != null && _searchWord!.isNotEmpty)
                    IconButton(
                      color: CustomColors.monotoneGray,
                      onPressed: () {
                        setState(() {
                          _searchWord = '';
                          dataList = [];
                          isSearch = false;
                        });
                        // 커스텀 텍스트 필드의 컨트롤러를 사용하여 텍스트 필드 값을 업데이트
                        _customTextFieldController.text = _searchWord!;
                      },
                      icon: Icon(Icons.close),
                      // 기본 효과 제거
                      splashRadius: 0.01,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    ),
                  Platform.isAndroid
                      ? _buildAndroidButton()
                      : IconButton(
                          color: CustomColors.monotoneGray,
                          onPressed: () {
                            pushScreen(context,
                                CameraScreen(setWordAndSearch: _clickSearch));
                          },
                          icon: Icon(CupertinoIcons.camera),
                          // 기본 효과 제거
                          splashRadius: 0.01,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                ],
              ),
            ),
          ),
          body: _isLoading
              ? Container(
                  color: Colors.white.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                        color: CustomColors.redPrimary),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            if (dataList.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 28, 16, 28),
                                child: Center(
                                  child: Text('${dataList.length}건의 요리를 찾았어요',
                                      style: CustomTextStyles()
                                          .caption
                                          .copyWith(
                                              color:
                                                  CustomColors.monotoneBlack)),
                                ),
                              )
                          ],
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ListCard(data: dataList[index]),
                            );
                          },
                          childCount: dataList.isNotEmpty ? dataList.length : 0,
                        ),
                      ),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: isSearch
                            ? dataList.isEmpty
                                ? Center(
                                    child: Text('검색 결과가 존재하지 않습니다.',
                                        style: CustomTextStyles()
                                            .body1
                                            .copyWith(
                                              color: CustomColors.monotoneGray,
                                            )),
                                  )
                                : Container()
                            : Stack(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(height: 80),
                                      Text('인기 검색어',
                                          style: CustomTextStyles()
                                              .body1
                                              .copyWith(
                                                color:
                                                    CustomColors.monotoneGray,
                                              )),
                                      SizedBox(height: 16.0),
                                      Column(
                                        children: trendWord
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;
                                          String word = entry.value;
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4),
                                              SizedBox(
                                                width: 32,
                                                child: Text(
                                                  '${index + 1}위',
                                                  style: CustomTextStyles()
                                                      .body1
                                                      .copyWith(
                                                        color: CustomColors
                                                            .monotoneGray,
                                                      ),
                                                ),
                                              ),
                                              SizedBox(width: 8.0),
                                              CommonButton(
                                                label: word,
                                                color: ButtonType.none,
                                                onPressed: () {
                                                  _clickSearch(word);
                                                },
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
