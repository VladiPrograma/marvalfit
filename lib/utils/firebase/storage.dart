import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marvalfit/config/log_msg.dart';


Future<String> uploadProfileImg (String uid, XFile xfile) async{
  const path = 'user/';
  final file = File(xfile.path);
  final extension = p.extension(file.path);
  logInfo('Pending to update: ${path+uid+extension}');
  final ref = FirebaseStorage.instance.ref().child(path+uid+extension);
  UploadTask uploadTask = ref.putFile(file);

  final snapshot = await uploadTask.whenComplete(() => {});
  final urlDownload = await snapshot.ref.getDownloadURL();
  logInfo('Download Link: $urlDownload');

  return urlDownload;

}