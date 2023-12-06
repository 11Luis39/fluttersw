import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chattrac/Model/ChatModel.dart';
import 'package:chattrac/Screens/IndividualPage.dart';

class ContactCard extends StatefulWidget {
  final ChatModel contact;
  const ContactCard({super.key, required this.contact});

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => IndividualPage(chatModel: widget.contact),
          ),
        );
      },
      leading: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.blueGrey[200],
        child: SvgPicture.asset(
          "assets/person.svg",
          color: Colors.white,
          height: 30,
          width: 30,
        ),
      ),
      title: Text(
        widget.contact.name ?? 'Nombre predeterminado',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        widget.contact.phone,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}

