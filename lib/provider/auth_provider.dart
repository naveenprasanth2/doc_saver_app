import 'package:doc_saver_app/helper/snackbar_helper.dart';
import 'package:doc_saver_app/screens/home_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doc_saver_app/screens/authentication_screen.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  bool _isLogin = false;

  bool get isLogin => _isLogin;

  setIsLogin() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  bool _obscureText = true;

  bool get obscureText => _obscureText;

  setObscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  signUp(
      {required BuildContext context,
      required String email,
      required String password,
      required String userName}) async {
    setIsLoading(true);
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await _firebaseDatabase
            .ref()
            .child("user_info/${value.user!.uid}")
            .set({"username": userName}).then((value) {
          SnackBarHelper.showSuccessSnackBar(
              context, "User successfully logged in");
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        });
        return value;
      });
    } on FirebaseAuthException catch (fireBaseError) {
      SnackBarHelper.showErrorSnackBar(context, fireBaseError.message!);
    } catch (error) {
      SnackBarHelper.showErrorSnackBar(context, error.toString());
    }
    setIsLoading(false);
  }

  signIn(
      {required BuildContext context,
      required String email,
      required String password}) async {
    setIsLoading(true);
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        SnackBarHelper.showSuccessSnackBar(
            context, "User successfully logged in");
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        return value;
      });
    } on FirebaseAuthException catch (fireBaseError) {
      SnackBarHelper.showErrorSnackBar(context, fireBaseError.message!);
    } catch (error) {
      SnackBarHelper.showErrorSnackBar(context, error.toString());
    }
    setIsLoading(false);
  }

  bool _isForgotLoading = false;

  bool get isForgotLoading => _isForgotLoading;

  setIsForgotLoading(bool value) {
    _isForgotLoading = value;
    notifyListeners();
  }

  forgotPassword(BuildContext context, String email) async {
    setIsForgotLoading(true);
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email).then((value) =>
          SnackBarHelper.showSuccessSnackBar(
              context, "Password reset mail sent successfully"));
    } on FirebaseAuthException catch (fireBaseError) {
      SnackBarHelper.showErrorSnackBar(context, fireBaseError.message!);
    } catch (error) {
      print(error.toString());
    }
    setIsForgotLoading(false);
  }

  bool _isLogoutLoading = false;

  bool get isLogoutLoading => _isLogoutLoading;

  setIsLogoutLoading(bool value) {
    _isLogoutLoading = value;
    notifyListeners();
  }

  logout(BuildContext context) async {
    try {
      setIsLogoutLoading(true);
      await _firebaseAuth.signOut().then((value) {
        SnackBarHelper.showSuccessSnackBar(
            context, "User logged out successfully");
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacementNamed(context, AuthenticationScreen.routeName);
      });
    } on FirebaseAuthException catch (fireBaseError) {
      SnackBarHelper.showErrorSnackBar(context, fireBaseError.message!);
    } catch (error) {
      print(error.toString());
    }
    setIsLogoutLoading(false);
  }
}
