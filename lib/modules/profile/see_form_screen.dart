import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/colors.dart';
import 'package:marvalfit/constants/components.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:marvalfit/modules/profile/gallery.dart';
import 'package:marvalfit/utils/extensions.dart';
import 'package:marvalfit/utils/objects/form.dart';
import 'package:sizer/sizer.dart';

import '../../constants/global_variables.dart';
import '../../constants/icons.dart';
import '../../constants/string.dart';
import '../../utils/decoration.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/user.dart';
import '../../utils/objects/user_daily.dart';
import '../../widgets/marval_dialogs.dart';
import '../../widgets/marval_drawer.dart';
import 'diary.dart';
import 'logic.dart';
import 'measures.dart';

final Emitter<Map<String, dynamic>?> formEmitter = Emitter((ref, emit) async{
  DocumentSnapshot doc = await FirebaseFirestore.instance.collection('forms/').doc(authUser.uid).get();
  emit(toMap(doc));
});



class SeeFormScreen extends StatelessWidget {
  const SeeFormScreen({Key? key}) : super(key: key);
  static String routeName = "/profile_form";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MarvalDrawer(name: "Perfil",),
      backgroundColor: kWhite,
      body:  SizedBox( width: 100.w, height: 100.h,
          child: Column(
            children: [
            SizedBox( width: 100.w, height: 13.h,
            child: Stack(
                  children: [
                    /// Grass Image
                    Positioned( top: 0,
                        child: SizedBox(width: 100.w, height: 12.h,
                            child: Image.asset('assets/images/grass.png',
                                fit: BoxFit.cover
                        ))),
                    ///White Container
                    Positioned( top: 8.h,
                        child: Container(width: 100.w, height: 10.h,
                            decoration: BoxDecoration(
                                color: kWhite,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.w),
                                    topRight: Radius.circular(10.w)
                           ))
                        )),
              ])),
            const TextH1('Formulario', size: 6),
            Container(width: 90.w, height: 0.3.h, color: kBlack,),
            Watcher((context, ref, child){
              final map = ref.watch(formEmitter.asyncData).data;
              if(isNull(map)) return SizedBox();
              List<String> questions = map!.keys.toList();
              List<dynamic> answer = map.values.toList();
              return SizedBox(width: 90.w, height: 81.5.h,
              child:  ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemCount: questions.length,
                  separatorBuilder: (context, index) => SizedBox(height: 2.h,),
                  itemBuilder: (context, index) =>
                      FormLabel(answer: answer[index], question: questions[index])));
            })

      ])),
    );
  }
}

class FormLabel extends StatelessWidget {
  const FormLabel({required this.answer, required this.question, Key? key}) : super(key: key);
  final String answer;
  final String question;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 1.h),
                child: Icon(Icons.circle, color: kGreen, size: 2.w,),
              ),
              Expanded(child: TextH2(question, size: 4,))
            ]),
        SizedBox(height: 0.5.h,),
        Row(children: [ SizedBox(width: 5.w,), Expanded(child: TextP2(answer, size: 4,))])
      ]);
  }
}
