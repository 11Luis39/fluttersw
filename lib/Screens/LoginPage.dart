import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'Homescreen.dart';
import 'RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _loginUser() async {
    final response = await http.post(
      Uri.parse('https://proyectosw.onrender.com/login'), // Asegúrate de que la URL es correcta
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone': _phoneController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Guardar el número de teléfono en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('phone', _phoneController.text);

      // Navegar a la pantalla de inicio después de un inicio de sesión exitoso
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homescreen()), // Asegúrate de que Homescreen es la pantalla a la que deseas navegar
      );
    } else {
      // Mostrar un mensaje de error si el inicio de sesión falla
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inicio de sesión fallido. Por favor, intenta de nuevo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inicio de Sesión')),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centrar el contenido
          children: <Widget>[
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Número de Teléfono'),
              keyboardType: TextInputType.phone, // Asegura que el teclado es tipo teléfono
              validator: (value) { // Validador básico para el número de teléfono
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu número de teléfono';
                }
                // Aquí puedes añadir más lógica de validación si es necesario
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _loginUser();
                }
              },
              child: Text('Iniciar Sesión'),
            ),
                      TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
            },
            child: const Text('¿No tienes cuenta? Regístrate aquí'),
          ),
          ],
        ),
      ),
    );
  }
}

