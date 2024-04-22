import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('English'),
            onTap: () {
              _setLanguage(context, 'en');
            },
          ),
          ListTile(
            title: const Text('Português'),
            onTap: () {
              _setLanguage(context, 'pt');
            },
          ),
          ListTile(
            title: const Text('Español'),
            onTap: () {
              _setLanguage(context, 'es');
            },
          ),
          // Add more languages as needed
        ],
      ),
    );
  }

  void _setLanguage(BuildContext context, String languageCode) {
    // Set the selected language for the application
    Locale selectedLocale = Locale(languageCode);
    // Set the application's localization with the selected language
    SystemChannels.textInput.invokeMethod('TextInput.setLocale', languageCode);
    // Update the application's language
    MyApp.setLocale(context, selectedLocale);
    // Close the language selection page after selection
    Navigator.pop(context);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      locale: _locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('pt', ''),
        Locale('es', ''),
      ],
      home: const LanguageSelectionPage(),
    );
  }
}

void main() {
  runApp(const MyApp());
}
