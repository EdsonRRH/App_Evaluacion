import 'package:app_evaluacion/screens/principal_screen.dart';
import 'package:app_evaluacion/screens/passive_mode.dart';
import 'package:wear/wear.dart';
import 'package:flutter/material.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Wear App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.compact,
      ),
      home: const WatchScreen(),
    );
  }
}

//Widget que hace que la pantalla se ponga en modo oscuro
class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
       return AmbientMode(
        builder: (context, mode, child) {
          if (mode == WearMode.active) {
            return const PrincipalScreen();
          } else {
            return const DateDark();
          }
        },
        ); 
      },
    );
  }
}
