import 'package:flutter/material.dart';

class MyBanner extends StatelessWidget {
  final Color bgColor;
  final String text;
  const MyBanner({required this.bgColor, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: Container(
        width: 340,
        //  height: 300,

        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
          image: DecorationImage(
              image: AssetImage("assets/images/banner.png"), fit: BoxFit.fill),
        ),
      ),
    );
  }
}
