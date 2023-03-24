import 'package:flutter/material.dart';

class SaveComplete extends StatefulWidget {
  @override
  _SaveCompleteState createState() => _SaveCompleteState();

  static Future<void> show(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierColor: Color.fromARGB(174, 0, 0, 0),
      builder: (BuildContext context) {
        return SaveComplete();
      },
    );
  }
}

class _SaveCompleteState extends State<SaveComplete>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _opacityAnimation = Tween(begin: 1.0, end: 0.0).animate(_controller);

    // 애니메이션이 완료되면 다이얼로그를 닫습니다.
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop(); // 다이얼로그를 닫습니다.
      }
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: _opacityAnimation.value,
          duration: Duration(seconds: 1),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 80,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
