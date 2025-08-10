import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    bool isEnglish = context.locale.languageCode == 'en';
    return ElevatedButton(
      onPressed: () {
        if (isEnglish) {
          context.setLocale(const Locale('ar'));
        } else {
          context.setLocale(const Locale('en'));
        }
      },
      child: Text(isEnglish ? 'عربي' : 'English'),
    );
  }
}