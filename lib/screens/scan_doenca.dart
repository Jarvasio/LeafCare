import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:convert';
import 'package:image/image.dart' as img;

class DiseaseScanPage extends StatefulWidget {
  const DiseaseScanPage({super.key});

  @override
  State<DiseaseScanPage> createState() => _DiseaseScanPageState();
}

class _DiseaseScanPageState extends State<DiseaseScanPage> {
  File? _selectedImage;
  bool _isScanning = false;
  String? _diseaseResult;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      File? resizedImage = await _resizeImage(File(pickedFile.path));
      setState(() {
        _selectedImage = resizedImage;
        _diseaseResult = null;
      });
    }
  }

  Future<File?> _resizeImage(File originalImage) async {
    final decodedImage = img.decodeImage(await originalImage.readAsBytes());

    final int targetWidth = 500;
    final int targetHeight = 500;

    final double aspectRatio = decodedImage!.width / decodedImage.height;
    int newWidth, newHeight;

    if (aspectRatio > 1) {
      newWidth = targetWidth;
      newHeight = (targetWidth / aspectRatio).round();
    } else {
      newWidth = (targetHeight * aspectRatio).round();
      newHeight = targetHeight;
    }

    final resizedImage = img.copyResize(decodedImage, width: newWidth, height: newHeight);
    return File(originalImage.path).writeAsBytes(img.encodeJpg(resizedImage));
  }

  Future<void> _scanImage() async {
    if (_selectedImage == null) {
      _showErrorDialog('Por favor, selecione uma imagem.');
      return;
    }

    setState(() {
      _isScanning = true;
    });

    try {
      final String apiKey = '3lLhFO6XdcU0kM1doqYv';
      final String apiUrl = 'https://detect.roboflow.com/plant-disease-detection-v2-2nclk/1';

      final request = http.MultipartRequest('POST', Uri.parse('$apiUrl?api_key=$apiKey'));
      request.files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));
      
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final result = jsonDecode(responseBody);
        _diseaseResult = result['predictions']?.first['class'] ?? 'Doença não encontrada';

        _showResultDialog(_diseaseResult!);
      } else {
        _showErrorDialog('Erro ao detectar a doença: ${response.statusCode}');
      }
    } catch (error) {
      _showErrorDialog('Erro ao detectar a doença: $error');
    } finally {
      setState(() {
        _isScanning = false;
      });
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

  void _showResultDialog(String result) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: 'Resultado da Digitalização',
      desc: 'Doença Detectada: $result',
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
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Icon(Icons.info),
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
            "Dr. Plant",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xff112a42),
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            Icons.local_hospital_rounded,
            size: 30,
            color: Colors.green.shade700,
          ),
        ],
      ),
    );
  }
}
