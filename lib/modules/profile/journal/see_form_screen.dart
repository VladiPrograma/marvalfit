import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/firebase/form/logic/form_answer_logic.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:creator/creator.dart';

import 'package:marvalfit/constants/theme.dart';
import 'package:marvalfit/constants/colors.dart';
import 'package:marvalfit/widgets/marval_drawer.dart';

//@ERROR When u open the page without form completed it breaks.
class SeeFormScreen extends StatelessWidget {
  const SeeFormScreen({Key? key}) : super(key: key);
  static String routeName = "/profile_form";
  @override
  Widget build(BuildContext context) {
    final userId = uid!;
    return Scaffold(
      drawer: const MarvalDrawer(name: "Usuarios",),
      backgroundColor: kWhite,
      body:  SizedBox( width: 100.w, height: 100.h,
          child: Column(
            children: [
            SizedBox( width: 100.w, height: 12.5.h,
            child: Stack(
                  children: [
                    /// Grass Image
                    Positioned( top: 0,
                        child: SizedBox(width: 100.w, height: 15.h,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.arrow_circle_left_outlined, color: kGreen, size: 6.w),
              ),
              const TextH1('Formulario', size: 5),
              SizedBox(width: 6.w,)
            ]),
            SizedBox(height: 3.w,),
            Container(width: 90.w, height: 0.2.h, color: kBlack,),
            Watcher((context, ref, child){
              FormAnswersLogic formAnswersLogic = FormAnswersLogic();
              List<String> questions = formAnswersLogic.getQuestions(ref, userId);
              List<String> answers = formAnswersLogic.getAnswers(ref, userId);
              return SizedBox(width: 90.w, height: 81.5.h,
              child:  ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: questions.length,
                  separatorBuilder: (context, index) => SizedBox(height: 1.7.h,),
                  itemBuilder: (context, index) =>
                      FormLabel(answer: answers[index], question: questions[index], index: index,)));
            })

      ])),
    );
  }
}

List<String> _sport_icons = ['🏀','🏓','🏑','🏐','🎾','🏈','⚽','🥊','⚾','🥏' ];
class FormLabel extends StatelessWidget {
  const FormLabel({required this.index, required this.answer, required this.question, Key? key}) : super(key: key);
  final String answer;
  final String question;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             TextH2(_sport_icons[index %_sport_icons.length], size: 3.8, ),
             SizedBox(width: 2.w,),
             Expanded(child: TextH2(question.replaceAll('¿', ''), size: 3.3, ))
            ]),
        SizedBox(height: 0.5.h,),
        Row(children: [ SizedBox(width: 8.w,), Expanded(child: TextP2(answer, size: 3.3, maxLines: 100, textAlign: TextAlign.start,))])
      ]);
  }
}
