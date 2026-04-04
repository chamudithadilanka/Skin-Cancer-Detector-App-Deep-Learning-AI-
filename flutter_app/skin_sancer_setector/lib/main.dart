
import 'package:flutter/material.dart';
import 'package:skin_sancer_setector/screen/main_screen_with_navigation.dart';
import 'package:skin_sancer_setector/screen/splash_screen.dart';

void main(){
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
    );
  }
}
