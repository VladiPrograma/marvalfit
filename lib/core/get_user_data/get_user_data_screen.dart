import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/core/get_user_data/get_user_data_metrics.dart';
import 'package:marvalfit/utils/objects/user.dart';
import 'package:marvalfit/widgets/marval_elevated_button.dart';
import 'package:marvalfit/widgets/marval_textfield.dart';
import 'package:sizer/sizer.dart';

import '../../constants/colors.dart';
import '../../constants/string.dart';
import '../../constants/theme.dart';
import '../../utils/marval_arq.dart';

final ImagePicker _picker = ImagePicker();

class GetUserDataScreen extends StatelessWidget {
  const GetUserDataScreen({Key? key}) : super(key: key);
  static String routeName = "/get_user_data";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Container( width: 100.w, height: 100.h,
        child: SingleChildScrollView(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 3.h,),
            ProfilePhoto(),
            Container( width: 100.w,
                child: TextH1("Sube una foto"),
                margin: EdgeInsets.symmetric(horizontal: 5.w)),
            Container( width: 100.w,
              child:TextH2("Asi podre reconocerte con facilidad", color: kGrey,),
              margin: EdgeInsets.symmetric(horizontal: 5.w)
            ),
            SizedBox(height: 2.h,),
            _Form()
          ],
        ),
      ),
     )));
  }
}
MarvalUser? currUser;
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
                  currUser = MarvalUser.create(_name!, _lastName!, _job!,  0, 0);
                  print(currUser);
                  await currUser!.setMarvalUser();
                  Navigator.pushNamed(context, GetUserMetricsScreen.routeName);
            }})
        ],
      ),
    );
  }
}

class ProfilePhoto extends StatefulWidget {
  const ProfilePhoto({Key? key}) : super(key: key);

  @override
  State<ProfilePhoto> createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  XFile? _backgroundImage;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        onTap: () async{
          print('webo');
          _backgroundImage = await _picker.pickImage(source: ImageSource.camera);
          setState(() { });
        },
        child: CircleAvatar(
          backgroundColor: kBlack,
          backgroundImage: isNotNull(_backgroundImage) ? Image.file(File(_backgroundImage!.path)).image : null,
          radius: 23.w,
          child: isNull(_backgroundImage) ? Icon(CustomIcons.person, color: kWhite, size: 17.w,): null,
        ));
  }
}


String? validateNumber(String? value){
    double? _curr;
    if(isNullOrEmpty(value)){
      return kInputErrorEmptyValue;
    }
    try{
      _curr = double.parse(value!);
    }catch(E){
      return kInputErrorNotNum;
    }
    if(_curr.isNaN||_curr.isNegative||_curr>500){
      return kInputErrorNotNum;
    }
    return null;
}

String? toCamellCase(String? value){
  value = value!.toLowerCase();
  List<String> _list = value.split(" ");
  String res = "";
  for(String x in _list){
    res+= x.replaceFirst(x.characters.first, x.characters.first.toUpperCase());
    res+=" ";
  }
  return res.trim();
}