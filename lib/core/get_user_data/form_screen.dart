import 'package:flutter/material.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/string.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:marvalfit/modules/home_screen.dart';
import 'package:marvalfit/utils/marval_arq.dart';
import 'package:sizer/sizer.dart';

import '../../config/custom_icons.dart';
import '../../constants/colors.dart';
import '../../utils/objects/form.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);
  static String routeName = "/form";

  @override
  State<FormScreen> createState() => _FormScreenState();
}
///@TODO Simplificar formulario (Hablar con Mario)
///@TODO Añadir campo de Sexo / DNI? / Ciudad


var completedForm = Map<String,String>();
late String lastQuestion;
int pointer = 0;
List<String> specify = [""];
class _FormScreenState extends State<FormScreen> {
  List<Widget> pages = List.empty(growable: true);
  int pageNumber = 1;
  void initState(){
    super.initState();
    // Create anonymous function:
        () async {
      /** Using async methods to fetch Data */
          List<FormItem> formItems = await FormItem.getFromDB();
          for (var element in formItems) {
            pages.add(
                FormPage(
                    key: Key(element.key),
                    onOptionSelected: (){ setState(() {
                      pageNumber = pageNumber+1;
                    });},
                    number: element.number,
                    question: element.question,
                    answers: element.answers
                )
            );
          }
          pages = pages.reversed.toList();
          lastQuestion = formItems.first.question;
          setState(() { });
    }();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(width: 100.w, height: 100.h,
          decoration: const BoxDecoration(
          gradient: kFormGradient
        ),
        child: SafeArea(
          child: SingleChildScrollView(
          child: Container(width: 100.w, height: 100.h,
          child: Stack(
          children: [
            Positioned(
                left: 2.5.w,
                bottom: 5.h,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){setState(() { if(pageNumber<pages.length&&pageNumber<completedForm.length+1){  pageNumber++; pointer++;  }});},
                      child:Icon(Icons.arrow_upward_rounded, color: kWhite, size: 8.w,),
                    ),
                    SizedBox(height: 2.h,),
              GestureDetector(
                onTap: (){setState(() { if(pageNumber>1){ pageNumber--; pointer--;} });},
                child: Icon(Icons.arrow_downward_rounded, color: kWhite, size: 8.w,)),
             ])), // Arrows
            const Bicyclet(),
            const Line(),
            Positioned.fill(
              left: 10.w,
              child: AnimatedSwitcher(
                child: pages.isNotEmpty&&pageNumber!=pages.length+1 ? pages[pageNumber-1] : const Text(""),
                duration: const Duration(milliseconds: 250),
              ),
            ),
          ]))),
      )),
    );
  }
}






class FormPage extends StatefulWidget {
  final int number;
  final String question;
  final List<String> answers;
  final VoidCallback onOptionSelected;

  const FormPage(
      {Key? key,
        required this.onOptionSelected,
        required this.number,
        required this.question,
        required this.answers})
      : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}
class _FormPageState extends State<FormPage> with SingleTickerProviderStateMixin {
  late List<GlobalKey<_ItemFaderState>> keys;
  late AnimationController _animationController;
  int? selectedOptionKeyIndex;

  @override
  void initState() {
    super.initState();
    keys = List.generate(
      2 + widget.answers.length,
          (_) => GlobalKey<_ItemFaderState>(),
    );
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    onInit();
  }
  Future<void> animateDot(Offset startOffset) async {
    OverlayEntry entry = OverlayEntry(
      builder: (context) {
        double minTop = 10.h;
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Positioned(
              left: 12.5.w,
              top: minTop +
                  (startOffset.dy - minTop) * (1 - _animationController.value),
              child: child!,
            );
          },
          child: Dot(),
        );
      },
    );
    Overlay.of(context)!.insert(entry);
    await _animationController.forward(from: 0);
    entry.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 8.w),
        ItemFader(key: keys[0], child: StepNumber(number: widget.number)),
        ItemFader(
          key: keys[1],
          child:  StepQuestion(question: widget.question),
        ),
        Spacer(),
        ...widget.answers.map((String answer) {
          int answerIndex = widget.answers.indexOf(answer);
          int keyIndex = answerIndex + 2;
          return ItemFader(
            key: keys[keyIndex],
            child: answer.contains('Especifica')  ?
            OptionItemField(
              name: answer,
              onTap: (offset) async{
                onTap(keyIndex, offset);
              },
              showDot: selectedOptionKeyIndex != keyIndex,
            )
             :
            OptionItem(
              name: answer,
              onTap: (offset) async{

                if(answer==widget.answers.first&&widget.answers.last.contains('Especifica')){
                  answer+= '. ${specify[pointer]}';
                }
                completedForm[widget.question] = normalize(answer)!;
                if(widget.question == lastQuestion){
                  await FormItem.setUserResponse(completedForm);
                  logInfo(completedForm.toString());
                  logInfo(specify.toString());
                  Navigator.pushNamed(context, HomeScreen.routeName);
                }else{
                onTap(keyIndex, offset);
                pointer++;
                }
              },
              showDot: selectedOptionKeyIndex != keyIndex,
            ),
          );
        }),
        SizedBox(height:16.w),
      ],
    );
  }
  void onTap(int keyIndex, Offset offset) async {
    for (GlobalKey<_ItemFaderState> key in keys) {
      await Future.delayed(const Duration(milliseconds: 40));
      key.currentState!.hide();
      if (keys.indexOf(key) == keyIndex) {
        setState(() => selectedOptionKeyIndex = keyIndex);
        animateDot(offset).then((_){
          setState(() => widget.onOptionSelected());
        });

      }
    }
  }
  void onInit() async {
    for (GlobalKey<_ItemFaderState> key in keys) {
      await Future.delayed(const Duration(milliseconds: 40));
      key.currentState!.show();
    }
  }
}


