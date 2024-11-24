import 'dart:async';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: Chessboard(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class Chessboard extends StatefulWidget {
  const Chessboard({Key? key}) : super(key: key);

  @override
  State<Chessboard> createState() => _ChessboardState();
}

class _ChessboardState extends State<Chessboard> {
  bool _isStarted = false;
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  List<int> numbers = List.generate(25, (index) => index + 1);

  @override
  void initState() {
    super.initState();
    numbers.shuffle(); // 初始化时打乱数字顺序
  }

  void _startTimer() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {}); // 更新 UI
    });
  }

  void _stopTimer() {
    _stopwatch.stop();
    _timer?.cancel();
    _timer = null;
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDecimals(int n) => (n % 100).toString().padLeft(2, '0');

    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String milliseconds = twoDecimals(duration.inMilliseconds);

    return "$minutes:$seconds:$milliseconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('棋盘'),
      ),
      body: Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isStarted = !_isStarted;
                  if (_isStarted) {
                    _startTimer();
                  } else {
                    _stopTimer();
                  }
                });
              },
              child: Text(_isStarted ? '暂停' : '开始'),
            ),
            const SizedBox(height: 20),
            Text('时间: ${_formatTime(_stopwatch.elapsed)}'),
            const SizedBox(height: 20),
            NumsClick()
          ],
        ),
      ),
    );
  }
}

class NumsClick extends StatefulWidget {
  const NumsClick({Key? key}) : super(key: key);

  @override
  State<NumsClick> createState() => _NumsClickState();
}

class _NumsClickState extends State<NumsClick> {
  List<int> numbers = List.generate(25, (index) => index + 1);

  @override
  void initState() {
    super.initState();
    numbers.shuffle(); // 初始化时打乱数字顺序
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
      ),
      itemCount: 25,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox.expand(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              // 处理按钮点击事件
              print("点击了数字 ${numbers[index]}");
            },
            child: Text(
              "${numbers[index]}",
              style: const TextStyle(fontSize: 24),
            ),
          ),
        );
      },
    );
  }
}