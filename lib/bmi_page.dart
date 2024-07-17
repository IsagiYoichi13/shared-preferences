import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDmiCalculator extends StatefulWidget {
  const MyDmiCalculator({super.key});

  @override
  State<MyDmiCalculator> createState() => _MyDmiCalculatorState();
}

class _MyDmiCalculatorState extends State<MyDmiCalculator> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String _bmiResult = "";
  String _bmiCategory = "";
  String _bmiInfo = "";

  @override
  void initState() {
    super.initState();
    _saveText();
    _loadText();
    _removeText();
  }

  Future<void> _saveText() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('result', _bmiResult);
    await prefs.setString('category', _bmiCategory);
    await prefs.setString('info', _bmiInfo);
  }

  Future<void> _loadText() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bmiResult = prefs.getString('result') ?? '';
      _bmiCategory = prefs.getString('category') ?? '';
      _bmiInfo = prefs.getString('info') ?? '';
    });
  }

  Future<void> _removeText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('result');
    await prefs.remove('category');
    await prefs.remove('info');
    setState(() {
      _bmiResult = '';
      _bmiCategory = '';
      _bmiInfo = '';
    });
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final double heightCm = double.tryParse(_heightController.text) ?? 0;
      final double weightKg = double.tryParse(_weightController.text) ?? 0;

      if (heightCm > 0 && weightKg > 0) {
        final double bmi = ((weightKg / heightCm / heightCm) * 10000);

        String result;
        String information;
        if (bmi < 18.5) {
          result = "Underweight";
          information =
              "You have a lower than normal body weight. You can eat a bit more.";
        } else if (bmi >= 18.5 && bmi < 25.0) {
          result = "Healthy weight range";
          information = "You have a normal body weight, Good job!";
        } else if (bmi >= 25.0 && bmi < 30.0) {
          result = "Overweight";
          information =
              "You have a higher than normal body weight. Try to exercise more.";
        } else {
          result = "Obesity";
          information = "Please exercise more and less eat.";
        }

        setState(() {
          _bmiResult = bmi.toStringAsFixed(2);
          _bmiCategory = result;
          _bmiInfo = information;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter valid height and weight")),
        );
      }
    }
  }

  // void _remove() {
  //   if (_formKey.currentState!.validate()) {
  //     final double heightCm = double.tryParse(_heightController.text) ?? 0;
  //     final double weightKg = double.tryParse(_weightController.text) ?? 0;

  //     if (heightCm > 0 && weightKg > 0) {
  //       final double bmi = weightKg /
  //           ((heightCm / 100) * (heightCm / 100)); // Use height in cm directly

  //       String result;
  //       if (bmi < 18.5) {
  //         result = "Underweight";
  //         result =
  //             "You have a lower than normal body weight. You can eat a bit more.";
  //       } else if (bmi >= 18.5 && bmi <= 24.9) {
  //         result =
  //             "Healthy weight range\nYou have a normal body weight. Good job!";
  //       } else if (bmi >= 25 && bmi <= 29.9) {
  //         result = "Overweight";
  //         result =
  //             "You have a higher than normal body weight. Try to exercise more.";
  //       } else {
  //         result = "Obesity";
  //       }
  //       setState(() {
  //         _bmiResult = "Your BMI is ${bmi.toStringAsFixed(2)}";
  //         _bmiCategory = result;
  //       });
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Please enter valid height and weight")),
  //       );
  //     }
  //   }
  // }

  String? _heightValidator(String? height) {
    if (height == null || height.isEmpty) {
      return 'Please enter your height in centimeters';
    } else if (!RegExp(r'^\d*\.?\d+$').hasMatch(height)) {
      return "Please enter a valid height in centimeters";
    }
    return null;
  }

  String? _weightValidator(String? weight) {
    if (weight == null || weight.isEmpty) {
      return 'Please enter your weight in kilograms';
    } else if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(weight)) {
      return "Please enter a valid weight";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: const Text(
          "BMI Calculator",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Calculate your BMI",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                if (_bmiResult.isNotEmpty) ...[
                  Text(
                    _bmiResult,
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _bmiCategory,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _bmiInfo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Height: Centimeters"),
                    hintText: "Height: Centimeters",
                    hintStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
                    filled: false,
                    fillColor: Colors.white,
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: _heightValidator,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Weight: Kilograms"),
                    hintText: "Weight: Kilograms",
                    hintStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
                    filled: false,
                    fillColor: Colors.white,
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: _weightValidator,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  onPressed: _submit,
                  label: const Text(
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                      'Calculate BMI'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  onPressed: _removeText,
                  label: const Text(
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                      'Remove Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
