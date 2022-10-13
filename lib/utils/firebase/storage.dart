import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marvalfit/utils/extensions.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marvalfit/config/log_msg.dart';


Future<String> uploadProfileImg (String uid, XFile xfile) async{
  const path = 'user/';
  final file = File(path);
  final extension = p.extension(file.path);
  logInfo('Pending to update: ${path+uid+extension}');
  final ref = FirebaseStorage.instance.ref().child(path+uid+extension);
  UploadTask uploadTask = ref.putFile(file);

  final snapshot = await uploadTask.whenComplete(() => {});
  final urlDownload = await snapshot.ref.getDownloadURL();
  logInfo('Download Link: $urlDownload');

  return urlDownload;
}

Future<String> uploadChatImage ({required String uid, required String name, required DateTime date, required XFile xfile}) async{
  final path = 'chat/$uid/';
  final file = File(xfile.path);
  final extension = p.extension(file.path);
  /*** Updating  **/
  logInfo('Pending to update: ${path+uid+extension}');
  final ref = FirebaseStorage.instance.ref().child(path+name+extension);
  UploadTask uploadTask = ref.putFile(file);
  final snapshot = await uploadTask.whenComplete(() => {});

  /*** Getting the URL  **/
  final urlDownload = await snapshot.ref.getDownloadURL();
  logInfo('Download Link: $urlDownload');
  return urlDownload;
}
Future<String> uploadChatAudio({required String uid, required DateTime date, required String audioPath}) async{
  final path = 'chat/$uid/';
  final file = File(audioPath);
  const extension = ".acc";
  /*** Updating  **/
  logInfo('Pending to update: ${path+audioPath}');
  int seconds = Timestamp.fromDate(date).seconds;
  final ref = FirebaseStorage.instance.ref().child("$path$seconds$extension");
  UploadTask uploadTask = ref.putFile(file);
  final snapshot = await uploadTask.whenComplete(() => {});

  /*** Getting the URL  **/
  final urlDownload = await snapshot.ref.getDownloadURL();
  logInfo('Download Link: $urlDownload');
  return urlDownload;
}

Future<String> uploadImageFromGallery (String uid, String name, DateTime date,  XFile xfile) async{
  final path = 'gallery/$uid/${date.id}/';
  final file = File(xfile.path);
  final extension = p.extension(file.path);
  logInfo('Pending to update: ${path+uid+extension}');
  final ref = FirebaseStorage.instance.ref().child(path+name+extension);
  UploadTask uploadTask = ref.putFile(file);

  final snapshot = await uploadTask.whenComplete(() => {});
  final urlDownload = await snapshot.ref.getDownloadURL();
  logInfo('Download Link: $urlDownload');
  return urlDownload;
}

