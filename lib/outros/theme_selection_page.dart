import 'package:flutter/material.dart';
import 'package:plant_app/screens/splash_screen.dart';


class ThemeSelectionPage extends StatefulWidget {
  const ThemeSelectionPage({Key? key}) : super(key: key);

  @override
  _ThemeSelectionPageState createState() => _ThemeSelectionPageState();
}

class _ThemeSelectionPageState extends State<ThemeSelectionPage> {
  bool _isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Selection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mude de Modo',
              style: TextStyle(fontSize: 18.0),
            ),
            Switch(
              value: _isDarkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _isDarkModeEnabled = value;
                  _toggleTheme();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleTheme() {
    if (_isDarkModeEnabled) {
      // Ativar o tema escuro
      _applyDarkTheme();
    } else {
      // Ativar o tema claro
      _applyLightTheme();
    }
  }

  void _applyDarkTheme() {
    // Definir as propriedades do tema escuro
    ThemeData darkTheme = ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
      ),
    );

    // Aplicar o tema escuro
    _applyTheme(darkTheme);
  }

  void _applyLightTheme() {
    // Definir as propriedades do tema claro
    ThemeData lightTheme = ThemeData.light().copyWith(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        background: Colors.white,
      ),
    );

    // Aplicar o tema claro
    _applyTheme(lightTheme);
  }

  void _applyTheme(ThemeData theme) {
    // Aplicar o novo tema
    MaterialApp app = MaterialApp(
      theme: theme,
      home: const SplashScreen(), // Página inicial temporária
    );

    // Reiniciar a aplicação com o novo tema
    runApp(app);
  }
}
