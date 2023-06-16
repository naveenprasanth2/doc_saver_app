import 'package:doc_saver_app/firebase_options.dart';
import 'package:doc_saver_app/provider/auth_provider.dart';
import 'package:doc_saver_app/provider/document_provider.dart';
import 'package:doc_saver_app/provider/user_info_provider.dart';
import 'package:doc_saver_app/screens/add_document_screen.dart';
import 'package:doc_saver_app/screens/authentication_screen.dart';
import 'package:doc_saver_app/screens/document_view_screen.dart';
import 'package:doc_saver_app/screens/forgot_password_screen.dart';
import 'package:doc_saver_app/screens/home_screen.dart';
import 'package:doc_saver_app/screens/settings_screen.dart';
import 'package:doc_saver_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(create: (_) => DocumentProvider()),
        ChangeNotifierProvider(create: (_) => UserInfoProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2))),
        ),
        initialRoute: SplashScreen.routeName,
        routes: {
          AuthenticationScreen.routeName: (context) =>
              const AuthenticationScreen(),
          ForgotPasswordScreen.routeName: (context) =>
              const ForgotPasswordScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          AddDocumentScreen.routeName: (context) => const AddDocumentScreen(),
          DocumentViewScreen.routeName: (context) => const DocumentViewScreen(),
          SettingsScreen.routeName: (context) => const SettingsScreen(),
          SplashScreen.routeName: (context) => const SplashScreen(),
        },
        home: const HomeScreen(),
      ),
    );
  }
}
