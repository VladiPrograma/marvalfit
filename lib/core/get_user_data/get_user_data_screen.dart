import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../utils/objects/user.dart';
import '../../widgets/marval_elevated_button.dart';
import '../../widgets/marval_textfield.dart';
import '../../widgets/marval_dialogs.dart';

import '../../utils/marval_arq.dart';
import '../../utils/extensions.dart';
import '../../config/custom_icons.dart';

import '../../constants/colors.dart';
import '../../constants/global_variables.dart';
import '../../constants/string.dart';
import '../../constants/theme.dart';
import 'get_user_details_screen.dart';

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

class _Form extends StatelessWidget {
  const _Form({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? _name;
    String? _lastName;
    String? _phone;
    String? _job;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          MarvalInputTextField(
            prefixIcon: CustomIcons.person,
            labelText: "Nombre",
            hintText:  "Mario" ,
            initialValue: isNotEmpty(user.id) ? user.name : null,
            onSaved: (value) => _name = value!.toCamellCase(),
            validator: (value){
              if(isNullOrEmpty(value)){ return kEmptyValue;}
              if(value!.length>25)    { return kToLong    ;}
              return null;
            },
          ),
          SizedBox(height: 3.h,),
          MarvalInputTextField(
            prefixIcon: CustomIcons.person,
            labelText: "Apellido",
            hintText: "Valgañon",
            initialValue: isNotEmpty(user.id) ? user.lastName : null,
            onSaved: (value) => _lastName = value!.toCamellCase(),
            validator: (value){
              if(isNullOrEmpty(value)){ return kEmptyValue; }
              if(value!.length>25)    { return kToLong;     }
              return null;
            },
          ),
          SizedBox(height: 3.h,),
          MarvalInputTextField(
            prefixIcon: Icons.settings,
            labelText: "Trabajo",
            hintText: "Entrenador",
            initialValue: isNotEmpty(user.id) ? user.work : null,
            validator: (value){
              if(isNullOrEmpty(value)){ return kEmptyValue; }
              if(value!.length>50)    { return kToLong;  }
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
              initialValue: isNotEmpty(user.id) ? user.details!.phone : null,
              validator: (value){
                if(isNullOrEmpty(value)){
                  return kEmptyValue;
                }if(value!.length!=9){
                  return kPhone;
                }
                return null;
              },
              onSaved: (value) { _phone = value;}
          ),
          SizedBox(height: 4.h,),
          MarvalElevatedButton(
              "Continuar",
              onPressed: () async{
            if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if(isNotEmpty(user.id)){
                    user.updateBasicData(name: _name!, lastName: _lastName!, work: _job!);
                    user.details!.uploadDetails({ "phone" : _phone! });
                    authUser.updateDisplayName(user.name);
                    authUser.updatePhotoURL(user.profileImage);

                    Navigator.popAndPushNamed(context, GetUserDetails.routeName);
                  }
                  else {
                    user = await MarvalUser.getFromDB(authUser.uid);
                    if (isNull(_backgroundImage) && isNull(user.profileImage)) {
                      MarvalDialogsAlert(
                          context, type: MarvalDialogAlertType.ACCEPT,
                          height: 30,
                          title: "Sube una foto de perfil",
                          acceptText: "continuar",
                          cancelText: "volver",
                          richText: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              text: "No es obligatorio subir una foto de perfil pero me ayuda a la hora de",
                              style: TextStyle(fontFamily: p2,
                                  fontSize: 4.5.w,
                                  color: kBlack),
                              children: const <TextSpan>[
                                TextSpan(
                                    text: " localizarte",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: " dentro de la App. Venga animate! "
                                ),
                              ],
                            ),
                          ),
                          onAccept: () {
                            user.updateBasicData(name: _name!,
                                lastName: _lastName!,
                                work: _job!);
                            Navigator.popAndPushNamed(
                                context, GetUserDetails.routeName, arguments: {
                              'image': _backgroundImage,
                              'phone': _phone
                            });
                          }
                      );
                    }
                    else {
                      user.updateBasicData( name: _name!, lastName: _lastName!, work: _job!);
                      Navigator.popAndPushNamed(context,
                          GetUserDetails.routeName,
                          arguments: {
                          'image': _backgroundImage,
                          'phone': _phone
                      });
                    }
                  }
       }})
     ]),
    );
  }
}

XFile? _backgroundImage;
final ImagePicker _picker = ImagePicker();

///@TODO Add Watcher here instead of StatefulWidget
///@TODO Check if works without profile image loaded
class ProfilePhoto extends StatefulWidget {
  const ProfilePhoto({Key? key}) : super(key: key);

  @override
  State<ProfilePhoto> createState() => _ProfilePhotoState();
}
class _ProfilePhotoState extends State<ProfilePhoto> {
  @override
  Widget build(BuildContext context) {
    return  Stack( children: [
        GestureDetector(
         onTap: () async{
           _backgroundImage = await _picker.pickImage(source: ImageSource.gallery);
           setState(() { });
         },
         child: CircleAvatar(
           backgroundColor: kBlack,
           backgroundImage:
           isNotNull(_backgroundImage) ?
           Image.file(File(_backgroundImage!.path)).image
               :
           isNotEmpty(user.id) ?
           Image.network(user.profileImage ?? '').image
           :
           null,
           radius: 23.w,
           child: isNull(_backgroundImage) && isEmpty(user.id) && isNull(user.profileImage) ?
           Icon(CustomIcons.person, color : kWhite, size: 17.w,)
           :
           const SizedBox(),
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

