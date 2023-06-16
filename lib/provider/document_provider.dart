import 'dart:io';

import 'package:doc_saver_app/helper/snackbar_helper.dart';
import 'package:doc_saver_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DocumentProvider extends ChangeNotifier {
  PlatformFile? selectedFile;
  String _selectedFileName = "";
  String _selectedFileFormat = "";
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  File? _file;
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  String get selectedFileName => _selectedFileName;

  setSelectedFileName(PlatformFile? file) {
    _selectedFileName = file!.name.split(".").first;
    _selectedFileFormat = file.name.split(".").last;
    notifyListeners();
  }

  pickDocument({required BuildContext context}) async {
    await FilePicker.platform
        .pickFiles(
            allowMultiple: false,
            allowedExtensions: ["pdf", "png", "jpg", "jpeg"],
            type: FileType.custom)
        .then((value) {
      if (value != null) {
        selectedFile = value.files.first;
        setSelectedFileName(selectedFile);
        _file = File(selectedFile!.path!);
      } else {
        SnackBarHelper.showErrorSnackBar(context, "No files selected");
      }
    });
  }

  bool _isFileUploading = false;

  bool get isFileUploading => _isFileUploading;

  setIsFileUploading(bool value) {
    _isFileUploading = value;
    notifyListeners();
  }

  resetAll() {
    titleController = TextEditingController();
    noteController = TextEditingController();
    _selectedFileName = "";
    _file = null;
  }

  String userId = FirebaseAuth.instance.currentUser!.uid;

  sendDocumentData({required BuildContext context}) async {
    try {
      setIsFileUploading(true);
      UploadTask uploadTask = _firebaseStorage
          .ref("files/$userId")
          .child(_selectedFileName)
          .putFile(_file!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String uploadedFileUrl = await taskSnapshot.ref.getDownloadURL();
      await _firebaseDatabase.ref().child("files_info/$userId").push().set({
        "title": titleController.text,
        "note": noteController.text,
        "fileUrl": uploadedFileUrl,
        "dateAdded": DateTime.now().toString(),
        "fileName": _selectedFileName,
        "fileType": _selectedFileFormat
      }).then((value) {
        setIsFileUploading(false);
        Navigator.pushNamed(context, HomeScreen.routeName);
      });
      resetAll();
    } on FirebaseException catch (firebaseError) {
      SnackBarHelper.showErrorSnackBar(context, firebaseError.message!);
    } catch (error) {
      SnackBarHelper.showErrorSnackBar(context, error.toString());
    }
    setIsFileUploading(false);
  }

  Future<void> deleteDocument(
      String id, String path, String fileName, BuildContext context) async {
    try {
      await _firebaseStorage.ref("files/$userId/$fileName").delete();
      await _firebaseDatabase.ref("$path/$id").remove().then((value) {
        SnackBarHelper.showSuccessSnackBar(context, "$fileName deleted successfully");
      });
    } on FirebaseException catch (firebaseError) {
      SnackBarHelper.showErrorSnackBar(context, firebaseError.toString());
    }
    notifyListeners();
  }
}
