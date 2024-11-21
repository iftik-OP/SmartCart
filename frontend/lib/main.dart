import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_cart/consts.dart';
import 'package:smart_cart/pages/loginPage.dart';
import 'package:smart_cart/providers/productProvider.dart';
import 'package:smart_cart/providers/userProvider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0))),
            backgroundColor: WidgetStatePropertyAll(primaryYellow),
          )),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(fontSize: 12),
            hintStyle: TextStyle(fontSize: 12),
            fillColor: Color(0XFF000000).withOpacity(0.05),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: primaryYellow,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
            ),
          ),
          fontFamily: GoogleFonts.poppins().fontFamily,
          colorScheme: ColorScheme.fromSeed(seedColor: primaryYellow),
          useMaterial3: true,
        ),
        home: const Center(
          child: LoginPage(),
        ),
      ),
    );
  }
}
