import 'dart:async';

// import 'package:audioplayers/audioplayers.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';

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
        home: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            backgroundColor: CupertinoColors.systemGrey,
            middle: Text('1-25'),
          ),
          child: Center(child: NumsClick()),
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class NumsClick extends StatefulWidget {
  const NumsClick({Key? key}) : super(key: key);

  @override
  State<NumsClick> createState() => _NumsClickState();
}

class _NumsClickState extends State<NumsClick> {
  int currentNum = 0;
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  List<int> numbers = List.generate(25, (index) => index + 1);
  final player = AudioPlayer();

  @override
  void initState() {
    player.setAsset("assets/audio/pick.mp3");
    super.initState();
    numbers.shuffle(); // 初始化时打乱数字顺序
  }

  void _stopTimer() {
    _stopwatch.stop();
    _timer?.cancel();
    _timer = null;
  }

  void _resetTimer() {
    // _stopTimer(); // 停止当前计时器

    _stopwatch.reset();

    _stopwatch.start();

    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {}); // 更新 UI
    });
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
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentNum = 0;
                  _resetTimer();
                  numbers.shuffle();
                });
              },
              child: Text('Start'),
            ),
            const SizedBox(height: 20),
            Text(
              _formatTime(_stopwatch.elapsed),
              style: TextStyle(
                fontFamily: 'Courier', // 或其他等宽字体名称
              ),
            ),
            const SizedBox(height: 20),
            // NumsClick()
          ],
        ),
      ),
      Expanded(
        child: AspectRatio(
            aspectRatio: 1 / 1,
            child: GridView.builder(
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
                      player.play();
                      print("点击了数字 ${numbers[index]}");
                      int clickedNum = numbers[index];
                      if (clickedNum - currentNum == 1) {
                        currentNum = clickedNum;
                      }
                      if (clickedNum == clickedNum && clickedNum == 25) {
                        _stopTimer();
                      }
                    },
                    child: Text(
                      "${numbers[index]}",
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                );
              },
            )),
      ),
    ]);
  }
}
