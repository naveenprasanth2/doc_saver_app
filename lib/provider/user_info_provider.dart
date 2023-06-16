import 'package:doc_saver_app/helper/snackbar_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class UserInfoProvider extends ChangeNotifier {
  String? _userName;
  String? _emailId;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  User? user = FirebaseAuth.instance.currentUser;

  get userName {
    if (_userName == null) {
      getUserName();
    }
    return _userName;
  }

  get emailId {
    if (_emailId == null) {
      getEmailId();
    }
    return _emailId;
  }

  getUserName() async {
    await _firebaseDatabase
        .ref()
        .child("user_info/${user!.uid}")
        .get()
        .then((value) {
      print(value.value);
      _userName = (value.value as Map)["username"].toString();
      notifyListeners();
    });
  }

  updateUserName(String userName, BuildContext context) async {
    await _firebaseDatabase.ref()
        .child("user_info/${user!.uid}")
        .update({"username": userName}).then((value) {
      _userName = userName;
      Navigator.pop(context);
      SnackBarHelper.showSuccessSnackBar(
          context, "username updated successfully");
      notifyListeners();
    });
  }

  getEmailId(){
    _emailId = user!.email;
  }

}
