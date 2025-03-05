import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

void main() {
  runApp(const JoystickExampleApp());
}

const ballSize = 20.0;
const step = 25.0;

class JoystickExampleApp extends StatelessWidget {
  const JoystickExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF2E3B32),
        appBar: AppBar(
          backgroundColor: Color(0xFF06261D),
          title: const Text('GreenKeeper',style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Button(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const JoystickExample()),
              );
            },
            label: 'Joystick Control & Mapping',
          ),
        ],
      ),
    );
  }
}

class JoystickExample extends StatefulWidget {
  const JoystickExample({super.key});

  @override
  State<JoystickExample> createState() => _JoystickExampleState();
}

class _JoystickExampleState extends State<JoystickExample> {
  double _x = 100;
  double _y = 100;

  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E3B32),
      appBar: AppBar(
        backgroundColor: Color(0xFF06261D),
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Control/Mapping',style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Ball(_x, _y),
            Align(
              alignment: const Alignment(0, 0.8),
              child: Joystick(
                includeInitialAnimation: false,
                base: JoystickBase(
                  decoration: JoystickBaseDecoration(
                    color: Color(0xFFA7BEAE),
                  ),
                  arrowsDecoration: JoystickArrowsDecoration(
                    color: Color(0xFFB85042),
                    enableAnimation: false,
                  ),
                ),
                stick: JoystickStick(
                  decoration: JoystickStickDecoration(
                      color: Color(0xFFd0d1bc),
                     // shadowColor: Color.fromARGB(255, 255, 223, 0)
                  ),
                ),
                listener: (details) {
                  setState(() {
                    _x = _x + step * details.x;
                    _y = _y + step * details.y;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const Button({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

class Ball extends StatelessWidget {
  final double x;
  final double y;

  const Ball(this.x, this.y, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: ballSize,
        height: ballSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFA1BE95),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 3),
            )
          ],
        ),
      ),
    );
  }
}