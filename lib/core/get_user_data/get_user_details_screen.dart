import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'form_screen.dart';

import '../../config/log_msg.dart';
import '../../config/custom_icons.dart';
import '../../modules/settings/settings_screen.dart';

import '../../widgets/marval_elevated_button.dart';
import '../../widgets/marval_textfield.dart';

import '../../constants/global_variables.dart';
import '../../constants/string.dart';
import '../../constants/theme.dart';
import '../../constants/colors.dart';
import '../../utils/marval_arq.dart';
import '../../utils/extensions.dart';
import '../../utils/firebase/auth.dart';
import '../../utils/objects/planing.dart';
import '../../utils/firebase/storage.dart';

bool _upToBD = false;

class GetUserDetails extends StatefulWidget {
  const GetUserDetails({Key? key}) : super(key: key);
  static String routeName = "/get_user_details";
  @override
  State<GetUserDetails> createState() => _GetUserDetailsState();
}

class _GetUserDetailsState extends State<GetUserDetails> {

  void updateToBD(XFile? image) async{
    if(isNotNull(image)){
      String? _urlImage = await uploadProfileImg(authUser.uid, image!);
      user.profileImage = _urlImage;
    }
      ///@TODO Create Custom class for new traning state
      Planing training = Planing.createNewTraining();

      logInfo(user);
      user.setInDB();
      user.currenTraining = training;

      /// Update To Firebase User
      await authUser.updateDisplayName(user.name);
      await authUser.updatePhotoURL(user.profileImage);
      ///@TODO Test drawer works after creating new user
      authUser = getCurrUser()!;
      _upToBD = true;
  }
  void updateProfileImage(XFile? image) async{
    logInfo('Here we are ${image ?? 'loco'}');
    if(isNotNull(image)){
      String? _urlImage = await uploadProfileImg(authUser.uid, image!);
      user.profileImage = _urlImage;
      user.uploadInDB({'profile_image' : _urlImage});
      await authUser.updatePhotoURL(user.profileImage);
    }
    _upToBD = true;
  }
  @override
  Widget build(BuildContext context) {
    final _arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
     XFile? _image = _arguments['image'];
     ///@TODO Change this line with something with more sense
     if(!_upToBD && user.currWeight == 0){ updateToBD(_image);}
     else {updateProfileImage(_image);}
    return Scaffold(
        backgroundColor: kWhite,
        body: SafeArea(
            child: SizedBox( width: 100.w, height: 100.h,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 4.h,),
                    Container( width: 100.w,
                        child: const TextH1("Ya casi esta !"),
                        margin: EdgeInsets.symmetric(horizontal: 5.w)),
                    Container( width: 100.w,
                        child: const TextH2("Necesito recopilar estos datos para trabajar de forma optima", color: kGrey,),
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
    DateTime? _birthdate;
    double? _height;
    double? _weight;
    TextEditingController _textController = TextEditingController(
                                            text: isNotNull(user.birthdate) ?
                                            user.birthdate!.toFormatStringDate() : null );
    return Form(
      key: _formKey,
      child: Column(
        children: [
          MarvalInputTextField(
              prefixIcon: CustomIcons.person,
              labelText: "Hobbie Favorito",
              hintText: "Ir en Bicicleta",
              initialValue: isNotNullOrEmpty(user.hobbie) ? user.hobbie : null,
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
              initialValue: isNotEmpty(user.favoriteFood) ? user.favoriteFood : null,
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
            initialValue: isNotEmpty(user.city) ? user.city : null,
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
                _birthdate = await pickDate(context);
                if(isNotNull(_birthdate)){
                  _textController.text =  _birthdate!.id;
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
                initialValue: user.initialWeight!=0 ? user.initialWeight.toString() : null,
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
                  initialValue: user.height!=0 ? user.height.toStringAsFixed(0) : null,
                  validator: (value) => validateNumber(value),
                  onSaved: (value){
                    double? _curr = value!.toDouble();
                    if(_curr!>3){
                      String _newValue = value.replaceFirst(value.characters.first, value.characters.first+'.');
                      _height = _newValue.toDouble();
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
                  ///@Change this lane with something with more sense
                  bool _fromSettings = user.currWeight!=0;
                  if(isNull(_birthdate)){_birthdate = user.birthdate;}
                  ///* Set details */
                  user.updateDetails(
                      height: _height!,
                      favoriteFood: _food!,
                      city: _city!,
                      birthdate: _birthdate!,
                      initialWeight: _weight!,
                      hobbie: _hobbie!
                  );
                  ///* Set Weight */
                  logInfo(user.toString());
                  _fromSettings ? Navigator.popAndPushNamed(context, SettingScreen.routeName)
                      :
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









