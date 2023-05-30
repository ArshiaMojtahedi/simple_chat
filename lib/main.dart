import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Implememt getIt
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Simple Chat',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffFFFFFF),
        disabledColor: Color(0xffC4C4C4),
        canvasColor: Colors.transparent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          displayLarge: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          displayMedium: const TextStyle(
            fontSize: 17,
            color: Colors.black38,
          ),
          displaySmall: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: Colors.black38,
          ),
          labelLarge: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          labelMedium: const TextStyle(
            fontSize: 17,
            color: Colors.black38,
          ),
        ),
      ),
      home: Container(),
    );
  }
}
