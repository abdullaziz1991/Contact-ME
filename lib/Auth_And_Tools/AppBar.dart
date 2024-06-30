import '/Auth_And_Tools/Values.dart';
import 'package:flutter/material.dart';

CustomAppBar(String title) => AppBar(
      title: Text(
        title,
        style: TextStyle(
            color: titleRed, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
    );
//backgroundColor: Colors.transparent,
      //      elevation: 0,