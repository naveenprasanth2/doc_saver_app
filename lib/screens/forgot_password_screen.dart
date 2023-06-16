import 'package:doc_saver_app/constants/authentication_error_messages.dart';
import 'package:doc_saver_app/helper/sizedbox_helper.dart';
import 'package:doc_saver_app/provider/auth_provider.dart';
import 'package:doc_saver_app/widgets/custom_button.dart';
import 'package:doc_saver_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentication_screen.dart';

import '../constants/authentication_screen_constants.dart';
import '../widgets/screen_background.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  static String routeName = "/forgotPasswordScreen";

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController forgotController =
      TextEditingController(text: "jipici6362@soremap.com");
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenBackground(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Consumer<AuthProvider>(builder: (context, provider, child) {
          return Form(
            key: _key,
            child: ListView(
              children: [
                SizedBoxHelper.sizedBoxCenter,
                Image.asset(
                  AuthenticationScreenConstants.registerImage,
                  height: 150,
                ),
                const Text(
                  "Enter your email to reset the password",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBoxHelper.sizedBox20,
                CustomTextField(
                    controller: forgotController,
                    hintText: AuthenticationScreenConstants.emailHintText,
                    labelText: AuthenticationScreenConstants.emailTitle,
                    prefixIconData: Icons.email,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return AuthenticationErrorMessages
                            .pleaseEnterAValidEmailId;
                      } else {
                        return null;
                      }
                    },
                    obscureText: false),
                provider.isForgotLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : CustomButton(
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            provider.forgotPassword(
                                context, forgotController.text);
                            Navigator.of(context)
                                .pushNamed(AuthenticationScreen.routeName);
                          }
                        },
                        title: "Forgot Password"),
              ],
            ),
          );
        }),
      ),
    ));
  }
}
