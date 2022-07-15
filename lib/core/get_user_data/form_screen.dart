import 'package:flutter/material.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:sizer/sizer.dart';

import '../../config/custom_icons.dart';
import '../../constants/colors.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);
  static String routeName = "/form";

  @override
  State<FormScreen> createState() => _FormScreenState();
}
///@TODO TextFormField when only one answer.
///@TODO Simplificar formulario (Hablar con Mario)
///@TODO Update Form to Firebase
///@TODO Read Form from Firebase and transform in Page() Style
class _FormScreenState extends State<FormScreen> {
  int pageNumber = 1;

  @override
  Widget build(BuildContext context) {
    Widget page = pageNumber == 1
        ? Page(
      key: Key('page1'),
      onOptionSelected: () => setState(() => pageNumber = 2),
      question:
      'Do you typically fly for business, personal reasons, or some other reason?',
      answers: <String>['Business', 'Personal', 'Others', 'Jabali', 'Rinoceronte'],
      number: 1,
    )
        : Page(
      key: Key('page2'),
      onOptionSelected: () => setState(() => pageNumber = 1),
      question: 'How many hours is your average flight?',
      answers: <String>[
        'Less than two hours',
        'More than two but less than five hours',
        'Others'
      ],
      number: 2,
    );
    return Scaffold(
      body: Container(width: 100.w, height: 100.h,
      decoration: const BoxDecoration(
        gradient: kFormGradient
      ),
      child: SafeArea(
        child: Stack(
          children: [
            ArrowIcons(),
            Bicyclet(),
            Line(),
            Positioned.fill(
              left: 10.w,
              child: AnimatedSwitcher(
                child: page,
                duration: Duration(milliseconds: 250),
              ),
            ),
          ]),
      )),
    );
  }
}






class Page extends StatefulWidget {
  final int number;
  final String question;
  final List<String> answers;
  final VoidCallback onOptionSelected;

  const Page(
      {Key? key,
        required this.onOptionSelected,
        required this.number,
        required this.question,
        required this.answers})
      : super(key: key);

  @override
  _PageState createState() => _PageState();
}
class _PageState extends State<Page> with SingleTickerProviderStateMixin {
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
          child: StepQuestion(question: widget.question),
        ),
        Spacer(),
        ...widget.answers.map((String answer) {
          int answerIndex = widget.answers.indexOf(answer);
          int keyIndex = answerIndex + 2;
          return ItemFader(
            key: keys[keyIndex],
            child: OptionItem(
              name: answer,
              onTap: (offset) {
                onTap(keyIndex, offset);
                logInfo('You select: "$answer"' );
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
        animateDot(offset).then((_) => widget.onOptionSelected());

      }
    }
  }
  void onInit() async {
    for (GlobalKey<_ItemFaderState> key in keys) {
      await Future.delayed(Duration(milliseconds: 40));
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



class ArrowIcons extends StatelessWidget {
  const ArrowIcons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 2.5.w,
        bottom: 2.h,
        child: Column(
          children: [
            Icon(Icons.arrow_upward_rounded, color: kWhite, size: 8.w,),
            SizedBox(height: 2.h,),
            Icon(Icons.arrow_downward_rounded, color: kWhite, size: 8.w,),
          ],
        )
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