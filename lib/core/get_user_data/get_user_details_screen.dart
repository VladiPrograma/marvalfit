import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/utils/extensions.dart';
import 'package:marvalfit/utils/firebase/auth.dart';
import 'package:marvalfit/utils/objects/user_details.dart';
import 'package:marvalfit/widgets/marval_elevated_button.dart';
import 'package:marvalfit/widgets/marval_textfield.dart';
import 'package:sizer/sizer.dart';

import '../../config/log_msg.dart';
import '../../constants/colors.dart';
import '../../constants/string.dart';
import '../../constants/theme.dart';
import '../../utils/firebase/storage.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/planing.dart';
import 'form_screen.dart';

String? _phone;
bool _upToBD = false;
class GetUserDetails extends StatefulWidget {
  const GetUserDetails({Key? key}) : super(key: key);
  static String routeName = "/get_user_details";
  @override
  State<GetUserDetails> createState() => _GetUserDetailsState();
}

class _GetUserDetailsState extends State<GetUserDetails> {
  @override
  void initState() {
    super.initState();
  }
  void updateToBD(XFile? image) async{
    if(isNotNull(image)){
      String? _urlImage = await uploadProfileImg(authUser!.uid, image!);
      user.profileImage = _urlImage;
    }
      ///@TODO Create Custom class for new traning state
      Planing training = Planing.create(habits: ["Sol", "Frio", "Naturaleza"],steps: 10000,
       activities: [
         {"Descanso" :
         { "icon": 'sleep', "label": 'Descanso', "type": 'rest', "id": 'ACT_001'}},
         {"Medidas" :
         { "icon": 'tap', "label": 'Medidas', "type": 'tap', "id": 'ACT_002'}},
         {"Galeria" :
         { "icon": 'gallery', "label": 'Galeria', "images": 'Sleep', "id": 'ACT_003'}},
         {"RMs" :
         { "icon": 'rms', "label": 'RMs', "type": 'table_01', "id": 'ACT_004'}},
       ]);
      training.setInDB();

      logInfo(user);
      user.setInDB();
      user.currenTraining = training;

      /// Update To Firebase User
      await authUser!.updateDisplayName(user.name);
      await authUser!.updatePhotoURL(user.profileImage);
      ///@TODO Test drawer works after creating new user
      authUser = getCurrUser();
      _upToBD = true;
  }
  @override
  Widget build(BuildContext context) {
    final _arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
     XFile? _image = _arguments['image'];
     _phone = _arguments['phone'];
     if(!_upToBD){ updateToBD(_image);}
    return Scaffold(
        backgroundColor: kWhite,
        body: SafeArea(
            child: Container( width: 100.w, height: 100.h,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 4.h,),
                    Container( width: 100.w,
                        child: TextH1("Ya casi esta !"),
                        margin: EdgeInsets.symmetric(horizontal: 5.w)),
                    Container( width: 100.w,
                        child:TextH2("Necesito recopilar estos datos para trabajar de forma optima", color: kGrey,),
                        margin: EdgeInsets.symmetric(horizontal: 5.w)
                    ),
                    SizedBox(height: 4.h,),
                    _Form()
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
    String? _hobbie;
    String? _food;
    String? _city;
    DateTime? _birthDate;
    double? _height;
    double? _weight;
    TextEditingController _textController = TextEditingController();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          MarvalInputTextField(
              prefixIcon: CustomIcons.person,
              labelText: "Hobbie Favorito",
              hintText: "Ir en Bicicleta",
              onSaved: (value) => _hobbie = value!.normalize(),
              validator: (value){
                if(isNullOrEmpty(value)){ return kEmptyValue; }
                if(value!.length>50)    { return kToLong;     }
                return null;
              },
          ),
          SizedBox(height: 3.h,),
          MarvalInputTextField(
              prefixIcon: CustomIcons.food,
              labelText: "Comida Favorita",
              hintText: "Macarrones con tomate",
              onSaved: (value) => _food = value!.normalize(),
              validator: (value){
                if(isNullOrEmpty(value)){ return kEmptyValue;}
                if(value!.length>50)    { return kToLong;    }
                return null;
              },
          ),
          SizedBox(height: 3.h,),
          MarvalInputTextField(
              prefixIcon: Icons.location_city,
              labelText: "Localidad",
              hintText: "Zaragoza",
              onSaved: (value) => _city = value!.normalize(),
              validator: (value){
                if(isNullOrEmpty(value)){ return kEmptyValue; }
                if(value!.length>50)    { return kToLong;     }
                return null;
              },
          ),
          SizedBox(height: 3.h,),
          MarvalInputTextField(
              prefixIcon: CustomIcons.calendar,
              keyboardType: TextInputType.number,
              controller: _textController,
              readOnly: true,
              labelText: "Fecha de Nacimiento",
              hintText: "06/12/2022",
              onTap: () async {
                _birthDate = await pickDate(context);
                if(isNotNull(_birthDate)){
                  _textController.text =  _birthDate!.id;
                }
              },
              validator: (value){
                if(isNullOrEmpty(value)){ return kEmptyValue;  }
                return null;
              },
          ),
          SizedBox(height: 3.h,),
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              MarvalInputTextField(
                width: 33.w,
                prefixIcon: CustomIcons.weight,
                keyboardType: TextInputType.number,
                labelText: "Peso",
                hintText: "79.5",
                validator: (value) => validateNumber(value),
                onSaved: (value) => _weight = value!.toDouble(),
              ),
              SizedBox(width: 4.w,),
              MarvalInputTextField(
                  width: 33.w,
                  keyboardType: TextInputType.number,
                  prefixIcon: CustomIcons.size,
                  labelText: "Altura",
                  hintText: "1.89",
                  validator: (value) => validateNumber(value),
                  onSaved: (value){
                    double? _curr = value!.toDouble();
                    if(_curr!>3){
                      String _newValue = value.replaceFirst(value.characters.first, value.characters.first+'.');
                      return _newValue.toDouble();
                    }
                    _height = _curr;
                  }
              ),
          ]),
          SizedBox(height: 6.h,),
          MarvalElevatedButton(
              "Continuar",
              onPressed: () async{
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  ///* Set details */
                  Details details = Details.create(
                      height: _height!,
                      favoriteFood: _food!,
                      phone: _phone!,
                      city: _city!,
                      birthDate: _birthDate!,
                      initialWeight: _weight!,
                      hobbie: ''
                  );
                  details.setDetails();
                  logInfo(details.toString());
                  ///* Set Weight */
                  user.updateWeight(weight: _weight!);
                  user.updateHobbie(hobbie: _hobbie!);
                  user.details = details;
                  logInfo(user.toString());

                  Navigator.popAndPushNamed(context, FormScreen.routeName);
                }
              })
      ]),
    );
  }

}


Future<DateTime?> pickDate(BuildContext context) => showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate:DateTime(2100),
    locale: const Locale("es", "ES"),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: kGreen,
            onPrimary: kWhite,
            onSurface: kBlack,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: kBlack,
              textStyle: TextStyle(fontSize: 3.3.w, fontFamily: h2, color: kBlack)
          ))),
        child: child!,
      );
    },
  );









