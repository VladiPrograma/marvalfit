import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/firebase/authentication/logic/auth_user_logic.dart';
import 'package:marvalfit/firebase/authentication/model/auth_user_model.dart';
import 'package:marvalfit/firebase/users/model/user.dart';
import 'package:sizer/sizer.dart';

import '../../../config/log_msg.dart';

import '../../../constants/theme.dart' ;
import '../../../constants/colors.dart';
import '../../../constants/global_variables.dart';

import '../../../widgets/marval_drawer.dart';
import '../../../widgets/marval_elevated_button.dart';
import '../../../widgets/marval_password_textfield.dart';



class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);
  static String routeName = "/reset_password";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: kWhite,
      drawer: const MarvalDrawer(name: "Ajustes",),
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
                  Container(width: 86.w,
                      margin: EdgeInsets.only(left: 5.w),
                      child: const TextH1( "Actualiza tu contraseña", size: 6,)),
                  Container(width: 86.w,
                      margin: EdgeInsets.only(left:5.w),
                      child: const TextH2(
                        'El tiempo es la cosa más valiosa que una persona puede gastar',
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

 Creator<String?> _errorCreator = Creator.value(null);
 void _clear(Ref ref) => ref.update(_errorCreator, (t) => null);
 void _update(Ref ref, String? text) => ref.update(_errorCreator, (t) => text);

class _LogInForm extends StatelessWidget {
  const _LogInForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String password= "";
    String newPassword= "";
    logInfo('Login Page rebuilt');
    return Form(
        key: _formKey,
        child: Watcher((context, ref, child) {
          User? user = userLogic.get(ref);
          return Column(
           children: [
             /** INPUT TEXT FIELD*/
             PasswordTextField(
               width: 80.w,
               onSaved: (value) => password = value!,
               labelText: 'Contraseña',
               loginErrors: _errorCreator,
             ),
             SizedBox(height: 2.h,),
             PasswordTextField(
               width: 80.w,
               onSaved: (value) => newPassword = value!,
               labelText: 'Nueva Contraseña',
             ),
             SizedBox(height: 5.h),
             MarvalElevatedButton(
               "Cambiar",
               onPressed:  () async{
                 // Validate returns true if the form is valid, or false otherwise.
                 _clear(ref);
                 if (_formKey.currentState!.validate()) {
                   _formKey.currentState!.save();
                   AuthUser authUser = AuthUser(email: (user?.email ?? ''), password: password);
                   AuthUserLogic authService = AuthUserLogic();
                   String? signResult = await authService.signIn(context, authUser);
                   if( signResult == null){
                     await authService.resetPassword(context, newPassword, true);
                   }else{
                     _update(ref, 'Contraseña incorrecta');
                     _formKey.currentState!.validate();
                   }
                 }
               },
             ),
             SizedBox(height: 5.h,),
           ],
         );
        })
    );
  }
}
