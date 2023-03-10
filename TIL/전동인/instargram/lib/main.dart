import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
// 이미지 가져오는 모듈
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(
      MaterialApp(
        theme: style.theme,
        home: const MyApp()
      )
    );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];
  var userImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData() async {
      var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
      if (result.statusCode == 200) {
        print(result.body);
        data = jsonDecode(result.body);
      } else {
        print(result.statusCode);
      }
    }
    getData();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Instargram'),
        actions: [IconButton(
          icon: Icon(Icons.add_box_outlined),
          onPressed: () async {
            var picker = ImagePicker();
            var image = await picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              setState(() {
                userImage = File(image.path);
              });
            }
            Navigator.push(context,
              MaterialPageRoute(builder: (c) => Upload())
            );
          },
          )
        ],
      ),
      body: Theme(
        data: style.bodyTheme,
        child: [Home(data: data), Text('샵페이지')][tab]
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i){ setState(() {
          tab = i;
        });},
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: '샵')
        ],
      )
    );

  }
}


class Home extends StatelessWidget {
  const Home({Key? key, this.data}) : super(key: key);
  final data;
  @override
  Widget build(BuildContext context) {
    if (data.isNotEmpty){
      return ListView.builder(itemCount: 3, itemBuilder: (c, i){
        return Column(
          children: [
            Image.network(data[i]['image']),
            Container(
              constraints: BoxConstraints(maxWidth: 600),
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('좋아요 ${data[i]['likes']}'),
                  Text(data[i]['user']),
                  Text(data[i]['content']),
                ],
              ),
            )
          ],
        );
      });
    } else {
      return Text('로딩중임');
    }
  }
}

class Upload extends StatelessWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.close)
          ),
          Text('HI')
        ],
      ),
    );
  }
}
