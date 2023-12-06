import 'package:chattrac/Model/ChatModel.dart';
import 'package:chattrac/Screens/IndividualPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCard extends StatefulWidget {
  final ChatModel chatModel;
  const CustomCard({super.key, required this.chatModel});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) =>  IndividualPage(chatModel:widget.chatModel)));
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: SvgPicture.asset("assets/${widget.chatModel.icon}",
                  color: Colors.white),
            ),
            title: Text(widget.chatModel.name ?? 'Nombre predeterminado',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
            subtitle: Row(
              children: [
                const Icon(Icons.done_all),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  widget.chatModel.currentMessage ?? 'Nombre predeterminado',
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            trailing: Text(widget.chatModel.time ?? 'Nombre predeterminado'),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1, // Corrige la ortografía de 'thickess' a 'thickness'
            ),
          )
        ],
      ),
    );
  }
}
