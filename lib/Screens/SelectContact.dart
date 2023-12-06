import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chattrac/CustomUi/ContactCard.dart';
import 'package:chattrac/Model/ChatModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({Key? key}) : super(key: key);

  @override
  _SelectContactState createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  List<ChatModel> contacts = []; 

  void _showAddContactDialog() {
    final _contactNameController = TextEditingController();
    final _contactPhoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Añadir nuevo contacto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _contactNameController,
                decoration: const InputDecoration(labelText: 'Nombre del contacto'),
              ),
              TextField(
                controller: _contactPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Número de teléfono del contacto',
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Añadir'),
              onPressed: () async {
                // Aquí implementarías la lógica para enviar la información al backend
                final name = _contactNameController.text;
                final phone = _contactPhoneController.text;
                if (name.isNotEmpty && phone.isNotEmpty) {
                  await addContact(phone, name);
                  Navigator.of(context).pop();
                } else {
                  // Mostrar algún mensaje de error si es necesario
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> addContact(String contactPhone, String contactName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPhone = prefs.getString('phone');

    if (userPhone != null) {
      final response = await http.post(
        Uri.parse('https://proyectosw.onrender.com/add_contact'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userPhone': userPhone,
          'contactName': contactName,
          'contactPhone': contactPhone,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contacto agregado con éxito.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al agregar el contacto.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Número de teléfono del usuario no disponible.'),
        ),
      );
    }
  }
  Future<void> loadContacts() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userPhone = prefs.getString('phone');

  if (userPhone != null) {
    final response = await http.get(
      Uri.parse('https://proyectosw.onrender.com/get_contacts/$userPhone'), // Utiliza la nueva ruta para obtener los contactos del usuario
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        contacts = jsonData.map((json) => ChatModel.fromJson(json)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar los contactos.')),
      );
    }
  } else {
    // Manejar el caso de que no haya un número de teléfono guardado
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Número de teléfono del usuario no disponible.'),
      ),
    );
  }
}
@override
void initState() {
  super.initState();
  loadContacts();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar contacto'),
      ),
      body: ListView.builder(

        itemCount: contacts.length,
        itemBuilder: (context, index) => ContactCard(contact: contacts[index])
        ,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

