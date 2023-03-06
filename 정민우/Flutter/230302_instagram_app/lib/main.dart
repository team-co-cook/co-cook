import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: "Pacifico",
          ),
          actionsIconTheme: IconThemeData(
              color: Colors.black
          )
        )
      ),
      home: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Instagram"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add_box_outlined))],
      ),
      body: Container(
        child: Text("hello", style: TextStyle(color: Colors.red, fontFamily: "Pacifico"),),
      )
    );
  }
}
