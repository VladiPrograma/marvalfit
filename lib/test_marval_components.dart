import 'package:flutter/material.dart';
import 'package:marvalfit/constants/marval_dialogs.dart';
import 'package:marvalfit/constants/marval_elevated_button.dart';
import 'package:marvalfit/utils/marval_arq.dart';
import 'package:sizer/sizer.dart';

import '../../constants/colors.dart';
import '../../constants/marval_snackbar.dart';
import '../../constants/string.dart';
import 'config/custom_icons.dart';
import 'constants/marval_textfield.dart';

/// @TODO Add "ForgotPassowrd ?" logic and DialogPanel.
class TestComponentScreen extends StatelessWidget {
  const TestComponentScreen({Key? key}) : super(key: key);
  static String routeName = "/testComponents";

  @override
  Widget build(BuildContext context) {
    String? _email = "";
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
              MarvalElevatedButton(
                  "Dialog Info",
                  onPressed: (){
                  RichText _richText = RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: "La incorporación de hábitos en tu vida promueve la creación de nuevos",
                      style: TextStyle(fontFamily: p2, fontSize: 4.5.w, color: kBlack),
                      children: const <TextSpan>[
                        TextSpan(
                            text:  " circuitos neuronales",
                            style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        TextSpan(
                            text:", con los cuales se conforman patrones nuevos de pensamiento hasta que"
                                " progresivamente se va dejando de actuar de determinada manera o haciendo"
                                " acciones nuevas que se convertirán en rutinas."
                        ),
                      ],
                    ),
                  );
                  MarvalDialogsInfo(context, 42, richText: _richText, title: "Los indiscutibles");
               }),
              SizedBox(height: 3.h,),
              MarvalElevatedButton(
                  "Dialog alert",
                  onPressed: (){
                    RichText _richText = RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        text: "Al pulsar en eliminar estaras eliminando todos tus datos",
                        style: TextStyle(fontFamily: p2, fontSize: 4.5.w, color: kBlack),
                        children: const <TextSpan>[
                          TextSpan(
                              text:  " para siempre",
                              style: TextStyle(fontWeight: FontWeight.bold)
                          ),
                          TextSpan(
                              text:" y será imposible recuperarlos"
                          ),
                        ],
                      ),
                    );
                    MarvalDialogsAlert(
                      context,
                      type: MarvalDialogAlertType.DELETE,
                      title: "¿Deseas eliminar datos?",
                      height: 30,
                      richText: _richText,
                      onAccept: (){
                        print("weeebo");
                      }
                    );
              }),
              SizedBox(height: 3.h,),
              MarvalElevatedButton(
                  "Dialog input",
                  onPressed: (){
                    RichText _richText = RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        text: "Si el correo se encuentra dado de alta se enviará un ",
                        style: TextStyle(fontFamily: p2, fontSize: 4.5.w, color: kBlack),
                        children: const <TextSpan>[
                          TextSpan(
                              text:  " correo de inmediato",
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
                            return inputErrorEmptyValue;
                          }if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)){
                            return inputErrorEmailMissmatch;
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
                        richText: _richText);

                  }),
            ],
          ),
        )
      ),
    );
  }
}



