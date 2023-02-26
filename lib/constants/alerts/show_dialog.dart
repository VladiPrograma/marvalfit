import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/colors.dart';
import 'package:marvalfit/constants/string.dart';
import 'package:marvalfit/firebase/habits/model/habits.dart';

import 'package:marvalfit/firebase/messages/model/message.dart';
import 'package:marvalfit/firebase/trainings/model/training.dart';
import 'package:marvalfit/widgets/marval_dialogs.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:sizer/sizer.dart';


class ThrowDialog{

  static void uploadImage(BuildContext context, XFile xfile){
    MarvalImageAlert(context,
        image: xfile,
        title: "Deseas subir esta foto ?",
        onAccept: () async{
           String? networkImg = await storageController.uploadChatImage(uid!, xfile);
           if(networkImg !=null){
             Message message = Message.create( networkImg, MessageType.IMAGE, uid!);
             messagesLogic.add(context.ref, message);
           }
        });
  }

  static void goBackWithoutSaving({required BuildContext context, required Function onAccept, required Function onCancel}){
    return MarvalDialogsAlert(context,
        height: 30,
        type: MarvalDialogAlertType.DELETE,
        title: r'Salir sin guardar ?',
        richText: RichText(text:  TextSpan(text: r'Tus cambios se perderan y no se veran reflejados si sales sin guardar', style: TextStyle(color: kBlack, fontFamily: p2, fontSize: 3.8.w ))),
        acceptText: r'Guardar',
        cancelText: r'Salir',
        onAccept: () => onAccept(),
        onCancel: () => onCancel());
  }
}