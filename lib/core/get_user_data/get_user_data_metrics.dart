import 'package:flutter/material.dart';
import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/utils/objects/user_details.dart';
import 'package:marvalfit/widgets/marval_elevated_button.dart';
import 'package:marvalfit/widgets/marval_textfield.dart';
import 'package:sizer/sizer.dart';

import '../../config/log_msg.dart';
import '../../constants/colors.dart';
import '../../constants/string.dart';
import '../../constants/theme.dart';
import '../../utils/marval_arq.dart';
import 'form_screen.dart';
import 'get_user_data_screen.dart';

class GetUserMetricsScreen extends StatelessWidget {
  const GetUserMetricsScreen({Key? key}) : super(key: key);
  static String routeName = "/get_user_metrics";

  @override
  Widget build(BuildContext context) {
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
              validator: (value){
                if(isNullOrEmpty(value)){
                  return kInputErrorEmptyValue;
                }if(value!.length>50){
                  return kInputErrorToLong;
                }
                return null;
              },
              onSaved: (value) => _hobbie = normalize(value)!
          ),
          SizedBox(height: 3.h,),
          MarvalInputTextField(
              prefixIcon: CustomIcons.food,
              labelText: "Comida Favorita",
              hintText: "Macarrones con tomate",
              validator: (value){
                if(isNullOrEmpty(value)){
                  return kInputErrorEmptyValue;
                }if(value!.length>50){
                  return kInputErrorToLong;
                }
                return null;
              },
              onSaved: (value) => _food = normalize(value)!
          ),
          SizedBox(height: 3.h,),
          MarvalInputTextField(
              prefixIcon: Icons.location_city,
              labelText: "Localidad",
              hintText: "Zaragoza",
              validator: (value){
                if(isNullOrEmpty(value)){
                  return kInputErrorEmptyValue;
                }if(value!.length>50){
                  return kInputErrorToLong;
                }
                return null;
              },
              onSaved: (value) => _city = normalize(value)!
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
                String dateToText = "${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}";
                _textController.text = dateToText;
                }
              },
              validator: (value){
                if(isNullOrEmpty(value)){
                  return kInputErrorEmptyValue;
                }
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
                onSaved: (value) => _weight = toDouble(value),
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
                    double? _curr = toDouble(value);
                    if(_curr!>3){
                      String _newValue = value!.replaceFirst(value.characters.first, value.characters.first+'.');
                      _height = toDouble(_newValue);
                      return;
                    }
                    _height = _curr;
                  }
              ),
            ],),
          SizedBox(height: 6.h,),
          MarvalElevatedButton(
              "Continuar",
              onPressed: () async{
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  UserDetails details = UserDetails.create(_height!, _food!, _hobbie!, phone!, _city!, _birthDate!, _weight!);
                  details.setUserDetails();
                  logInfo(details.toString());
                  user.updateWeight(_weight!);
                  user.details = details;
                  logInfo(user.toString());
                  Navigator.pushNamed(context, FormScreen.routeName);
                }
              })
        ],
      ),
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
            ),

          ),
        ),
        child: child!,
      );
    },
  );









