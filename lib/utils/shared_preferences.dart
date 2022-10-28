import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class sharedPrefHelper {
  static Future<MaterialColor> getFavColor() async {
    final prefs = await SharedPreferences.getInstance();
    Color prefColor = Color(prefs.getInt('color') ?? Colors.blue.value);

    Map<int, Color> mapColor = {
      50: Color.fromRGBO(prefColor.red, prefColor.green, prefColor.blue, .1),
      100: Color.fromRGBO(prefColor.red, prefColor.green, prefColor.blue, .2),
      200: Color.fromRGBO(prefColor.red, prefColor.green, prefColor.blue, .3),
      300: Color.fromRGBO(prefColor.red, prefColor.green, prefColor.blue, .4),
      400: Color.fromRGBO(prefColor.red, prefColor.green, prefColor.blue, .5),
      500: Color.fromRGBO(prefColor.red, prefColor.green, prefColor.blue, .6),
      600: Color.fromRGBO(prefColor.red, prefColor.green, prefColor.blue, .7),
      700: Color.fromRGBO(prefColor.red, prefColor.green, prefColor.blue, .8),
      800: Color.fromRGBO(prefColor.red, prefColor.green, prefColor.blue, .9),
      900: Color.fromRGBO(prefColor.red, prefColor.green, prefColor.blue, 1),
    };
    Color test =
        Color.fromRGBO(prefColor.red, prefColor.green, prefColor.blue, 1);
    return MaterialColor(test.value, mapColor);
  }

  static Future<MaterialColor> setFavColor(Color selColor) async {
    final prefs = await SharedPreferences.getInstance();

    Map<int, Color> mapColor = {
      50: Color.fromRGBO(selColor.red, selColor.green, selColor.blue, .1),
      100: Color.fromRGBO(selColor.red, selColor.green, selColor.blue, .2),
      200: Color.fromRGBO(selColor.red, selColor.green, selColor.blue, .3),
      300: Color.fromRGBO(selColor.red, selColor.green, selColor.blue, .4),
      400: Color.fromRGBO(selColor.red, selColor.green, selColor.blue, .5),
      500: Color.fromRGBO(selColor.red, selColor.green, selColor.blue, .6),
      600: Color.fromRGBO(selColor.red, selColor.green, selColor.blue, .7),
      700: Color.fromRGBO(selColor.red, selColor.green, selColor.blue, .8),
      800: Color.fromRGBO(selColor.red, selColor.green, selColor.blue, .9),
      900: Color.fromRGBO(selColor.red, selColor.green, selColor.blue, 1),
    };
    prefs.setInt('color', selColor.value);
    return MaterialColor(selColor.value, mapColor);
  }

  static Future<String> getFavLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? locale = prefs.getString("locale");
    if (locale == 'fr' || locale == 'en') {
      return (locale!);
    } else {
      return "";
    }
  }

  static Future<String> setFavLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale == 'fr' || locale == 'en') {
      prefs.setString('locale', locale);
      return locale;
    } else if (locale == "None") {
      prefs.remove('locale');
    }

    return "";
  }

  static Future<String> getFavProfilePicture() async {
    final prefs = await SharedPreferences.getInstance();
    String profilePicture = prefs.getString("profilePicture") ?? "";
    return profilePicture;
  }

  static Future<void> setFavProfilePicture(String profilePicture) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profilePicture',profilePicture);
  }
}
