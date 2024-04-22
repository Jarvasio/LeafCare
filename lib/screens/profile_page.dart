import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plant_app/const/constants.dart';
import 'package:plant_app/screens/definiçoes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Constants.primaryColor,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Definições'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                exit(0); // Sai do aplicativo quando o botão é pressionado
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            // Profile Image
            Container(
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Constants.primaryColor.withOpacity(0.5),
                  width: 5,
                ),
              ),
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/perfil2.png'),
                backgroundColor: Colors.transparent,
                radius: 70,
              ),
            ),
            // Profile Name
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user?.displayName ?? 'Nome do Usuário',
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'YekanBakh',
                  ),
                ),
                const SizedBox(width: 5),
                SizedBox(
                  height: 20,
                  child: Image.asset('assets/images/verified.png'),
                ),
              ],
            ),
            // Profile Email
            const SizedBox(height: 7),
            Text(
              user?.email ?? 'email@example.com',
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'iranSans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
