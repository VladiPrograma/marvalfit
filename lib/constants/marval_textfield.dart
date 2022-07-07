import 'package:flutter/material.dart';
import 'package:marvalfit/constants/string.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:sizer/sizer.dart';

import '../utils/decoration.dart';
import '../utils/marval_arq.dart';
import 'colors.dart';

/// Custom TextField
class MarvalInputTextField extends StatefulWidget {
  const MarvalInputTextField({Key? key, this.labelText, this.validator, this.onSaved, this.onChanged, this.hintText, this.keyboardType, this.prefixIcon, this.obscureText}) : super(key: key);
  final String? labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final bool? obscureText;
  final String? Function(String? value)? validator;
  final Function(String? value)? onSaved;
  final Function(String? value)? onChanged;


  @override
  State<MarvalInputTextField> createState() => _MarvalInputTextFieldState();
}
class _MarvalInputTextFieldState extends State<MarvalInputTextField> {

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
                      width: 70.w,
                      child:  TextFormField(
                            cursorColor: kWhite,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: widget.obscureText ?? false,
                            style: TextStyle( fontFamily: p1, color: hasFocus ? kWhite : kBlack, fontSize: 4.w),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: hasFocus ? kGreen: kWhite,
                              label: hasFocus ?
                                Container(
                                margin: EdgeInsets.only(bottom: 2.3.h),
                                child: TextP1(
                                    widget.labelText ?? "",
                                    color: kBlack
                                  )
                                )
                                :
                                TextP1(
                                  widget.labelText ?? "",
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
                              )),
                              hintText: widget.hintText,
                              hintStyle:  TextStyle(fontFamily: p1, color: hasFocus ? kGreenThi : kGrey, fontSize: 4.w),
                              prefixIcon: widget.prefixIcon!=null ? Icon( widget.prefixIcon, color: hasFocus ? kWhite : kGreen,size: 7.w,) : null,
                              errorStyle: TextStyle(fontSize: 3.w, fontFamily: h2, color: kRed, overflow: TextOverflow.visible),

                            ),
                            validator: (value) {
                              if (widget.validator == null) {
                                return null;
                              }
                              return widget.validator!(value);
                            },
                            onSaved:(value){ isNotNull(widget.onSaved) ? widget.onSaved!(value) : null;},
                            onChanged: (value){isNotNull(widget.onChanged) ? widget.onChanged!(value):null;},

                      )),
                ],
              );}));
  }
}

