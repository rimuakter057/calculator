import 'package:flutter/material.dart';


class InformationInputField extends StatelessWidget {
  const InformationInputField({
    super.key,
    required this.controller,
    required this.title

  });

  final TextEditingController controller;
  final String title;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration:  InputDecoration(
          hintText: title,
          hintStyle: TextStyle(
              fontSize: 18,
              color: Colors.black

          ),

      ),
    );
  }
}