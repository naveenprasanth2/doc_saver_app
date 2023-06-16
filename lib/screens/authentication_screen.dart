import 'package:doc_saver_app/constants/authentication_screen_constants.dart';
import 'package:doc_saver_app/helper/sizedbox_helper.dart';
import 'package:doc_saver_app/provider/auth_provider.dart';
import 'package:doc_saver_app/screens/forgot_password_screen.dart';
import 'package:doc_saver_app/widgets/custom_button.dart';
import 'package:doc_saver_app/widgets/screen_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/authentication_error_messages.dart';
import '../widgets/custom_text_field.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  static String routeName = "/authenticationScreen";

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  TextEditingController userNameController =
      TextEditingController();
  TextEditingController emailController =
      TextEditingController(text: "niwapi4518@bodeem.com");
  TextEditingController passwordController =
      TextEditingController(text: "test1234");
  TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _key,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Image.asset(
                    AuthenticationScreenConstants.registerImage,
                    height: 150,
                  ),
                  SizedBoxHelper.sizedBox20,
                  if (provider.isLogin)
                    CustomTextField(
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return AuthenticationErrorMessages
                              .pleaseEnterAValidUsername;
                        } else {
                          return null;
                        }
                      },
                      controller: userNameController,
                      hintText: AuthenticationScreenConstants.userNameHintText,
                      labelText: AuthenticationScreenConstants.userNameTitle,
                      prefixIconData: Icons.person,
                      obscureText: false,
                    ),
                  CustomTextField(
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return AuthenticationErrorMessages
                            .pleaseEnterAValidEmailId;
                      } else {
                        return null;
                      }
                    },
                    controller: emailController,
                    hintText: AuthenticationScreenConstants.emailHintText,
                    labelText: AuthenticationScreenConstants.emailTitle,
                    prefixIconData: Icons.email,
                    obscureText: false,
                  ),
                  CustomTextField(
                    validator: (String? value) {
                      if (value!.isEmpty || value.length < 8) {
                        return AuthenticationErrorMessages
                            .pleaseEnterAValidPassword;
                      } else {
                        return null;
                      }
                    },
                    controller: passwordController,
                    hintText: AuthenticationScreenConstants.passwordHintText,
                    labelText: AuthenticationScreenConstants.passwordTitle,
                    prefixIconData: Icons.password,
                    suffixIcon: IconButton(
                      onPressed: () {
                        provider.setObscureText();
                      },
                      icon: Icon(provider.obscureText
                          ? Icons.visibility_off
                          : Icons.remove_red_eye),
                    ),
                    obscureText: provider.obscureText,
                  ),
                  if (provider.isLogin)
                    CustomTextField(
                      validator: (String? value) {
                        if (value!.isEmpty || value.length < 8) {
                          return AuthenticationErrorMessages
                              .pleaseEnterAValidPassword;
                        } else if (passwordController.text !=
                            confirmPasswordController.text) {
                          return AuthenticationErrorMessages.passwordNotMatch;
                        } else {
                          return null;
                        }
                      },
                      controller: confirmPasswordController,
                      hintText:
                          AuthenticationScreenConstants.confirmPasswordHintText,
                      labelText:
                          AuthenticationScreenConstants.confirmPasswordTitle,
                      prefixIconData: Icons.password,
                      suffixIcon: IconButton(
                        onPressed: () {
                          provider.setObscureText();
                        },
                        icon: Icon(provider.obscureText
                            ? Icons.visibility_off
                            : Icons.remove_red_eye),
                      ),
                      obscureText: provider.obscureText,
                    ),
                  provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                              //code for authentication can be written
                              if (provider.isLogin) {
                                provider.signUp(
                                    context: context,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    userName: userNameController.text);
                              } else {
                                provider.signIn(
                                    context: context,
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            }
                          },
                          title: provider.isLogin
                              ? AuthenticationScreenConstants.registerButtonText
                              : AuthenticationScreenConstants.loginButtonText,
                        ),
                  SizedBoxHelper.sizedBox20,
                  MaterialButton(
                    onPressed: () {
                      provider.setIsLogin();
                    },
                    child: Text(provider.isLogin
                        ? AuthenticationScreenConstants.loginText
                        : AuthenticationScreenConstants.registerAccountText),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, ForgotPasswordScreen.routeName);
                    },
                    child:
                        Text(AuthenticationScreenConstants.forgotPasswordText),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
