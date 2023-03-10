import 'package:flutter/material.dart';
import 'dart:async'; // async 안에 Timer가 들어있음

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('타이머 테스트'),
      ),
      body: const Column(
        children: [
          Timer1(),
          Timer2()
        ],
      )
    );
  }

}

class Timer1 extends StatefulWidget {
  const Timer1({Key? key}) : super(key: key);

  @override
  State<Timer1> createState() => _Timer1State();
}

class _Timer1State extends State<Timer1> {
  var _icon = Icons.play_arrow;
  var _color = Colors.grey;

  late Timer _timer; // 타이머 정의
  var _time = 0; // 시간 저장(초)
  var _isPlaying = false; // 시작/정지 상태값

  // 앱이 종료될 때, 타이머 취소
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Text('아래는 시간이다.'),
          Text('${_time}'),
          Row(
            children: [
              IconButton(onPressed: (){
                setState(() {
                  _click();
                });
              }, icon: Icon(_icon)),
              TextButton(onPressed: (){
                _reset();
              }, child: Text('초기화'))
            ],
          ),
        ],
      ),
    );
  }

  void _click() {
    if(_icon == Icons.play_arrow) {
      _icon = Icons.pause;
      _color = Colors.grey;
      _start();
    } else {
      _icon = Icons.play_arrow;
      _color = Colors.amber;
      _pause();
    }
  }

  // 타이머 시작
  void _start() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) { setState(() {
      _time++;
    }); });
  }

  // 타이머 중지
  void _pause() {
    _timer?.cancel();
  }

  // 타이머 초기화
  void _reset() {
    setState(() {
      _isPlaying = false;
      _timer?.cancel();
      _time = 0;
      _icon = Icons.play_arrow;
      _color = Colors.amber;
      _pause();
    });
  }
}

class Timer2 extends StatefulWidget {
  const Timer2({Key? key}) : super(key: key);

  @override
  State<Timer2> createState() => _Timer2State();
}

class _Timer2State extends State<Timer2> {
  var _icon = Icons.play_arrow;
  var _color = Colors.grey;

  late Timer _timer; // 타이머 정의
  var _time = 0; // 시간 저장(초)
  var _isPlaying = false; // 시작/정지 상태값

  // 앱이 종료될 때, 타이머 취소
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Text('아래는 시간이다.'),
          Text('${_time}'),
          Row(
            children: [
              IconButton(onPressed: (){
                setState(() {
                  _click();
                });
              }, icon: Icon(_icon)),
              TextButton(onPressed: (){
                _reset();
              }, child: Text('초기화'))
            ],
          ),
        ],
      ),
    );
  }

  void _click() {
    if(_icon == Icons.play_arrow) {
      _icon = Icons.pause;
      _color = Colors.grey;
      _start();
    } else {
      _icon = Icons.play_arrow;
      _color = Colors.amber;
      _pause();
    }
  }

  // 타이머 시작
  void _start() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) { setState(() {
      _time++;
    }); });
  }

  // 타이머 중지
  void _pause() {
    _timer?.cancel();
  }

  // 타이머 초기화
  void _reset() {
    setState(() {
      _isPlaying = false;
      _timer?.cancel();
      _time = 0;
      _icon = Icons.play_arrow;
      _color = Colors.amber;
      _pause();
    });
  }
}

