import 'package:flutter/material.dart';
import 'package:plant_app/defenições drawer/temas/theme_notifier.dart';
import 'package:provider/provider.dart';


class ThemeSelectionPage extends StatelessWidget {
  const ThemeSelectionPage({Key? key}) : super(key: key);

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
            Consumer<ThemeNotifier>(
              builder: (context, themeNotifier, child) {
                return Switch(
                  value: themeNotifier.isDarkMode,
                  onChanged: (value) {
                    themeNotifier.toggleTheme();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
