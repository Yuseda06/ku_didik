import 'package:flutter/material.dart';
import 'package:ku_didik/utils/theme/primary_swatch.dart';
import 'package:ku_didik/utils/theme/widget/widget_themes.dart';

class TAppTheme {
  TAppTheme._();
  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    primarySwatch: Colors.amber,
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme:
        ElevatedButtonThemeData(style: ElevatedButton.styleFrom()),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
    primarySwatch: Colors.amber,
    textTheme: TTextTheme.darkTextTheme,
  );
}
