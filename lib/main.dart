import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const SimonGame());
}

class SimonGame extends StatelessWidget {
  const SimonGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simon',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const Simon(title: 'Simon'),
    );
  }
}

class Simon extends StatefulWidget {
  const Simon({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Simon> createState() => _SimonState();
}

class _SimonState extends State<Simon> {
  int _score = 0;
  int _best = 0;
  int _index = 0;

  bool _protect = false;

  final bool _allDisabled = false;
  final List<bool> _disabled = [false, false, false, false];

  final List<int> _nexts = [];

  _restartGame() {
    _nexts.clear();
    _index = 0;
    _nextGame();

    setState(() {
      if (_best < _score) {
        _best = _score;
      }

      _score = 0;
    });
  }

  _nextGame() {
    _index = 0;
    _showNexts();
  }

  Future<void> _showNexts() async {
    _protect = true;

    var rng = Random();
    var nb = rng.nextInt(4);
    _nexts.add(nb);

    for (var i = 0; i < _nexts.length; i++) {
      setState(() {
        _disabled[_nexts[i]] = true;
      });

      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _disabled[_nexts[i]] = false;
      });

      await Future.delayed(const Duration(milliseconds: 500));
    }

    _protect = false;
  }

  void _press(int btn) {
    if (_protect) return;

    if (btn != _nexts[_index]) {
      _restartGame();
    } else {
      setState(() {
        _score++;
      });

      _index++;

      if (_index == _nexts.length) {
        _nextGame();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: _allDisabled || _disabled[0] ? null : () => _press(0),
                child: const Text('^')
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: _allDisabled || _disabled[1] ? null : () => _press(1),
                    child: const Text('>')
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Score:',
                    ),
                    Text(
                      '$_score',
                      style: Theme.of(context).textTheme.headline4,
                    )
                  ],
                ),
                ElevatedButton(
                    onPressed: _allDisabled || _disabled[2] ? null : () => _press(2),
                    child: const Text('<')
                )
              ],
            ),
            ElevatedButton(
                onPressed: _allDisabled || _disabled[3] ? null : () => _press(3),
                child: const Text('v')
            ),
            Text(
              'Best score: $_best',
              style: Theme.of(context).textTheme.headline4,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _restartGame,
        tooltip: 'Restart Game',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
