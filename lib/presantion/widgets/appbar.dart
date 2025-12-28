import 'package:flutter/material.dart';

class Appbar extends StatefulWidget {
  const Appbar({super.key});

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(

      backgroundColor: Colors.redAccent,

      title:Text("El-ROI Biblical Dictionary",
         style: TextStyle(

          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontFamily: "normal",
          
         ),
      
      ),

      centerTitle: true,






    );
  }
}