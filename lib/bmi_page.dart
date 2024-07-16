import 'package:flutter/material.dart';

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
        final double bmi = weightKg /
            ((heightCm / 100) * (heightCm / 100)); // Use height in cm directly

        String result;
        if (bmi < 18.5) {
          result = "Underweight";
        } else if (bmi >= 18.5 && bmi <= 24.9) {
          result = "Healthy weight range";
        } else if (bmi >= 25 && bmi <= 29.9) {
          result = "Overweight";
        } else {
          result = "Obesity";
        }
        setState(() {
          _bmiResult = "Your BMI is ${bmi.toStringAsFixed(2)}";
          _bmiCategory = result;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter valid height and weight")),
        );
      }
    }
  }

  void _remove() {
    if (_formKey.currentState!.validate()) {
      final double heightCm = double.tryParse(_heightController.text) ?? 0;
      final double weightKg = double.tryParse(_weightController.text) ?? 0;

      if (heightCm > 0 && weightKg > 0) {
        final double bmi = weightKg /
            ((heightCm / 100) * (heightCm / 100)); // Use height in cm directly

        String result;
        if (bmi < 18.5) {
          result = "Underweight";
        } else if (bmi >= 18.5 && bmi <= 24.9) {
          result = "Healthy weight range";
        } else if (bmi >= 25 && bmi <= 29.9) {
          result = "Overweight";
        } else {
          result = "Obesity";
        }
        setState(() {
          _bmiResult = "Your BMI is ${bmi.toStringAsFixed(2)}";
          _bmiCategory = result;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter valid height and weight")),
        );
      }
    }
  }

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
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "BMI Calculator",
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
                    fontSize: 24,
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
                onPressed: _remove,
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
    );
  }
}
