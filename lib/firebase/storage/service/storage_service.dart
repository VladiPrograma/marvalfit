
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:marvalfit/config/log_msg.dart';

class StorageService {

  Future<String?> uploadFile(Uint8List filePath, String fileName) async {
    try {
      final snapshot = await  FirebaseStorage.instance.ref().child(fileName).putData(filePath);
      final urlDownload = await snapshot.ref.getDownloadURL();
      return urlDownload;
    } catch (e) {
      logError(e);
      return null;
    }
  }

  Future<String?> getDownloadURL(String fileName) async {
    try {
      return await FirebaseStorage.instance
          .ref()
          .child(fileName)
          .getDownloadURL();
    } catch (e) {
      logError(e);
      return null;
    }
  }

  Future<void> deleteFile(String fileName) async {
    try {
      await FirebaseStorage.instance.ref().child(fileName).delete();
    } catch (e) {
      logError(e);
    }
  }
}