import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ice_flutter/home_item.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('动态史蒂夫', style: TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return const DynamicItem("中国种力e那种力种力种力ß量", "imageUrl", 5);
          }),
    );
  }
}

