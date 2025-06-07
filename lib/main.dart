import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CalculatorApp(),
  ));
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String _expression = '';
  String _result = '';

  final List<String> buttons = [
    'AC', '⌫', '%', '÷',
    '7', '8', '9', '×',
    '4', '5', '6', '–',
    '1', '2', '3', '+',
    '0', '.', '=',
  ];

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        _expression = '';
        _result = '';
      } else if (value == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (value == '=') {
        try {
          String finalExpr = _expression
              .replaceAll('×', '*')
              .replaceAll('÷', '/')
              .replaceAll('–', '-');

          Parser p = Parser();
          Expression exp = p.parse(finalExpr);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);

          _result = eval.toString();
        } catch (e) {
          _result = 'Ошибка';
        }
      } else {
        _expression += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _expression,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _result,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10),
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final button = buttons[index];
                return _buildButton(button);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text) {
    Color backgroundColor;
    Color textColor = Colors.white;

    if (text == 'AC' || text == '⌫') {
      backgroundColor = Colors.grey.shade700;
    } else if (text == '=' || text == '+' || text == '–' || text == '×' || text == '÷') {
      backgroundColor = Colors.orange;
    } else {
      backgroundColor = Colors.grey.shade900;
    }

    return GestureDetector(
      onTap: () => _onButtonPressed(text),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(fontSize: 28, color: textColor),
        ),
      ),
    );
  }
}