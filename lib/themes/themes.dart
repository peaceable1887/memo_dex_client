import 'package:flutter/material.dart';
class Themes
{
  static final lightTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Color(0xFFDDDDDD),
      //scaffoldBackgroundColor: Color(0xFF00324E),
      fontFamily: "Inter",
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
            color: Color(0xFF15171B),
            fontSize: 36,
            fontWeight: FontWeight.w600
        ),
        headlineMedium: TextStyle(
            color: Color(0xFF15171B),
            fontSize: 20,
            fontWeight: FontWeight.w600
        ),
        headlineSmall: TextStyle(
          color: Color(0xFF15171B),
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: Color(0xFF15171B),
          fontSize: 24,
          fontFamily: "Inter",
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(
            color: Color(0xFF15171B),
            fontSize: 16,
            fontWeight: FontWeight.w600
        ),
        bodySmall: TextStyle(
          color: Color(0xFF15171B),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelMedium: TextStyle(
          color: Color(0xFF8597A1),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: TextStyle(
          color: Color(0xFF8597A1),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        titleSmall: TextStyle(
          color: Color(0xFF8597A1),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF8597A1),
            width: 2.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF15171B), // Ändern Sie hier die Farbe des Rahmens im Fokus
            width: 2.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        iconColor: Color(0xFF15171B),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states)
        {
          if (states.contains(MaterialState.disabled))
          {
            return Colors.white;
          }
          return Colors.white;
        }),
        trackOutlineColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states)
        {
          if (states.contains(MaterialState.selected))
          {
            return Color(0xFF00324E);
          }
          return Color(0xFF63ABFD);

        }),
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFE59113),
        secondary: Colors.white,
        tertiary: Color(0xFF33363F),
        surface: Color(0xFF15171B),
        surfaceVariant: Colors.white,
        onSurface: Colors.black,
        shadow: Color(0xFF15171B),
        errorContainer: Colors.red,
      )
  );

 static final darkTheme = ThemeData(
       brightness: Brightness.dark,
       scaffoldBackgroundColor: Color(0xFF15171B),
       //scaffoldBackgroundColor: Color(0xFF00324E),
       fontFamily: "Inter",
       textTheme: const TextTheme(
         headlineLarge: TextStyle(
             color: Colors.white,
             fontSize: 36,
             fontWeight: FontWeight.w600
         ),
         headlineMedium: TextStyle(
             color: Colors.white,
             fontSize: 20,
             fontWeight: FontWeight.w600
         ),
         headlineSmall: TextStyle(
           color: Colors.white,
           fontSize: 17,
           fontWeight: FontWeight.w600,
         ),
         bodyLarge: TextStyle(
           color: Colors.white,
           fontSize: 24,
           fontFamily: "Inter",
           fontWeight: FontWeight.w600,
         ),
         bodyMedium: TextStyle(
           color: Colors.white,
           fontSize: 16,
           fontWeight: FontWeight.w600
         ),
         bodySmall: TextStyle(
           color: Colors.white,
           fontSize: 12,
           fontWeight: FontWeight.w400,
         ),
         labelMedium: TextStyle(
           color: Color(0xFF8597A1),
           fontSize: 16,
           fontWeight: FontWeight.w600,
         ),
         labelSmall: TextStyle(
           color: Color(0xFF8597A1),
           fontSize: 16,
           fontWeight: FontWeight.w400,
         ),
         titleSmall: TextStyle(
           color: Color(0xFF8597A1),
           fontSize: 12,
           fontWeight: FontWeight.w500,
         ),
       ),
       inputDecorationTheme: InputDecorationTheme(
         enabledBorder: OutlineInputBorder(
           borderSide: BorderSide(
             color: Color(0xFF8597A1),
             width: 2.0,
           ),
           borderRadius: BorderRadius.all(Radius.circular(10.0)),
         ),
         focusedBorder: OutlineInputBorder(
           borderSide: BorderSide(
             color: Colors.white, // Ändern Sie hier die Farbe des Rahmens im Fokus
             width: 2.0,
           ),
           borderRadius: BorderRadius.all(Radius.circular(10.0)),
         ),
         iconColor: Colors.white,
       ),
       switchTheme: SwitchThemeData(
         thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states)
         {
           if (states.contains(MaterialState.disabled))
           {
             return Color(0xFF33363F);
           }
           return Color(0xFF33363F);
         }),
         trackOutlineColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states)
         {
           if (states.contains(MaterialState.selected))
           {
             return Color(0xFF00324E);
           }
           return Color(0xFF63ABFD);

         }),
       ),
       colorScheme: const ColorScheme.dark(
         primary: Color(0xFFE59113),
         secondary: Color(0xFF33363F),
         tertiary: Color(0xFF8597A1),
         surface: Colors.white,
         surfaceVariant: Color(0xFF282F45),
         onSurface: Colors.black,
         shadow: Color(0xFF15171B),
         errorContainer: Colors.red,
       )
   );
}
