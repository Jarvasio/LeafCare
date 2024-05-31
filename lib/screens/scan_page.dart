import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  File? _selectedImage;
  bool _isScanning = false;
  Map<String, dynamic>? _plantInfo;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _plantInfo = null;
      });
    }
  }

  Future<void> _scanImage() async {
    if (_selectedImage == null) {
      _showErrorDialog('Por favor, selecione uma imagem antes de digitalizar.');
      return;
    }

    setState(() {
      _isScanning = true;
    });

    try {
      final apiUrl = 'https://my-api.plantnet.org/v2/identify/all?include-related-images=true&no-reject=false&lang=pt&type=legacy&api-key=2b10LhxQx9EVAxoswVeAd4Y13O';

      final request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..files.add(await http.MultipartFile.fromPath('images', _selectedImage!.path, contentType: MediaType('image', 'jpeg')))
        ..fields['organs'] = 'auto';

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = jsonDecode(responseBody);

        // Supondo que o nome científico esteja no campo 'scientificName'
        String scientificName = decodedResponse['results'][0]['species']['scientificName'] ?? 'Nome científico não encontrado';

        // Buscar informações da planta no Firestore
        _fetchPlantInfo(scientificName);
      } else {
        _showErrorDialog('Erro ao digitalizar a imagem: ${response.statusCode}');
      }
    } catch (error) {
      _showErrorDialog('Erro ao digitalizar a imagem: $error');
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  Future<void> _fetchPlantInfo(String scientificName) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('plantas')
          .where('scientificName', isEqualTo: scientificName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _plantInfo = querySnapshot.docs.first.data();
        });
        _showResultDialog(_plantInfo!);
      } else {
        _showErrorDialog('Planta não encontrada na base de dados.');
      }
    } catch (error) {
      _showErrorDialog('Erro ao buscar informações da planta: $error');
    }
  }

  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      title: 'Erro',
      desc: message,
      btnOkText: 'Entendi',
      btnOkColor: Colors.red,
      btnOkOnPress: () {},
    ).show();
  }

  void _showResultDialog(Map<String, dynamic> plantInfo) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: 'Informações da Planta',
      desc: '''
        Nome Científico: ${plantInfo['scientificName']}
        Altura: ${plantInfo['Altura']}
        Categoria: ${plantInfo['categoria']}
        Descrição: ${plantInfo['Descrição']}
        Largura: ${plantInfo['Largura']}
        Luz Solar: ${plantInfo['Luz Solar']}
        Período de Floração: ${plantInfo['Período de Floração']}
        Rega: ${plantInfo['Rega']}
        Solo: ${plantInfo['Solo']}
        Temperatura: ${plantInfo['Temperatura']}
        Umidade: ${plantInfo['Umidade']}
      ''',
      btnOkText: 'Entendi',
      btnOkColor: Colors.green,
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digitalização de Imagens'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_selectedImage != null)
            Expanded(
              child: Image.file(
                _selectedImage!,
                fit: BoxFit.cover,
              ),
            ),
          if (_isScanning)
            const SpinKitWave(
              color: Colors.blue,
              size: 30,
            )
          else
            ElevatedButton(
              onPressed: _scanImage,
              child: const Text('Digitalizar'),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: const Text('Escolher da Galeria'),
              ),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: const Text('Usar a Câmera'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
