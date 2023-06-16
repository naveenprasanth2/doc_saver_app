import 'package:flutter/material.dart';

import '../helper/sizedbox_helper.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final IconData prefixIconData;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?) validator;

  const CustomTextField({super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.prefixIconData,
    this.suffixIcon,
    required this.validator, required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextFormField(
            validator: validator,
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              labelText: labelText,
              prefixIcon: Icon(prefixIconData),
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ),
        SizedBoxHelper.sizedBox20,
      ],
    );
  }
}
