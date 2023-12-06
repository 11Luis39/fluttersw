import 'package:chattrac/CustomUi/OwnMessageCard.dart';
import 'package:chattrac/CustomUi/ReplyCard.dart';
import 'package:chattrac/Model/ChatModel.dart';
import 'package:chattrac/Model/MessageModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

class IndividualPage extends StatefulWidget {
  final ChatModel chatModel;
  const IndividualPage({super.key, required this.chatModel});

  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  TextEditingController _controller = TextEditingController();
  String? myPhone;
  IO.Socket? socket;
  List<MessageModel> messages = [];

  Map<String, String> languageMap = {
    'Español': 'es',
    'Inglés': 'en',
    'Francés': 'fr',
    'Alemán': 'de',
    // ... más idiomas
  };

  String selectedSourceLanguage = 'Español';
  String selectedTargetLanguage = 'Inglés';

  void _showLanguagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seleccione los idiomas para la traducción'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButton<String>(
                value: selectedSourceLanguage,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSourceLanguage = newValue!;
                  });
                },
                items: languageMap.keys
                    .map<DropdownMenuItem<String>>((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: selectedTargetLanguage,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTargetLanguage = newValue!;
                  });
                },
                items: languageMap.keys
                    .map<DropdownMenuItem<String>>((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Seleccionar'),
              onPressed: () {
                // Aquí puedes manejar la lógica para usar los códigos de idioma
                String sourceLanguageCode =
                    languageMap[selectedSourceLanguage]!;
                String targetLanguageCode =
                    languageMap[selectedTargetLanguage]!;
                print(
                    'Idioma origen: $sourceLanguageCode, Idioma destino: $targetLanguageCode');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _retrieveMyPhone();
    connect();
  }

  void _retrieveMyPhone() async {
    final prefs = await SharedPreferences.getInstance();
    myPhone = prefs.getString('phone');
  }

  void connect() {
    socket = IO.io('https://proyectosw.onrender.com/', <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": true,
    });

    socket!.onConnect((_) {
      print('Conectado al servidor de Socket.IO');
      socket!.emit('register', myPhone);
    });

    socket!.on('new_message', (data) {
      print('Nuevo mensaje recibido: $data');
      MessageModel receivedMessage = MessageModel.fromJson(data);

      setState(() {
        messages.add(receivedMessage);
      });
    });

    socket!.onDisconnect((_) {
      print('Desconectado del servidor de Socket.IO');
    });

    socket!.connect();
  }

  void sendMessage(String messageText) {
    if (messageText.isNotEmpty && myPhone != null) {
      String sourceLanguageCode = languageMap[selectedSourceLanguage]!;
      String targetLanguageCode = languageMap[selectedTargetLanguage]!;
      socket!.on('translation_result', (data) {
        print('Mensaje traducido recibido: $data');

        setState(() {
          messages.add(MessageModel(
            message: messageText,
            translatedMessage: data['translation'],
            sourcePhone: data['sourcePhone'],
            targetPhone: data['targetPhone'],
          ));
        });

        socket!.off('translation_result');
      });

      socket!.emit('send_message', {
        'sourcePhone': myPhone,
        'targetPhone': widget.chatModel.phone,
        'message': messageText,
        'sourceLanguage': sourceLanguageCode,
        'targetLanguage': targetLanguageCode,
      });

      _controller.clear();
    } else {
      print('El mensaje está vacío o el número de teléfono no está disponible');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          leadingWidth: 100,
          titleSpacing: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.arrow_back,
                  size: 24,
                  color: Colors.white,
                ),
                CircleAvatar(
                  radius: 23,
                  backgroundColor: Colors.blueGrey[200],
                  child: Icon(
                    Icons.person, // Ícono de persona
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          title: Container(
            margin: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.chatModel.name ?? 'Nombre predeterminado',
                    style: const TextStyle(
                      fontSize: 18.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                const Text(
                  "ultima conexion 18:55",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (String value) {
                if (value == "Idiomas") {
                  _showLanguagePicker(context);
                } else if (value == "Ajustes") {
                  // Añade aquí tu lógica para "Ajustes"
                }
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<String>>[
                  const PopupMenuItem(
                    value: "Ajustes",
                    child: Text("Ajustes"),
                  ),
                  const PopupMenuItem<String>(
                    value: "Idiomas",
                    child: Text("Idiomas"),
                  ),
                ];
              },
              icon: const Icon(Icons.more_vert, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 140,
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var message = messages[index];
                  return message.sourcePhone == myPhone
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            OwnMessageCard(
                              message: message.message, // Mensaje original
                            ),
                            TranslatedMessageCard(
                              translatedMessage: message
                                  .translatedMessage, // Mensaje traducido
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ReplyCard(
                              message: message.message, // Mensaje original
                            ),
                            ReplyTranslatedMessageCard(
                              translatedMessage: message
                                  .translatedMessage, // Mensaje traducido
                            ),
                          ],
                        );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 55,
                    child: Card(
                      margin:
                          const EdgeInsets.only(left: 2, right: 2, bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        controller: _controller,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                          prefixIcon: IconButton(
                            icon: const Icon(
                              Icons.emoji_emotions,
                            ),
                            onPressed: () {},
                          ),
                          suffixIcon:
                              Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.camera_alt)),
                          ]),
                          contentPadding: const EdgeInsets.all(5),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                      right: 2,
                    ),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: const Color(0xFF128C7E),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Llamar a sendMessage cuando se presione el botón
                          sendMessage(_controller.text);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
