import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _currentOperand = '0';
  String _previousOperand = '';
  String? _operation;
  String _currentLanguage = 'bn';

  final Map<String, Map<String, dynamic>> _languages = {
    'bn': {
      'numbers': ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'],
      'operators': {
        'add': '+',
        'subtract': '-',
        'multiply': '×',
        'divide': '÷',
        'percent': '%',
        'equals': '=',
      },
      'buttons': {
        'clear': 'C',
        'allClear': 'AC',
      },
      'developer': 'ডেভেলপড বাই আতাউর রহমান রানা',
    },
    'en': {
      'numbers': ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
      'operators': {
        'add': '+',
        'subtract': '-',
        'multiply': '×',
        'divide': '÷',
        'percent': '%',
        'equals': '=',
      },
      'buttons': {
        'clear': 'C',
        'allClear': 'AC',
      },
      'developer': 'Developed by Ataur Rahman Rana',
    },
    'ar': {
      'numbers': ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'],
      'operators': {
        'add': '+',
        'subtract': '-',
        'multiply': '×',
        'divide': '÷',
        'percent': '%',
        'equals': '=',
      },
      'buttons': {
        'clear': 'C',
        'allClear': 'AC',
      },
      'developer': 'طورت بواسطة عطاء الرحمن رانا',
    },
  };

  void _appendNumber(String number) {
    setState(() {
      if (number == '.' && _currentOperand.contains('.')) return;
      
      if (_currentOperand == '0' && number != '.') {
        _currentOperand = number;
      } else {
        _currentOperand += number;
      }
    });
  }

  void _chooseOperation(String action) {
    if (_currentOperand.isEmpty) return;
    
    if (_previousOperand.isNotEmpty) {
      _compute();
    }
    
    setState(() {
      _operation = action;
      _previousOperand = _currentOperand;
      _currentOperand = '';
    });
  }

  void _compute() {
    double computation;
    final prev = double.tryParse(_previousOperand) ?? 0;
    final current = double.tryParse(_currentOperand) ?? 0;
    
    if (prev.isNaN || current.isNaN) return;
    
    switch (_operation) {
      case 'add':
        computation = prev + current;
        break;
      case 'subtract':
        computation = prev - current;
        break;
      case 'multiply':
        computation = prev * current;
        break;
      case 'divide':
        if (current == 0) {
          _showErrorDialog('শূন্য দিয়ে ভাগ করা যায় না!');
          return;
        }
        computation = prev / current;
        break;
      case 'percent':
        computation = prev % current;
        break;
      default:
        return;
    }
    
    setState(() {
      _currentOperand = (computation % 1 == 0) 
          ? computation.toInt().toString() 
          : computation.toStringAsFixed(2);
      _operation = null;
      _previousOperand = '';
    });
  }

  void _clear() {
    setState(() {
      _currentOperand = _currentOperand.isNotEmpty 
          ? _currentOperand.substring(0, _currentOperand.length - 1)
          : '0';
      if (_currentOperand.isEmpty) {
        _currentOperand = '0';
      }
    });
  }

  void _allClear() {
    setState(() {
      _currentOperand = '0';
      _previousOperand = '';
      _operation = null;
    });
  }

  void _changeLanguage(String lang) {
    setState(() {
      _currentLanguage = lang;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _convertToLocalNumbers(String text) {
    if (_currentLanguage == 'en') return text;
    
    final numbers = _languages[_currentLanguage]!['numbers'] as List<String>;
    return text.replaceAllMapped(
      RegExp(r'[0-9]'),
      (match) => numbers[int.parse(match.group(0)!)],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = _languages[_currentLanguage]!;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildLanguageSelector(),
              Expanded(
                flex: 2,
                child: _buildDisplay(currentLang),
              ),
              Expanded(
                flex: 4,
                child: _buildButtonGrid(currentLang),
              ),
              _buildDeveloperCredit(currentLang),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2c3e50), Color(0xFF34495e)],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _buildLanguageButton('bn', 'বাংলা'),
          _buildLanguageButton('en', 'English'),
          _buildLanguageButton('ar', 'العربية'),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String lang, String text) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: () => _changeLanguage(lang),
          style: ElevatedButton.styleFrom(
            backgroundColor: _currentLanguage == lang 
                ? const Color(0xFF3498db).withOpacity(0.8)
                : Colors.transparent,
            foregroundColor: _currentLanguage == lang ? Colors.white : Colors.white70,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildDisplay(Map<String, dynamic> currentLang) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _previousOperand.isNotEmpty && _operation != null
                  ? '${_convertToLocalNumbers(_previousOperand)} ${currentLang['operators'][_operation]}'
                  : '',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _convertToLocalNumbers(_currentOperand),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.w300,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black12,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonGrid(Map<String, dynamic> currentLang) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  _buildCalculatorButton(
                    currentLang['buttons']['allClear'],
                    () => _allClear(),
                    backgroundColor: const LinearGradient(
                      colors: [Color(0xFFe67e22), Color(0xFFd35400)],
                    ),
                  ),
                  _buildCalculatorButton(
                    currentLang['buttons']['clear'],
                    () => _clear(),
                    backgroundColor: const LinearGradient(
                      colors: [Color(0xFFe67e22), Color(0xFFd35400)],
                    ),
                  ),
                  _buildCalculatorButton(
                    currentLang['operators']['percent'],
                    () => _chooseOperation('percent'),
                    isOperator: true,
                  ),
                  _buildCalculatorButton(
                    currentLang['operators']['divide'],
                    () => _chooseOperation('divide'),
                    isOperator: true,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _buildNumberButton('7'),
                  _buildNumberButton('8'),
                  _buildNumberButton('9'),
                  _buildCalculatorButton(
                    currentLang['operators']['multiply'],
                    () => _chooseOperation('multiply'),
                    isOperator: true,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _buildNumberButton('4'),
                  _buildNumberButton('5'),
                  _buildNumberButton('6'),
                  _buildCalculatorButton(
                    currentLang['operators']['subtract'],
                    () => _chooseOperation('subtract'),
                    isOperator: true,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _buildNumberButton('1'),
                  _buildNumberButton('2'),
                  _buildNumberButton('3'),
                  _buildCalculatorButton(
                    currentLang['operators']['add'],
                    () => _chooseOperation('add'),
                    isOperator: true,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _buildNumberButton('0', isZero: true),
                  _buildNumberButton('.'),
                  _buildCalculatorButton(
                    currentLang['operators']['equals'],
                    () => _compute(),
                    backgroundColor: const LinearGradient(
                      colors: [Color(0xFFe74c3c), Color(0xFFc0392b)],
                    ),
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number, {bool isZero = false}) {
    final currentLang = _languages[_currentLanguage]!;
    final numbers = currentLang['numbers'] as List<String>;
    
    String displayText = number;
    if (number != '.') {
      displayText = numbers[int.parse(number)];
    }

    return Expanded(
      flex: isZero ? 2 : 1,
      child: _buildCalculatorButton(
        displayText,
        () => _appendNumber(number),
      ),
    );
  }

  Widget _buildCalculatorButton(
    String text,
    VoidCallback onPressed, {
    LinearGradient? backgroundColor,
    bool isOperator = false,
    Color textColor = Colors.black87,
  }) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(
              gradient: backgroundColor ?? LinearGradient(
                colors: isOperator
                    ? [const Color(0xFFf8f9fa), const Color(0xFFe9ecef)]
                    : [Colors.white, Colors.white],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: isOperator ? const Color(0xFFe74c3c) : textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeveloperCredit(Map<String, dynamic> currentLang) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF34495e), Color(0xFF2c3e50)],
        ),
      ),
      child: Text(
        currentLang['developer'],
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
