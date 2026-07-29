import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeManager {
  /// 生成主题数据，可以传入 [primaryColor] 自定义主色调，[fontFamily] 自定义字体
  static ThemeData themeData({
    Color primaryColor = const Color(0xff4ac3ff),
    String? fontFamily,
  }) {
    return ThemeData(
      fontFamily: fontFamily,
      colorScheme: colorScheme(primaryColor: primaryColor),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.black,
          )),
      scaffoldBackgroundColor: Colors.transparent,
      cardColor: Colors.black,
      cardTheme: CardThemeData(
        color: Colors.black.withValues(alpha: 0.5),
        elevation: 0,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
      ),
      navigationRailTheme: NavigationRailThemeData(
          backgroundColor: Colors.transparent,
          selectedIconTheme: const IconThemeData(color: Colors.white),
          unselectedIconTheme: IconThemeData(color: Colors.grey[300]),
          indicatorColor: Colors.grey.withValues(alpha: 0.5)),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 8),
        textStyle: TextStyle(
          color: Colors.black,
          fontFamily: fontFamily,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.white.withValues(alpha: 0.8),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.black.withValues(alpha: 0.2),
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        splashColor: Colors.transparent,
        hoverColor: Colors.white.withValues(alpha: 0.2),
        focusColor: Colors.white.withValues(alpha: 0.2),
        foregroundColor: Colors.black.withValues(alpha: 0.8),
      ),
      menuButtonTheme: MenuButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          splashFactory: NoSplash.splashFactory,
        ),
      ),
      menuBarTheme: MenuBarThemeData(
          style: MenuStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        fixedSize: WidgetStateProperty.all(const Size.fromHeight(48)),
        elevation: WidgetStateProperty.all(0),
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
              colorScheme(primaryColor: primaryColor).surfaceContainer),
        ),
      ),
      expansionTileTheme: const ExpansionTileThemeData(shape: Border()),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.grey[300],
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          splashFactory: NoSplash.splashFactory,
        ),
      ),
      dividerTheme: DividerThemeData(
          color: Colors.white.withValues(alpha: 0.3),
          thickness: 1,
          indent: 5,
          endIndent: 5),
    );
  }

  /// 颜色方案，可以传入 [primaryColor] 自定义主色调
  static ColorScheme colorScheme(
      {Color primaryColor = const Color(0xff4ac3ff)}) {
    return ColorScheme.fromSeed(
        seedColor: primaryColor, brightness: Brightness.dark);
  }
}
