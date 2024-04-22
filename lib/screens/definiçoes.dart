import 'package:flutter/material.dart';
import 'package:plant_app/outros/language_selection_page.dart'; // Importe a página de seleção de idioma aqui
import 'package:plant_app/outros/theme_selection_page.dart'; // Importe a página de seleção de tema aqui
import 'package:plant_app/outros/about_page.dart'; // Importe a página "Sobre" aqui

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Definições'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Idioma'),
            onTap: () {
              // Implemente aqui a navegação para a página de seleção de idioma
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LanguageSelectionPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Tema'),
            onTap: () {
              // Implemente aqui a navegação para a página de seleção de tema
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ThemeSelectionPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Sobre'),
            onTap: () {
              // Implemente aqui a navegação para a página "Sobre"
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}