import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:marvalfit/core/get_user_data/get_user_data_metrics.dart';
import 'package:marvalfit/widgets/marval_elevated_button.dart';
import 'package:marvalfit/widgets/marval_textfield.dart';
import 'package:marvalfit/widgets/marval_dialogs.dart';
import 'package:marvalfit/utils/firebase/storage.dart';
import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/utils/objects/user.dart';

import '../../config/log_msg.dart';
import '../../constants/colors.dart';
import '../../constants/global_variables.dart';
import '../../constants/string.dart';
import '../../constants/theme.dart';
import '../../utils/marval_arq.dart';

final ImagePicker _picker = ImagePicker();
/// @TODO Add const variables
class GetUserDataScreen extends StatelessWidget {
  const GetUserDataScreen({Key? key}) : super(key: key);
  static String routeName = "/get_user_data";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: SizedBox( width: 100.w, height: 100.h,
        child: SingleChildScrollView(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 3.h,),
            ProfilePhoto(),
            Container( width: 100.w,
                child: const TextH1("Sube una foto"),
                margin: EdgeInsets.symmetric(horizontal: 5.w)),
            Container( width: 100.w,
              child: const TextH2("Asi podre reconocerte con facilidad", color: kGrey,),
              margin: EdgeInsets.symmetric(horizontal: 5.w)
            ),
            SizedBox(height: 2.h,),
            const _Form()
          ],
        ),
      ),
     )));
  }
}
/// @TODO: do something with this variables, is really ugly to see
String? phone;
class _Form extends StatelessWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? _name;
    String? _lastName;
    String? _job;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          MarvalInputTextField(
            prefixIcon: CustomIcons.person,
            labelText: "Nombre",
            hintText: "Mario",
            validator: (value){
              if(isNullOrEmpty(value)){
                return kInputErrorEmptyValue;
              }if(value!.length>25){
                return kInputErrorToLong;
              }
              return null;
            },
            onSaved: (value) => _name = toCamellCase(value)!
          ),
          SizedBox(height: 3.h,),
          MarvalInputTextField(
            prefixIcon: CustomIcons.person,
            labelText: "Apellido",
            hintText: "Valgañon",
            validator: (value){
              if(isNullOrEmpty(value)){
                return kInputErrorEmptyValue;
              }if(value!.length>25){
                return kInputErrorToLong;
              }
              return null;
            },
            onSaved: (value) => _lastName = toCamellCase(value)!
          ),
          SizedBox(height: 3.h,),
          MarvalInputTextField(
            prefixIcon: Icons.settings,
            labelText: "Trabajo",
            hintText: "Entrenador",
            validator: (value){
              if(isNullOrEmpty(value)){
                return kInputErrorEmptyValue;
              }if(value!.length>50){
                return kInputErrorToLong;
              }
              return null;
            },
            onSaved: (value) {
              value = value!.toLowerCase();
              _job = value.replaceFirst(value.characters.first, value.characters.first.toUpperCase()).trim();
            }
          ),
          SizedBox(height: 3.h,),
          MarvalInputTextField(
              prefixIcon: CustomIcons.phone,
              keyboardType: TextInputType.number,
              labelText: "Telefono",
              hintText: "622427441",
              validator: (value){
                if(isNullOrEmpty(value)){
                  return kInputErrorEmptyValue;
                }if(value!.length!=9){
                  return kInputErrorPhone;
                }
                return null;
              },
              onSaved: (value) { phone = value;}
          ),
          SizedBox(height: 4.h,),
          MarvalElevatedButton(
              "Continuar",
              onPressed: () async{
            if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if(isNull(_backgroundImage)){
                     MarvalDialogsAlert(context, type: MarvalDialogAlertType.ACCEPT, height: 37,
                        title: "Sube una foto de perfil!",
                        richText: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            text: "No es obligatorio subir una foto de perfil pero me ayuda a la hora de",
                            style: TextStyle(fontFamily: p2, fontSize: 4.5.w, color: kBlack),
                            children: const <TextSpan>[
                              TextSpan(
                                  text:  " localizarte antes",
                                  style: TextStyle(fontWeight: FontWeight.bold)
                              ),
                              TextSpan(
                                  text:" dentro de la App.\nVenga animate! Pulsa"
                              ),
                              TextSpan(
                                  text:  " aceptar",
                                  style: TextStyle(fontWeight: FontWeight.bold)
                              ),
                              TextSpan(
                                  text:  " si no quieres subir la foto para continuar.",
                              ),
                            ],
                          ),
                        ),
                        onAccept: () async {
                          user = MarvalUser.create(_name!, _lastName!, _job!, null,  0, 0);

                          logInfo(user.toString());
                          await user.setInDB();

                          /// Update To Firebase User
                          authUser!.updateDisplayName("$_name");
                          Navigator.pushNamed(context, GetUserMetricsScreen.routeName);
                       }
                    );
                  }else{
                    String? _urlImage = await uploadProfileImg(authUser!.uid, _backgroundImage!);
                    user = MarvalUser.create(_name!, _lastName!, _job!, _urlImage,  0, 0);
                    await user.setInDB();
                    authUser!.updatePhotoURL(_urlImage);
                    authUser!.updateDisplayName("$_name");
                    Navigator.pushNamed(context, GetUserMetricsScreen.routeName);
                  }
            }})
        ],
      ),
    );
  }
}
XFile? _backgroundImage;
class ProfilePhoto extends StatefulWidget {
  const ProfilePhoto({Key? key}) : super(key: key);

  @override
  State<ProfilePhoto> createState() => _ProfilePhotoState();
}
class _ProfilePhotoState extends State<ProfilePhoto> {
  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        GestureDetector(
            onTap: () async{
              _backgroundImage = await _picker.pickImage(source: ImageSource.gallery);
              setState(() { });
            },
            child: CircleAvatar(
              backgroundColor: kBlack,
              backgroundImage: isNotNull(_backgroundImage) ? Image.file(File(_backgroundImage!.path)).image : null,
              radius: 23.w,
              child: isNull(_backgroundImage) ? Icon(CustomIcons.person, color: kWhite, size: 17.w,): null,
        )),
        Positioned(
          bottom: 1.w,
          right: 3.w,
          child: GestureDetector(
            onTap: () async{
              _backgroundImage = await _picker.pickImage(source: ImageSource.gallery);
              setState(() { });
           },
           child: CircleAvatar(
             backgroundColor: kBlack,
             radius: 8.w,
             child: Icon(CustomIcons.camera, color:kWhite, size: 5.w,),
      ))),
    ]);
  }
}

