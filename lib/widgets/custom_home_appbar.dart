import 'package:doc_saver_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:doc_saver_app/helper/sizedbox_helper.dart';
import 'package:doc_saver_app/widgets/custom_text_field.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const CustomHomeAppBar(
      {super.key, required this.controller, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150),
      child: Container(
        color: const Color(0xFF1e5376),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/icon_text.png",
                    width: 150,
                  ),
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Navigator.pushNamed(context, SettingsScreen.routeName);
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ))
                ],
              ),
              SizedBoxHelper.sizedBox10,
              CustomTextField(
                  controller: controller,
                  hintText: "Enter the title of the document",
                  labelText: "",
                  prefixIconData: Icons.search,
                  suffixIcon:
                      IconButton(onPressed: onSearch, icon: const Text("GO")),
                  validator: (value) {
                    return null;
                  },
                  obscureText: false)
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(150);
}
