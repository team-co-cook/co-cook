import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:record/record.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: 'Flutter Demo',
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  /////////////////////////////////////////////////////////
  // audio meter
  Record myRecording = Record();
  Timer? timer;

  bool _isRecording = false;

  double volume = 0.0;
  double minVolume = -45.0;

  startTimer() async {
    timer ??= Timer.periodic(
        Duration(milliseconds: 10),
            (timer) => updateVolume()
    );
  }

  updateVolume() async {
    Amplitude ampl = await myRecording.getAmplitude();
    if (ampl.current > minVolume) {
      if (ampl.current > -15) {
        _switchMic();
      }
      setState(() {
        volume = (ampl.current - minVolume) / minVolume;
      });
      print("Volume : $volume, ampl.current : ${ampl.current}");
    }
  }

  int volume0to(int maxVolumeToDisplay) {
    return (volume * maxVolumeToDisplay).round().abs();
  }

  Future<bool> startRecording() async {
    if (await myRecording.hasPermission()) {
      if (!await myRecording.isRecording()) {
        await myRecording.start();
      }
      startTimer();
      return true;
    } else {
      return false;
    }
  }

  _stopRecording() async {
    myRecording.stop();
    setState(() {
      volume = 0.0;
    });
  }

  _switchMic() async {
    if (_isRecording) {
      myRecording.stop();
      _startListening();
    }
  }

  /////////////////////////////////////////////////////////

  // late stt.SpeechToText _speech;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;

  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (val) {
        print('onStatus: $val');
        if (val == 'notListening') {
          setState(() {
            _isListening = false;
          });
          startRecording();
        }
      },
      onError: (val) => print('onStatus: $val'),
    );
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
    );
    setState(() {
      _isListening = true;
    });
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _text = result.recognizedWords;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 0),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _isListening ? _stopListening : _startListening,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isRecording = !_isRecording;
                });
                if (_isRecording) {
                  await startRecording();
                } else {
                  await _stopRecording();
                }
              },
              child: Text(_isRecording ? volume0to(100).toString() : "Start Recording"),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 150),
              child: Text('$_text')
            ),
          ),
        ]
      ),
    );
  }
}



// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:provider/provider.dart';
// import 'dart:convert';
//
// import 'package:shared_preferences/shared_preferences.dart';
// import 'notification.dart';
//
// void main() {
//   runApp(ChangeNotifierProvider(create: (context) => Store1(), child: const MyApp()));
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     initNotification();
//   }
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoApp(
//       title: 'Flutter Demo',
//       home: const MyHomePage(title: 'HomePage'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//     saveData(_counter);
//   }
//
//   void _resetCounter() async {
//     var storage = await SharedPreferences.getInstance();
//     storage.remove('number');
//     setState(() {
//       _counter = 0;
//     });
//   }
//
//   getData() async {
//     var storage = await SharedPreferences.getInstance();
//     var storageNum = storage.getInt('number');
//     if (storageNum != null) {
//       setState(() {
//         _counter = storageNum;
//       });
//     }
//
//     saveData(_counter);
//   }
//
//   saveData(int num) async {
//     var storage = await SharedPreferences.getInstance();
//     storage.setInt('number', num);
//     print(storage.get('number'));
//   }
//
//   showNotification() async {
//
//     var androidDetails = AndroidNotificationDetails(
//       '유니크한 알림 채널 ID',
//       '알림종류 설명',
//       icon: 'app_icon',
//       priority: Priority.high,
//       importance: Importance.max,
//       color: Color.fromARGB(255, 255, 0, 0),
//     );
//
//     var iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     // 알림 id, 제목, 내용 맘대로 채우기
//     notifications.show(
//         1,
//         '제목1',
//         '내용1',
//         NotificationDetails(android: androidDetails, iOS: iosDetails)
//     );
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getData();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CupertinoNavigationBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         middle: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             GestureDetector(
//               child: Text(
//                 '$_counter',
//                 style: Theme.of(context).textTheme.headlineMedium,
//               ),
//               onTap: () {
//                 Navigator.push(context,
//                   CupertinoPageRoute(builder: (context) => NumberDetail(previousTitle: 'HomePage'))
//                 );
//               },
//             ),
//             CupertinoButton(onPressed: _incrementCounter, child: Text('Increment')),
//             TextButton(onPressed: _resetCounter, child: Text('Reset')),
//             CupertinoButton(child: Text("알림뿅"), onPressed: showNotification, color: Colors.blue,)
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
//
// class Store1 extends ChangeNotifier {
//   int num2 = 0;
//   void _incrementNum2() {
//     num2++;
//     notifyListeners();
//   }
// }
//
// class NumberDetail extends StatelessWidget {
//   const NumberDetail({Key? key, required this.previousTitle}) : super(key: key);
//   final String previousTitle;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CupertinoNavigationBar(
//         previousPageTitle: 'HomePageHomePageHomePageHomePageHomePage',
//         middle: Text('${context.watch<Store1>().num2}')),
//       body: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CupertinoButton(
//             onPressed: context.read<Store1>()._incrementNum2,
//             child: Text('asdf'),
//             color: Colors.blue,
//             borderRadius: const BorderRadius.all(Radius.circular(16))
//           ),
//
//         ],
//       ),
//     );
//   }
// }
