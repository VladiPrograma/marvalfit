import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/constants/marval_elevated_button.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:marvalfit/test_marval_components.dart';
import 'package:marvalfit/utils/marval_arq.dart';
import 'package:sizer/sizer.dart';

import '../../config/custom_icons.dart';
import '../../constants/colors.dart';
import '../../constants/marval_snackbar.dart';
import '../../constants/marval_textfield.dart';
import '../../constants/string.dart';

/// @TODO Add "ForgotPassowrd ?" logic and DialogPanel.
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
                  LoginForm(),
                ])),
          )
      ),
      );
  }
}



class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}
class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email= "";
  String _password= "";
  String? _loginErrors;
  @override
  Widget build(BuildContext context) {

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
              return inputErrorEmptyValue;
            }if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)){
              return inputErrorEmailMissmatch;
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
               return inputErrorEmptyValue;
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

                    /** PANTALLA TEST */
                    Navigator.pushNamed(context, TestComponentScreen.routeName);
                  }
                  /// @TODO If it works _loginErrors will be null so we can get the user and switch pages
                  MarvalSnackBar(context, SNACKTYPE.success,
                      title: "Perfecto!",
                      subtitle: "Los datos se han subido a la base de datos con exito. Cada dia un paso mas cerca de nuestro objetivo!");
                  ///@TODO Manage to dont start 2 SnackBars when u press the button twice
              }
            },
           ),
          SizedBox(height: 5.h,)
      ],
    ));
  }
}

Future<String?> LogIn(String email, String password)async{
  try {
    final credential = await FirebaseAuth.instance.
    signInWithEmailAndPassword(
        email: email,
        password: password
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') { return inputErrorEmail; }
    else if (e.code == 'wrong-password') { return inputErrorPassword; }
  }
  return null;
}

