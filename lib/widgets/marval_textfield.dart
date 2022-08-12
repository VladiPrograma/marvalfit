import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/colors.dart';
import '../constants/string.dart';
import '../constants/theme.dart';
import '../utils/decoration.dart';
import '../utils/marval_arq.dart';


/// Custom TextField

class MarvalInputTextField extends StatelessWidget {
  const MarvalInputTextField({Key? key,this.controller, this.initialValue, this.readOnly, this.width, this.labelText,this.onTap, this.validator, this.onSaved, this.onChanged, this.hintText, this.keyboardType, this.prefixIcon, this.obscureText, this.suffixIcon}) : super(key: key);
  final double? width;
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final String? Function(String? value)? validator;
  final Function(String? value)? onSaved;
  final Function()? onTap;
  final Function(String? value)? onChanged;
  final TextEditingController? controller;
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return Focus(
        child: Builder(
            builder: (context) {
              final bool hasFocus = Focus.of(context).hasFocus;
              return Column(
                children: [
                  /** Text field */
                  Container(
                      width: width ?? 70.w,
                      child:  TextFormField(
                        initialValue: initialValue,
                        controller: controller,
                        readOnly: readOnly ?? false,
                        cursorColor: kWhite,
                        keyboardType: keyboardType ?? TextInputType.text,
                        obscureText: obscureText ?? false,
                        style: TextStyle( fontFamily: p1, color: hasFocus ? kWhite : kBlack, fontSize: 4.w),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: hasFocus ? kGreen: kWhite,
                            label: hasFocus ?
                            Container(
                                margin: EdgeInsets.only(bottom: 2.3.h),
                                child: TextP1(
                                    labelText ?? "",
                                    color: kBlack
                                )
                            )
                                :
                            TextP1(
                                labelText ?? "",
                                color: kBlack
                            ),
                            border: DecoratedInputBorder(
                              child:  OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(4.w)),
                              ),
                              shadow: BoxShadow(
                                color: kBlack.withOpacity(0.45),
                                offset: Offset(0, 1.3.w),
                                blurRadius: 2.1.w,
                              ),
                            ),
                            hintText: hintText,
                            hintStyle:  TextStyle(fontFamily: p1, color: hasFocus ? kGreenThi : kGrey, fontSize: 4.w),
                            prefixIcon: prefixIcon!=null ? Icon( prefixIcon, color: hasFocus ? kWhite : kGreen,size: 7.w,) : null,
                            suffixIcon: suffixIcon,
                            errorStyle: TextStyle(fontSize: 3.w, fontFamily: h2, color: kRed, overflow: TextOverflow.visible),
                            errorMaxLines: 2

                        ),
                        validator: (value) {
                          if (validator == null) {  return null;  }
                          return validator!(value);
                        },
                        onSaved:(value){ isNotNull(onSaved) ? onSaved!(value) : null;},
                        onChanged: (value){isNotNull(onChanged) ? onChanged!(value):null;},
                        onTap: (){isNotNull(onTap) ? onTap!() : null;},


                      )),
                ],
              );}));
  }
}


