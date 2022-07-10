import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/constants/marval_elevated_button.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:marvalfit/utils/marval_arq.dart';
import 'package:sizer/sizer.dart';

import '../../config/custom_icons.dart';
import '../../constants/colors.dart';
import '../../constants/marval_snackbar.dart';
import '../../constants/marval_textfield.dart';
import '../../constants/string.dart';

/// @TODO Add "ForgotPassowrd ?" logic and DialogPanel.
class TestComponentScreen extends StatelessWidget {
  const TestComponentScreen({Key? key}) : super(key: key);
  static String routeName = "/testComponents";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: kWhite,
      body: SafeArea(child:
        Container(width: 100.w, height: 100.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MarvalElevatedButton("Snack Info", onPressed: (){
                MarvalSnackBar(
                  context,
                  SNACKTYPE.info,
                  title: "Titulo de ejemplo",
                  subtitle: "Por favor recuerda mirar la información introducida antes de enviar tus datos."

                );}),
              SizedBox(height: 3.h,),
              MarvalElevatedButton("Snack Success", onPressed: (){
                MarvalSnackBar(
                    context,
                    SNACKTYPE.success,
                    title: "Titulo de ejemplo",
                    subtitle: "Por favor recuerda mirar la información introducida antes de enviar tus datos."

                );}),
              SizedBox(height: 3.h,),
              MarvalElevatedButton("Snack Fail", onPressed: (){
                MarvalSnackBar(
                    context,
                    SNACKTYPE.alert,
                    title: "Titulo de ejemplo",
                    subtitle: "Por favor recuerda mirar la información introducida antes de enviar tus datos."

                );}),
              SizedBox(height: 3.h,),
              MarvalElevatedButton("Dialog Info", onPressed: (){
                ///@TODO Create marvalDialog component
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => Dialog(
                      insetPadding: EdgeInsets.symmetric(horizontal: 2.w),
                      backgroundColor: Colors.transparent,
                      child: Container(
                        width: 100.w, height: 50.h,
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.circular(7.w),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CustomIcons.info, color: kBlue, size: 12.w,),
                                TextH2("Dialogo de ejemplo"),
                              ],
                            ),
                            SizedBox(height: 2.h,),
                            const TextP2(
                                "Primero tienes que importar contenido de la app"
                                    " para poder usar este componente. Copia y pega el"
                                    " ejemplo que estas viendo y a continuación ve la"
                                    " tabla del elemento CODE. Los ajustes básicos"
                                    " pueden ser omitidos y debes quedarte en la sección"
                                    " de aplicaciones automáticas"
                            ),
                            Spacer(),
                            Row(children: [
                              MarvalElevatedButton(
                                  "Cancelar",
                                  onPressed: (){},
                                  backgroundColor: MaterialStateColor.resolveWith((states) => kRed)
                              ),
                              Spacer(),
                              MarvalElevatedButton(
                                  "Aceptar",
                                  onPressed: (){},
                                  backgroundColor: MaterialStateColor.resolveWith((states) => kGreen)
                              )
                            ],),
                          ],),
                      )
                  ),
                );}),
            ],
          ),
        )
      ),
    );
  }
}



