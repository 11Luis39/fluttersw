import 'package:flutter/material.dart';
import 'package:chattrac/pages/ChatPage.dart';
import 'package:chattrac/Screens/LoginPage.dart'; // Asegúrate de importar tu LoginScreen
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {

  // Función de cierre de sesión
  Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('phone'); // Elimina el número de teléfono guardado
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    ); // Navega de vuelta a la pantalla de inicio de sesión
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ChatTrac",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {}),
          PopupMenuButton<String>(onSelected: (String value) {
            if (value == 'Cerrar Sesión') {
              cerrarSesion();
            }
          }, itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem(
                value: "Ajustes",
                child: Text("Ajustes"),
              ),
              const PopupMenuItem(
                value: "Cerrar Sesión",
                child: Text("Cerrar Sesión"),
              ),
            ];
          },
          icon: const Icon(Icons.more_vert, color: Colors.white),),
        ],
      ),
      body: const ChatPage(),
    );
  }
}

