import 'package:flutter/material.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _expression = '';
  String _result = '';

  void _buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '';
      } else if (value == '=') {
        try {
          _result = _evaluate(_expression);
        } catch (e) {
          _result = 'Error';
        }
      } else {
        _expression += value;
      }
    });
  }

  String _evaluate(String expr) {
    // Very simple evaluator: only + - * /
    List<String> tokens = [];
    String number = '';

    for (int i = 0; i < expr.length; i++) {
      String ch = expr[i];
      if ('0123456789.'.contains(ch)) {
        number += ch;
      } else if ('+-*/'.contains(ch)) {
        if (number.isNotEmpty) {
          tokens.add(number);
          number = '';
        }
        tokens.add(ch);
      }
    }
    if (number.isNotEmpty) tokens.add(number);

    // Now perform calculation (left to right)
    double result = double.parse(tokens[0]);

    for (int i = 1; i < tokens.length; i += 2) {
      String op = tokens[i];
      double nextNum = double.parse(tokens[i + 1]);

      if (op == '+') result += nextNum;
      else if (op == '-') result -= nextNum;
      else if (op == '*') result *= nextNum;
      else if (op == '/') result /= nextNum;
    }

    return result.toString();
  }

  Widget _buildButton(String text) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(25),
        ),
        onPressed: () => _buttonPressed(text),
        child: Text(text, style: TextStyle(fontSize: 22)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculator')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_expression, style: TextStyle(fontSize: 28)),
                  SizedBox(height: 10),
                  Text(_result, style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Row(children: [_buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('/')]),
          Row(children: [_buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('*')]),
          Row(children: [_buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('-')]),
          Row(children: [_buildButton('0'), _buildButton('.'), _buildButton('='), _buildButton('+')]),
          Row(children: [_buildButton('C')]),
        ],
      ),
    );
  }
}
