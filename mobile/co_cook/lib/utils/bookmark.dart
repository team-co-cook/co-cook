import 'package:flutter/material.dart';

void toggleBookmark(BuildContext context, bool isAdd, Function toggleIsAdd,
    String recipeName) async {
  if (isAdd) {
    //
    // <찜 목록에서 제거 비동기 작업>
    //
    await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("$recipeName 레시피를 찜 목록에서 제거했습니다.."),
      duration: Duration(seconds: 1),
    ));
  } else {
    //
    // <찜 목록에 추가 비동기 작업>
    //
    await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("$recipeName 레시피를 찜 목록에 추가했습니다."),
        duration: Duration(seconds: 1)));
  }

  await toggleIsAdd();
}
