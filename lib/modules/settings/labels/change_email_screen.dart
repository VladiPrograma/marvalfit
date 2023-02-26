import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/constants/alerts/snack_errors.dart';
import 'package:marvalfit/firebase/authentication/logic/auth_user_logic.dart';
import 'package:marvalfit/firebase/users/model/user.dart';
import 'package:sizer/sizer.dart';

import '../../../config/log_msg.dart';
import '../../../config/custom_icons.dart';
import '../../../utils/marval_arq.dart';

import '../../../constants/theme.dart' ;
import '../../../constants/string.dart';
import '../../../constants/colors.dart';
import '../../../constants/global_variables.dart';

import '../../../widgets/marval_drawer.dart';
import '../../../widgets/marval_elevated_button.dart';
import '../../../widgets/marval_textfield.dart';

class ResetEmailScreen extends StatelessWidget {
  const ResetEmailScreen({Key? key}) : super(key: key);
  static String routeName = "/reset-email";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      drawer: const MarvalDrawer(name: "Ajustes",),
      body: SafeArea(child:
      SizedBox( width: 100.w, height: 100.h,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 6.h,),
                  Image.asset("assets/images/logo.png"),
                  Container(width: 70.w,
                      margin: EdgeInsets.only(right: 10.w),
                      child: const TextH1( "Actualiza tu correo", size: 6,)),
                  Container(width: 70.w,
                      margin: EdgeInsets.only(right:10.w),
                      child: const TextH2(
                          'Evita hacer estos cambios siempre que sea posible',
                          color: kGrey,
                          size: 4,
                      )),
                  SizedBox(height: 5.h,),
                  const _LogInForm(),
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
    String email= "";
    String newEmail= "";
    final _formKey = GlobalKey<FormState>();
    logInfo('Login Page rebuilt');
    return Form(
        key: _formKey,
        child: Watcher((context, ref, child) {
          User? user = userLogic.get(ref);
          return Column(
            children: [
              /** INPUT TEXT FIELD*/
              MarvalInputTextField(
                labelText: 'Email',
                hintText: "marvalfit@gmail.com",
                prefixIcon: CustomIcons.mail,
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  if(isNullOrEmpty(value)){
                    return kEmptyValue;
                  }if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)){
                    return kEmailMissmatch;
                  }if(user!=null && user.email != value) return 'El correo indicado no es el actual';

                  return null;
                },
                onSaved: (value){email = value!;},
              ),
              SizedBox(height: 2.h,),
              MarvalInputTextField(
                labelText: 'Nuevo email',
                hintText: "ejemplo@gmail.com",
                prefixIcon: CustomIcons.mail,
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  if(isNullOrEmpty(value)){
                    return kEmptyValue;
                  }if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)){
                    return kEmailMissmatch;
                  } return null;
                },
                onSaved: (value){newEmail = value!;},
              ),
              SizedBox(height:3.h),
              MarvalElevatedButton(
                "Cambiar",
                onPressed:  () async{
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                      AuthUserLogic authUser = AuthUserLogic();
                      await authUser.resetEmail(context, newEmail, true)
                      .then((value) {  userLogic.updateEmail(context.ref, newEmail); });
                  }
                }
              ),
              SizedBox(height: 5.h,),
            ],
          );
        },)
    );
  }
}




