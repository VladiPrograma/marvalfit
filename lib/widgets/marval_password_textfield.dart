import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../config/custom_icons.dart';
import '../constants/colors.dart';
import '../constants/string.dart';
import '../utils/marval_arq.dart';
import 'marval_textfield.dart';

bool _hidePassword = true;

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({this.labelText, this.width, this.onSaved, this.loginErrors,  Key? key}) : super(key: key);
  final double? width;
  final String? labelText;
  final Function(String? value)? onSaved;
  final Creator<String?>? loginErrors;
  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}
class _PasswordTextFieldState extends State<PasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return Focus(
        child: Builder(
            builder: (context) {
              final bool hasFocus = Focus.of(context).hasFocus;
              return MarvalInputTextField(
                width: widget.width,
                labelText: widget.labelText ?? 'Contraseña',
                hintText:  '********',
                prefixIcon: CustomIcons.lock,
                suffixIcon: GestureDetector(
                    onLongPress: () => setState(() => _hidePassword = false),
                    onLongPressEnd: (details) => setState(() => _hidePassword = true),
                    child:  Icon(
                      Icons.remove_red_eye,
                      size: 7.w,
                      color: hasFocus ?  kWhite : kGreen,
                    )),
                keyboardType: TextInputType.visiblePassword,
                obscureText: _hidePassword,
                onSaved:(value){ isNotNull(widget.onSaved) ? widget.onSaved!(value) : null;},
                validator: (value){
                  if(isNullOrEmpty(value)){ return kEmptyValue; }
                  if(value!.length<8)     { return 'Debe tener al menos 8 caracteres'; }
                  if(isNotNull(widget.loginErrors)){
                    return context.ref.watch(widget.loginErrors!);
                  }
                  return null;
                },
              );
            }));
  }
}
