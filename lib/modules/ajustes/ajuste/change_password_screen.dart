import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/constants/string.dart';
import 'package:marvalfit/utils/firebase/auth.dart';
import 'package:marvalfit/widgets/marval_snackbar.dart';
import 'package:sizer/sizer.dart';

import '../../../config/log_msg.dart';
import '../../../utils/marval_arq.dart';

import '../../../constants/theme.dart' ;
import '../../../constants/colors.dart';
import '../../../constants/global_variables.dart';

import '../../../widgets/marval_elevated_button.dart';
import '../../../widgets/marval_password_textfield.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);
  static String routeName = "/reset_password";

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

  String _password= "";
  String _newPassword= "";
  Creator<String?> _loginErrors = Creator.value(null);
  void _clear(Ref ref) => ref.update(_loginErrors, (t) => null);
  void _update(Ref ref, String? text) => ref.update(_loginErrors, (t) => text);
  String? _watch(Ref ref) => ref.watch(_loginErrors);

class _LogInForm extends StatelessWidget {
  const _LogInForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    logInfo('Login Page rebuilt');
    return Form(
        key: _formKey,
        child: Column(
          children: [
            /** INPUT TEXT FIELD*/
            PasswordTextField(
              width: 80.w,
              onSaved: (value) => _password = value!,
              labelText: 'Contraseña Actual',
              loginErrors: _loginErrors,
            ),
            SizedBox(height: 5.h,),
            PasswordTextField(
              width: 80.w,
              onSaved: (value) => _newPassword = value!,
              labelText: 'Nueva Contraseña',
            ),
            SizedBox(height: 5.h),
            MarvalElevatedButton(
              "Comenzar",
              onPressed:  () async{
                // Validate returns true if the form is valid, or false otherwise.
                _clear(context.ref);
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  String? checkUser = await  signIn(authUser!.email!, _password);
                  logInfo(checkUser ?? ' Ta nulo');

                  if(isNotNull(authUser) && isNull(checkUser)){
                    await authUser!.updatePassword(_newPassword)
                      .onError((error, stackTrace){
                      MarvalSnackBar(context, SNACKTYPE.alert,
                          title: 'Error al actualizar',
                          subtitle: 'Porfavor espera unos minutos antes de volver a intentarlo');
                      })
                      .then((value) {
                      MarvalSnackBar(context, SNACKTYPE.success,
                          title: 'Contraseña cambiada!',
                          subtitle: 'Evita cambiar mucho la contraseña');
                    });
                    Navigator.pop(context);
                  }
                  if( isNotNull( checkUser)){
                    _update(context.ref, kPassword);
                    _formKey.currentState!.validate();
                  }
                }
              },
            ),
            SizedBox(height: 5.h,),
          ],
        ));
  }
}