class StepNumber extends StatelessWidget {
  final int number;

  const StepNumber({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left: 16.w, right: 4.w),
      child: TextH1(number<10 ? '0$number' : '$number', color: kWhite, size: 13,),
    );
  }
}
class StepQuestion extends StatelessWidget {
  final String question;

  const StepQuestion({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left: 16.w, right: 4.w),
      child: TextH2(question, color: kWhite, size: 5,)
    );
  }
}


class ItemFader extends StatefulWidget {
  final Widget child;

  const ItemFader({Key? key, required this.child}) : super(key: key);

  @override
  _ItemFaderState createState() => _ItemFaderState();
}
class _ItemFaderState extends State<ItemFader>
    with SingleTickerProviderStateMixin {
  //1 means its below, -1 means its above
  int position = 1;
  late AnimationController _animationController;
  late Animation _animation;

  void show() {
    setState(() => position = 1);
    _animationController.forward();
  }

  void hide() {
    setState(() => position = -1);
    _animationController.reverse();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 6.w * position.toDouble() * (1 - _animation.value)),
          child: Opacity(
            opacity: _animation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}


class OptionItem extends StatefulWidget {
  final String name;
  final void Function(Offset dotOffset) onTap;
  final bool showDot;

  const OptionItem(
      {Key? key, required this.name, required this.onTap, this.showDot = true})
      : super(key: key);

  @override
  _OptionItemState createState() => _OptionItemState();
}
class _OptionItemState extends State<OptionItem> {
  @override
  Widget build(BuildContext context) {
    if(specify.length==pointer){
      specify.add("");
    }
    return InkWell(
      onTap: () {
        RenderBox? object = context.findRenderObject() as RenderBox;
        Offset globalPosition = object.localToGlobal(Offset.zero);
        widget.onTap(globalPosition);
      },
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: 4.w),
        child: Row(
          children: <Widget>[
            SizedBox(width: 2.5.w),
            Dot(visible: widget.showDot),
            SizedBox(width: 6.w),
            Expanded(
              child: TextH2( widget.name, color: kWhite, size: 5,),
            )
          ],
        ),
      ),
    );
  }
}



class OptionItemField extends StatefulWidget {
  final String name;
  final void Function(Offset dotOffset) onTap;
  final bool showDot;

  const OptionItemField(
      {Key? key, required this.name, required this.onTap, this.showDot = true})
      : super(key: key);
  @override
  State<OptionItemField> createState() => _OptionItemFieldState();
}
class _OptionItemFieldState extends State<OptionItemField> {
  @override
  Widget build(BuildContext context) {
    if(specify.length==pointer){
      specify.add("");
    }
    return  Padding(
        padding:  EdgeInsets.symmetric(vertical: 4.w),
        child: Row(
          children: <Widget>[
            SizedBox(width: 2.5.w),
            Dot(visible: widget.showDot),
            SizedBox(width: 6.w),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.name,
                  hintStyle: TextStyle(fontFamily: h2, color: kGrey, fontSize: 5.w),
                  hintMaxLines: 2,
                ),
                onChanged: (value){
                  logInfo(pointer.toString()+" "+specify.length.toString());
                   specify[pointer] = value;
                  },
                style: TextStyle(fontFamily: h2, color: kWhite, fontSize: 5.w),
                maxLines: 2,
              ),
            )
          ],
        ),
    );
  }
}


class Bicyclet extends StatelessWidget {
  const Bicyclet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 5.w,
        top: 5.5.h,
        child:  Icon(
            CustomIcons.bicycle,
            size: 15.w,
            color: kWhite,
          ),
    );
  }
}
class Dot extends StatelessWidget {
  final bool visible;

  const Dot({Key? key, this.visible = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3.w,
      height: 3.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: visible ? Colors.white : Colors.transparent,
      ),
    );
  }
}
class Line extends StatelessWidget {
  const Line({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 8.w + 6.w,
        top:  10.h,
        bottom: 0,
        width: 1,
        child: Container(
          color: kWhite.withOpacity(0.5),
        )
    );
  }
}