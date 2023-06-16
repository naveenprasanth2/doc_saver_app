import 'package:doc_saver_app/helper/sizedbox_helper.dart';
import 'package:doc_saver_app/provider/auth_provider.dart';
import 'package:doc_saver_app/provider/user_info_provider.dart';
import 'package:doc_saver_app/widgets/custom_button.dart';
import 'package:doc_saver_app/widgets/custom_text_field.dart';
import 'package:doc_saver_app/widgets/screen_background.dart';
import 'package:doc_saver_app/widgets/setting_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static String routeName = "/settingsScreen";

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child:
              Consumer<UserInfoProvider>(builder: (context, provider, child) {
            return Column(
              children: [
                SettingsCardWidget(
                  title: provider.userName,
                  leadingIcon: Icons.drive_file_rename_outline_outlined,
                  trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Container(
                              height: 200,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  CustomTextField(
                                      controller: userNameController,
                                      hintText: "User name",
                                      labelText:
                                          "please enter a valid user name",
                                      prefixIconData: Icons.person,
                                      validator: (String? value) {
                                        return null;
                                      },
                                      obscureText: false),
                                  CustomButton(
                                      onPressed: () {
                                        provider.updateUserName(
                                            userNameController.text, context);
                                      },
                                      title: "Submit"),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                SettingsCardWidget(
                    title: provider.emailId, leadingIcon: Icons.email),
                InkWell(
                  onTap: () {
                    Provider.of<AuthProvider>(context, listen: false).logout(context);
                  },
                  child: const SettingsCardWidget(
                    title: "Logout",
                    leadingIcon: Icons.logout,
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
