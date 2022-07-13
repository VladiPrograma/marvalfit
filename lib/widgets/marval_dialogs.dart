import 'package:flutter/material.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:sizer/sizer.dart';

import '../config/custom_icons.dart';
import '../utils/marval_arq.dart';
import '../constants/colors.dart';

void MarvalDialogsInfo(BuildContext context, double height, {RichText? richText, String? title}){
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 2.w),
        backgroundColor: Colors.transparent,
        child:  Container(
          width: 100.w, height: height.h,
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(7.w),
          ),
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CustomIcons.info, color: kBlue, size: 10.w,),
                  Spacer(),
                  TextH2(title ?? "", color: kBlue,),
                  Spacer(),
                ],
              ),
              SizedBox(height: 2.h,),
              richText ?? SizedBox(),
              Spacer(),
              Row(
                children: [
                  Spacer(),
                  TextButton(onPressed: (){Navigator.pop(context);}, child: TextH2("Entendido", size: 4, color: kBlue,))
                ],
              ),
            ],
          ),
        ),
    ),
  );
}

enum MarvalDialogAlertType {
  DELETE,
  ACCEPT,
  ACTIVATE
}
void MarvalDialogsAlert(BuildContext context, {required MarvalDialogAlertType type, String? title, required double height, RichText? richText, Function()? onAccept}){
  late IconData _icon;
  late String _textButton;
  late Color _textColor;
  late Color _buttonColor;
  if(type == MarvalDialogAlertType.ACCEPT){
    _icon = CustomIcons.info;
    _textButton = "Aceptar";
    _textColor = kBlue;
    _buttonColor = kBlueThi;
  }else if(type == MarvalDialogAlertType.DELETE){
    _icon = CustomIcons.alert;
    _textButton = "Eliminar";
    _textColor = kRed;
    _buttonColor = kRedThi;
  }else{
    _icon = CustomIcons.info;
    _textButton = "Activar";
    _textColor = kGreen;
    _buttonColor = kGreenThi;
  }
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 2.w),
      backgroundColor: Colors.transparent,
      child:  Container(
        width: 100.w, height: height.h,
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(7.w),
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_icon, color: _textColor, size: 10.w,),
                Spacer(),
                TextH2(title ?? "", color: _textColor,),
                Spacer(),
              ],
            ),
            SizedBox(height: 2.h,),
            richText ?? SizedBox(),
            Spacer(),
            Row(
              children: [
                TextButton(onPressed: (){Navigator.pop(context);}, child: TextH2("Cancelar", size: 4, color: _textColor,)),
                Spacer(),
                TextButton(
                    onPressed: (){
                      if(isNotNull(onAccept)){  onAccept!();  }
                      Navigator.pop(context);
                      },
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.3.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.w)),
                          color: _buttonColor,
                        ),
                        child:  TextH2(_textButton, size: 4, color: _textColor,)),
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void MarvalDialogsInput(BuildContext context, { required String title, required double height, required Form form, required RichText richText, Function()? onSucess}){
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 2.w),
      backgroundColor: Colors.transparent,
      child:  Container(
        width: 100.w, height: height.h,
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(7.w),
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CustomIcons.info, color: kGreen, size: 10.w,),
                Spacer(),
                TextH2(title , color: kBlack,),
                Spacer(),
              ],
            ),
            SizedBox(height: 2.h,),
            richText,
            Spacer(),
            form,
            Spacer(),
            Row(
              children: [
                TextButton(onPressed: (){Navigator.pop(context);}, child: TextH2("Cancelar", size: 4, color: kGreySec,)),
                Spacer(),
                TextButton(
                    onPressed: (){
                      GlobalKey<FormState> _formKey = form.key as GlobalKey<FormState>;
                      if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          if(isNotNull(onSucess)){ onSucess!(); }
                          Navigator.pop(context);
                      }},
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.3.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.w)),
                          color: kGreenThi,

                        ),
                        child:  TextH2("Enviar", size: 4, color: kGreen,)))
              ],
            ),
          ],
        ),
      ),
    ),
  );
}