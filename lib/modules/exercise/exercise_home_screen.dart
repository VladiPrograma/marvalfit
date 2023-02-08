import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/config/screen_args_data.dart';
import 'package:marvalfit/firebase/exercises/model/exercise.dart';
import 'package:marvalfit/modules/exercise/exercise_screen.dart';
import 'package:marvalfit/utils/decoration.dart';
import 'package:marvalfit/widgets/cached_image.dart';
import 'package:marvalfit/widgets/load_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../utils/extensions.dart';

import '../../constants/colors.dart';
import '../../constants/global_variables.dart';
import '../../constants/string.dart';
import '../../constants/theme.dart';

import '../../widgets/marval_drawer.dart';


/// @TODO Configure in Firebase The Reset Password Email
/// @TODO Add common Profile Photo to Storage and let URL on User.create
/// @TODO Change the Details hobbie to User Hobbie

ScrollController returnController(Ref ref, int size){
  ScrollController  res = ScrollController();
  res.addListener((){ if(res.position.maxScrollExtent==res.offset){ exerciseLogic.fetchMore(ref, size);}});
  return res;
}
Creator<String> _searchCreator = Creator.value('');
Creator<bool> _searchByTags = Creator.value(false);

class ExerciseHomeScreen extends StatelessWidget {
  const ExerciseHomeScreen({Key? key}) : super(key: key);
  static String routeName = "/exercise-home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        resizeToAvoidBottomInset: false,
        drawer: const MarvalDrawer(name: 'Ejercicios'),
        body:   SizedBox( width: 100.w, height: 100.h,
          child: Stack(
              children: [
                /// Grass Image
                Positioned(
                    top: 0,
                    child: SizedBox(width: 100.w, height: 30.h,
                      child: Image.asset('assets/images/grass.png', fit: BoxFit.cover,),
                    )
                ),
                /// Home Text H1
                Positioned(
                    top: 0,
                    child: SizedBox(width: 100.w, height: 20.h,
                        child: Center(child: TextH1('Exercise', size: 13,
                          color: Colors.black.withOpacity(0.7),
                          shadows: [
                            BoxShadow(color: kWhite.withOpacity(0.4), offset: const Offset(0, 2), blurRadius: 15)
                          ],))
                    )
                ),
                /// List Tiles
                Positioned( bottom: 0,
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight:     Radius.circular(10.w),
                          topLeft:      Radius.circular(10.w)
                      ),
                      child: Container( width: 100.w, height: 80.5.h,
                          color: kWhite,
                          child: const _UsersList()
                      )),
                ),
                ///TextField
                Positioned( top: 16.5.h,  left: 12.5.w,
                    child: SizedBox(width: 75.w, height: 10.h,
                        child: TextField(
                            style: TextStyle(
                                fontFamily: p1,
                                color: kBlack,
                                fontSize: 4.w
                            ),
                            cursorColor: kGreen,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: kWhite,
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
                                hintText: 'Buscar',
                                hintStyle:  TextStyle(fontFamily: p1, color: kGrey, fontSize: 4.w),
                                prefixIcon: Watcher((context, ref, child) {
                                  bool isActive = ref.watch(_searchByTags);
                                  return GestureDetector(
                                    onTap: () => ref.update<bool>(_searchByTags, (value) => !value),
                                    child: Icon(Icons.tag_rounded, color: isActive ? kGreen : kGrey, size: 6.w,),
                                  );
                                }),
                                contentPadding: EdgeInsets.zero
                            ),
                            onChanged: (value) {
                              context.ref.update(_searchCreator, (name) => value);
                              if(value.length == 3){
                                exerciseLogic.fetchReset(context.ref);
                              }
                            })
                    ))
              ]),
        ));
  }
}

class _UsersList extends StatelessWidget {
  const _UsersList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child){
      bool searchByTags = ref.watch(_searchByTags);
      String search = ref.watch(_searchCreator);
      List<Exercise> exercises = [];

      if(searchByTags && search.isNotEmpty){
          List<String> tags = search.trim().split(',');
          tags = tags.where((element) => element.isNotEmpty).map((e) => e.trim().capitalize()).toList();
          exercises = exerciseLogic.getByAllTags(ref, tags);
      }else{
       exercises = exerciseLogic.getByName(ref, search);
       if(search.length>3){
         exercises = exercises.where((exercise) => exercise.name.toLowerCase().contains(search.toLowerCase())).toList();
       }
      }
      final bool hasMoreData = exerciseLogic.hasMore(ref);
      logInfo('HasMoreData: $hasMoreData');
      if(exercises.isEmpty) { return const SizedBox.shrink(); }
      return ListView.builder(
          controller: returnController(ref, exercises.length),
          itemCount: exercises.length+1,
          itemBuilder: (context, index) {
            if(index == exercises.length ){ return hasMoreData ? const  LoadIndicator() : SizedBox(height: 2.h,); }
            return ExerciseTile(exercise: exercises[index]);
          });
    });
  }
}
class ExerciseTile extends StatelessWidget {
  const ExerciseTile({required this.exercise, Key? key}) : super(key: key);
  final Exercise exercise;
  @override
  Widget build(BuildContext context) {
    void openExercisePage(BuildContext context, Exercise exercise){
      Navigator.pushNamed(context, ExerciseScreen.routeName, arguments: ScreenArguments(exercise: exercise));
    }

    return GestureDetector(
        onTap: () => openExercisePage(context, exercise),
        child: Container(width: 100.w, height: 12.h,
            padding: EdgeInsets.symmetric(horizontal: 2.5.w),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PROFILE IMAGE
                  CachedImage(
                        url: exercise.imageUrl,
                        size: 10,
                   ),
                  SizedBox(width: 6.w,),
                  /// USER DATA
                  SizedBox( width: 66.w, height: 12.h,
                      child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextH2(exercise.name.maxLength(25), size: 3.6, ),
                            SizedBox(height: 0.4.h,),
                            Row( children: [
                              Expanded(
                                  child: TextP2(exercise.tags.toString().replaceAll('[', '').replaceAll(']', ''),
                                    size: 3,
                                    maxLines: 3,
                                    color: kBlack,
                                    textAlign: TextAlign.start,
                                  )
                              )
                            ])
                          ]))
                ])));
  }
}

