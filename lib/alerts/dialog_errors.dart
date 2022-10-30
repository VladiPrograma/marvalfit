
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../config/log_msg.dart';
import '../constants/global_variables.dart';
import '../constants/string.dart';
import '../utils/firebase/storage.dart';
import '../utils/marval_arq.dart';
import '../utils/objects/message.dart';
import '../widgets/marval_dialogs.dart';

class ThrowDialog{


  static void uploadImage(BuildContext context, XFile image){
    MarvalImageAlert(context,
        image: image,
        title: "Deseas subir esta foto ?",
        onAccept: () async{
          Message imageMessage = Message.image();
          String? docID = await imageMessage.addInDB();
          if(isNotNull(docID)){
            imageMessage.message = await uploadChatImage(
                uid: user.id,
                date: imageMessage.date,
                name: docID!,
                xfile: image
            );
            imageMessage.setInDB(docID);
          }else{
            logError("$logErrorPrefix Problem adding Image to BD");
          }
        });
  }

}