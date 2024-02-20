import 'package:flutter/material.dart';
class Themes
{
   ThemeData lightTheme()
   {
     return ThemeData(
         scaffoldBackgroundColor: Color(0xFF00324E),
         textTheme: const TextTheme(
           headlineLarge: TextStyle(
               color: Colors.white,
               fontSize: 36,
               fontFamily: "Inter",
               fontWeight: FontWeight.w600
           ),
           headlineMedium: TextStyle(
               color: Colors.white,
               fontSize: 20,
               fontFamily: "Inter",
               fontWeight: FontWeight.w600
           ),
           headlineSmall: TextStyle(
             color: Colors.white,
             fontSize: 17,
             fontFamily: "Inter",
             fontWeight: FontWeight.w600,
           ),
         ),
         colorScheme: const ColorScheme.dark(
           primary: Color(0xFF33363F),
           secondary: Color(0xFFE59113),
           tertiary: Color(0xFF8597A1),
           surface: Colors.white,
           onSurface: Colors.white,
           onSurfaceVariant: Colors.black,
           shadow: Color(0xFF00324E),
           errorContainer: Colors.red,
         )
     );
   }
}
