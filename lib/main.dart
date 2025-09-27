import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _display = '0';
  String _previousValue = '';
  String _operator = '';
  bool _waitingForNewValue = false;

  void _onNumberPressed(String number) {
    setState(() {
      if (_waitingForNewValue) {
        _display = _previousValue + _operator + number;
        _waitingForNewValue = false;
      } else {
        _display = _display == '0' ? number : _display + number;
      }
    });
  }

  void _onOperatorPressed(String operator) {
    setState(() {
      if (_previousValue.isNotEmpty && !_waitingForNewValue) {
        _calculate();
        _previousValue = _display;
      } else {
        _previousValue = _display;
      }
      _operator = operator;
      _display = _display + operator;
      _waitingForNewValue = true;
    });
  }

  void _calculate() {
    if (_previousValue.isEmpty || _operator.isEmpty) return;

    String currentValue = _display.substring(_previousValue.length + 1);
    if (currentValue.isEmpty) return;

    double prev = double.parse(_previousValue);
    double current = double.parse(currentValue);
    double result = 0;

    switch (_operator) {
      case '+':
        result = prev + current;
        break;
      case '-':
        result = prev - current;
        break;
      case '*':
        result = prev * current;
        break;
      case '/':
        if (current != 0) {
          result = prev / current;
        } else {
          setState(() {
            _display = 'Error';
          });
          Future.delayed(const Duration(seconds: 1), () {
            _clear();
          });
          return;
        }
        break;
    }

    _display = result % 1 == 0 ? result.toInt().toString() : result.toString();
    _previousValue = '';
    _operator = '';
    _waitingForNewValue = true;
  }

  void _clear() {
    setState(() {
      _display = '0';
      _previousValue = '';
      _operator = '';
      _waitingForNewValue = false;
    });
  }

  void _onEqualsPressed() {
    setState(() {
      _calculate();
    });
  }

  void _onDecimalPressed() {
    setState(() {
      if (_waitingForNewValue) {
        _display = '$_previousValue$_operator${0}.';
        _waitingForNewValue = false;
      } else {
        String currentNumber = _getCurrentNumber();
        if (!currentNumber.contains('.')) {
          _display = _display == '0' ? '0.' : '$_display.';
        }
      }
    });
  }

  String _getCurrentNumber() {
    if (_waitingForNewValue || _operator.isEmpty) {
      return _display;
    } else {
      return _display.substring(_previousValue.length + 1);
    }
  }

  Widget _buildButton(String text, {Color? color, Color? textColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: text.isEmpty ? null : () {
            if (text == 'C') {
              _clear();
            } else if (text == '=') {
              _onEqualsPressed();
            } else if (text == '.') {
              _onDecimalPressed();
            } else if (['+', '-', '*', '/'].contains(text)) {
              _onOperatorPressed(text);
            } else {
              _onNumberPressed(text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[300],
            foregroundColor: textColor ?? Colors.black,
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.black,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  _display,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('C', color: Colors.orange, textColor: Colors.white),
                        _buildButton('', color: Colors.grey[300]),
                        _buildButton('', color: Colors.grey[300]),
                        _buildButton('/', color: Colors.orange, textColor: Colors.white),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('7'),
                        _buildButton('8'),
                        _buildButton('9'),
                        _buildButton('*', color: Colors.orange, textColor: Colors.white),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('4'),
                        _buildButton('5'),
                        _buildButton('6'),
                        _buildButton('-', color: Colors.orange, textColor: Colors.white),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('1'),
                        _buildButton('2'),
                        _buildButton('3'),
                        _buildButton('+', color: Colors.orange, textColor: Colors.white),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ElevatedButton(
                              onPressed: () => _onNumberPressed('0'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                '0',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        _buildButton('.'),
                        _buildButton('=', color: Colors.orange, textColor: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
