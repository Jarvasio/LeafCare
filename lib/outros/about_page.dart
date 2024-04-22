import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/images/planta.jpg', // Caminho para a imagem
                    height: 200, // Altura da imagem
                    width: 200, // Largura da imagem
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Versão: $_version',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                const Text(
                  'LeafCare, é uma aplicação de reconhecimento de plantas que torna fácil identificar plantas. Com uma interface simples, basta tirar uma fotografia ou ir à Galeria do seu dispositivo para obter informações detalhadas sobre a planta, incluindo nome científico e dicas de cuidado. Essencial para entusiastas da natureza e jardineiros. LeafCare é a ferramenta ideal para descobrir a beleza das plantas ao seu redor.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
