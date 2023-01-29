import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:marvalfit/firebase/storage/service/storage_service.dart';

class StorageController{
  final StorageService _service = StorageService();

  Future<String?> uploadUserImg(String userId, XFile xfile) async{
    const storageCollection = 'user';
    const String slash = '/';
    final File file = File(xfile.path);
    Uint8List filePath = await xfile.readAsBytes();

    final String extension = path.extension(file.path);
    final String storagePath = storageCollection + slash + userId + extension;
    return _service.uploadFile(filePath, storagePath); // Image Network Direction
  }

  Future<String?> uploadChatImage (String userId,  XFile xfile ) async{
    const String parent = 'chat';
    const String slash = '/';
    final String id = Timestamp.now().microsecondsSinceEpoch.toString();

    final file = File(xfile.path);
    Uint8List filePath = await xfile.readAsBytes();

    final extension = path.extension(file.path);
    final String storagePath = parent + slash + userId + slash + id + extension;

    return _service.uploadFile(filePath, storagePath); // Image Network Direction
  }

  Future<String?> uploadExerciseImage(XFile xfile ) async{
    const String parent = 'exercises';
    const String slash = '/';
    final String id = Timestamp.now().microsecondsSinceEpoch.toString();

    final file = File(xfile.path);
    Uint8List filePath = await xfile.readAsBytes();

    final extension = path.extension(file.path);
    final String storagePath = parent + slash + id + extension;

    return _service.uploadFile(filePath, storagePath); // Image Network Direction
  }

  Future<String?> uploadChatAudio (String userId, String audioPath ) async{
    const String parent = 'chat';
    const String slash = '/';
    const String extension = '.acc';
    final String id = Timestamp.now().microsecondsSinceEpoch.toString();

    final file = File(audioPath);
    Uint8List filePath = await file.readAsBytes();

    final String storagePath = parent + slash + userId + slash + id + extension;

    return _service.uploadFile(filePath, storagePath); // Image Network Direction
  }
}