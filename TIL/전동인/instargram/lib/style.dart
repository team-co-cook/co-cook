import 'package:flutter/material.dart';

// 다른 파일에서 쓸 수 없는 변수
var _var1; // 변수명 앞에 _ 언더바를 넣으면 임포트해도 쓸 수 없다.

var theme = ThemeData(
    iconTheme: IconThemeData( color: Colors.black ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.white54
      )
    ),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
      actionsIconTheme: IconThemeData(color: Colors.black, size: 30),
      shape: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 1,
          )
      ),
      elevation: 0,

    ),
    textTheme: TextTheme(
        bodyText2: TextStyle(color: Colors.black, fontSize: 16)
    )
);

var bodyTheme =ThemeData(
  textTheme: TextTheme(),
);