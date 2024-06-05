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
import 'package:plant_app/screens/scan_doenca.dart';

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

        String scientificName = decodedResponse['results'][0]['species']['scientificName'] ?? 'Nome científico não encontrado';

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
        _showErrorDialog('Planta não encontrada na base de dados.', scientificName);
      }
    } catch (error) {
      _showErrorDialog('Erro ao buscar informações da planta: $error');
    }
  }

  void _showErrorDialog(String message, [String? scientificName]) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      title: 'Erro',
      desc: message,
      btnOkText: 'Entendi',
      btnOkColor: Colors.red,
      btnOkOnPress: () {},
      btnCancelText: scientificName != null ? 'Adicionar Planta' : null,
      btnCancelOnPress: scientificName != null
          ? () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddPlantPage(scientificName: scientificName),
              ));
            }
          : null,
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
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                buildHeading(),
                if (_selectedImage != null)
                  SizedBox(
                    height: 300,
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 20),
                if (_isScanning)
                  const SpinKitWave(
                    color: Colors.blue,
                    size: 30,
                  )
                else
                  Center(
                    child: Container(),
                  ),
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Icon(Icons.photo),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                        onPressed: () => _pickImage(ImageSource.camera),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Icon(Icons.camera),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                        onPressed: _scanImage,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Icon(Icons.search),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DiseaseScanPage()),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Icon(Icons.local_hospital_rounded),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildHeading() {
    return Padding(
      padding: const EdgeInsets.only(top: 60, bottom: 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Plant Scanner",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xff112a42),
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            Icons.qr_code_scanner_sharp,
            size: 30,
            color: Colors.green.shade700,
          ),
        ],
      ),
    );
  }
}

class AddPlantPage extends StatefulWidget {
  final String scientificName;

  const AddPlantPage({super.key, required this.scientificName});

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _plantData = {};

  Future<void> _addPlantToDatabase() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      try {
        await FirebaseFirestore.instance.collection('plantas').add({
          'scientificName': widget.scientificName,
          ..._plantData,
        });

        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          title: 'Sucesso',
          desc: 'Planta adicionada com sucesso!',
          btnOkText: 'Entendi',
          btnOkColor: Colors.green,
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
        ).show();
      } catch (error) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: 'Erro',
          desc: 'Erro ao adicionar planta: $error',
          btnOkText: 'Entendi',
          btnOkColor: Colors.red,
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Planta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome Científico'),
                initialValue: widget.scientificName,
                readOnly: true,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Altura'),
                onSaved: (value) {
                  _plantData['Altura'] = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a altura.';
                  }
                  return null;
                },
              ),
              // Add more form fields here for other plant data
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addPlantToDatabase,
                child: const Text('Adicionar Planta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
