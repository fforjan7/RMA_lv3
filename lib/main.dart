import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _counter = 0;
  Color _textColor = Colors.black;
  int _textColorInt = Colors.black.value;

  @override
  void initState() {
    super.initState();
    getStartupValues();
  }

  Future<void> getStartupValues() async {
    _counter = await _getCounterFromSharedPref();
    _textColorInt = await _getCounterColorFromSharedPref();
    setState(() {
      _textColor = Color(_textColorInt);
    });
  }

  Future<int> _getCounterFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final startupNumber = prefs.getInt('startupNumber');
    if (startupNumber == null) {
      return 0;
    }
    return startupNumber;
  }

  Future<int> _getCounterColorFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final startupColor = prefs.getInt('startupColor');
    if(startupColor == null) {
      return Colors.black.value;
    }
    return startupColor;
  }

  Future<void> _resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('startupNumber', 0);
    await prefs.setInt('startupColor', Colors.black.value);
  }

  Future<void> counterIncrement(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter++;
      _textColor = color;
      _textColorInt = _textColor.value;
    });
    await prefs.setInt('startupNumber', _counter);
    await prefs.setInt('startupColor', _textColorInt);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lv3',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bird Counter'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_counter',
              style: TextStyle(
                color: _textColor,
                fontSize: 100,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    counterIncrement(Colors.blue);
                  },
                  child: Text(
                    'BLUE',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    counterIncrement(Colors.green);
                  },
                  child: Text(
                    'GREEN',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 25,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    counterIncrement(Colors.yellow);
                  },
                  child: Text(
                    'YELLOW',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    _counter = 0;
                    _textColor = Colors.black;
                    _resetCounter();
                  });
                },
                child: Text(
                  'RESET',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.red,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
