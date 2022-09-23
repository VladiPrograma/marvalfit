import 'package:flutter/material.dart';
import 'package:marvalfit/widgets/marval_snackbar.dart';
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
  static String routeName = "/reset_email";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: kWhite,
      drawer: const MarvalDrawer(page: "Ajustes",),
      body: SafeArea(child:
      Container( width: 100.w, height: 100.h,
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

String _email= "";
String _newEmail= "";

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
            MarvalInputTextField(
              labelText: 'Email Actual',
              hintText: "marvalfit@gmail.com",
              prefixIcon: CustomIcons.mail,
              keyboardType: TextInputType.emailAddress,
              validator: (value){
                if(isNullOrEmpty(value)){
                  return kEmptyValue;
                }if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)){
                  return kEmailMissmatch;
                }if(authUser.email!=value) return 'El correo indicado no es el actual';
                return null;
              },
              onSaved: (value){_email = value!;},
            ),
            SizedBox(height: 5.h,),
            MarvalInputTextField(
              labelText: 'Email Nuevo',
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
              onSaved: (value){_newEmail = value!;},
            ),
            SizedBox(height: 5.h),
            MarvalElevatedButton(
              "Comenzar",
              onPressed:  () async{
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if(isNotNull(authUser)){

                    await authUser.updateEmail(_newEmail)
                        .onError((error, stackTrace){
                          MarvalSnackBar(context, SNACKTYPE.alert,
                          title: 'Error al actualizar',
                          subtitle: 'Porfavor espera unos minutos antes de volver a intentarlo');
                        })
                        .then((value) {
                          MarvalSnackBar(context, SNACKTYPE.success,
                        title: 'Correo cambiado!',
                        subtitle: 'Ahora tu nuevo correo es $_newEmail');
                          user.updateEmail(email: _newEmail);
                        });
                  }
                  Navigator.pop(context);
                }
              },
            ),
            SizedBox(height: 5.h,),
          ],
        ));
  }
}




