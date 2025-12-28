import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imgPath;
  final String price;
  const CustomListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imgPath,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 131, 128, 128)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CupertinoListTile(
        leading: CircleAvatar(backgroundImage: AssetImage(imgPath)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text("-\$$price", style: TextStyle(fontSize: 14)),
      ),
    );
  }
}
