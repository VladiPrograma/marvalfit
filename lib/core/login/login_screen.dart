import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:marvalfit/core/get_user_data/get_user_data_screen.dart';
import 'package:marvalfit/widgets/marval_elevated_button.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:marvalfit/utils/marval_arq.dart';

import '../../config/custom_icons.dart';
import '../../constants/colors.dart';
import '../../constants/string.dart';
import '../../constants/global_variables.dart';
import '../../utils/firebase/auth.dart';
import '../../widgets/marval_dialogs.dart';
import '../../widgets/marval_textfield.dart';

/// FIXME: Pop and push when login.
/// TODO Configure in Firebase Reset Password Email

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String routeName = "/login";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(child:
         Container( width: 100.w, height: 100.h,
          padding: EdgeInsets.only(top: 6.h),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logo.png"),
                  Container(width: 70.w, margin: EdgeInsets.only(right: 10.w),
                      child: const TextH1( "Bienvenido!")),
                  Container(width: 70.w,margin: EdgeInsets.only(right:10.w),
                      child: const TextH2(
                      'La forma de predecir el futuro es creándolo.',
                      color: kGrey
                  )),
                  SizedBox(height: 5.h,),
                  _LogInForm(),
                ])),
          )
      ),
      );
  }
}


class _LogInForm extends StatelessWidget {
  const _LogInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String _email= "";
    String _password= "";
    String? _loginErrors;
    return Form(
        key: _formKey,
        child: Column(
          children: [
            /** INPUT TEXT FIELD*/
            MarvalInputTextField(
              labelText: 'Email',
              hintText: "marvalfit@gmail.com",
              prefixIcon: CustomIcons.mail,
              keyboardType: TextInputType.emailAddress,
              validator: (value){
                if(isNullOrEmpty(value)){
                  return kInputErrorEmptyValue;
                }if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)){
                  return kInputErrorEmailMissmatch;
                }
                return null;
              },
              onSaved: (value){_email = value!;},
              onChanged: (value){ _loginErrors = null; },
            ),
            SizedBox(height: 5.h,),
            MarvalInputTextField(
              labelText: 'Contraseña',
              hintText: "********",
              prefixIcon: CustomIcons.lock,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              validator: (value){
                if(isNullOrEmpty(value)){
                  return kInputErrorEmptyValue;
                }
                return _loginErrors;
              },
              onSaved: (value){ _password = value!;},
              onChanged: (value){ _loginErrors = null; },
            ),
            SizedBox(height: 5.h),
            MarvalElevatedButton(
              "Comenzar",
              onPressed:  () async{

                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  print('Email: $_email\nPassword: $_password');
                  /// We try to LogIn
                  _loginErrors = await LogIn(_email, _password);
                  _formKey.currentState!.validate();
                  if(isNull(_loginErrors)&&isNotNull(FirebaseAuth.instance.currentUser)){
                    authUser = FirebaseAuth.instance.currentUser;
                    /** PANTALLA TEST */
                    Navigator.pushNamed(context, GetUserDataScreen.routeName);
                  }
                }
              },
            ),
            ResetPasswordButton(),
            SizedBox(height: 5.h,),
          ],
        ));
  }
}

class ResetPasswordButton extends StatelessWidget {
  const ResetPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? _email;
    return GestureDetector(
        child:Container(
          margin: EdgeInsets.only( top: 2.w),
          child: TextH2("¿Olvidaste tu contraseña?", size: 3, color: kGrey,),
        ),
        onTap: (){
          RichText _richText = RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              text: "Si el correo se encuentra dado de alta se enviará un ",
              style: TextStyle(fontFamily: p2, fontSize: 4.5.w, color: kBlack),
              children: const <TextSpan>[
                TextSpan(
                    text:  " email de inmediato",
                    style: TextStyle(fontWeight: FontWeight.bold)
                ),
                TextSpan(
                    text:" desde el que podra restablecer su contraseña"
                ),
              ],
            ),
          );
          GlobalKey<FormState> _formKey = GlobalKey();
          Form _form = Form(
            key: _formKey,
            child: MarvalInputTextField(
              labelText: 'Email',
              hintText: "marvalfit@gmail.com",
              prefixIcon: CustomIcons.mail,
              keyboardType: TextInputType.emailAddress,
              validator: (value){
                if(isNullOrEmpty(value)){
                  return kInputErrorEmptyValue;
                }if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)){
                  return kInputErrorEmailMissmatch;
                }
                return null;
              },
              onSaved: (value){_email = value!;},
            ),
          );
          MarvalDialogsInput(context,
              title: "Recuperar contraseña",
              height: 48,
              form: _form,
              richText: _richText,
              onSucess: (){ ResetPassword(context, _email!); }
          );
        });
  }
}




