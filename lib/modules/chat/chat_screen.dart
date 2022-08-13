import 'package:flutter/material.dart';
import 'package:creator/creator.dart' ;
import 'package:sizer/sizer.dart';


import '../../constants/theme.dart' ;
import '../../constants/colors.dart';
import '../../constants/string.dart';
import '../../constants/components.dart';
import '../../constants/global_variables.dart';

import '../../utils/decoration.dart';
import '../../utils/extensions.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/user.dart';
import '../../utils/objects/message.dart';

import '../../config/custom_icons.dart';
import '../../widgets/marval_drawer.dart';

import 'chat_logic.dart';



final TextEditingController _controller = TextEditingController();

ScrollController returnController(Ref ref){
  ScrollController  res = ScrollController();
  res.addListener((){ if(res.position.maxScrollExtent==res.offset){ fetchMoreMessages(ref); }});
  return res;
}


///@TODO Remove TEXTH1 "Waiting Conexion"
class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static String routeName = '/chat';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        drawer: const MarvalDrawer(name: 'Chat',),
        body:  SizedBox( width: 100.w, height: 100.h,
            child: Stack(
                    children: [
                      /// Grass Image
                      Positioned( top: 0,
                          child: SizedBox(width: 100.w, height: 12.h,
                              child: Image.asset('assets/images/grass.png', fit: BoxFit.cover))
                      ),
                      ///White Container
                      Positioned( top: 8.h,
                          child: Container(width: 100.w, height: 10.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.w), topRight: Radius.circular(10.w)),
                                  color: kWhite
                              ))),
                      /// Marval Trainer Data
                      Positioned(  top: 1.h, left: 8.w,
                        child: SafeArea(child: Watcher((context, ref, _) {
                          final query = ref.watch(trainerCreator.asyncData).data;
                          if(isNull(query)||query!.size==0){
                            return BoxUserData(user: MarvalUser.empty());
                          }
                          final map = query.docs.first.data();
                          final MarvalUser user = MarvalUser.fromJson(map);
                          return BoxUserData(user: user);
                        }),
                      )),
                      /// Chat Container
                      Positioned( top: 18.h,
                        child:  InnerShadow(
                            color: Colors.black,
                            blur: 10,
                            offset: Offset(0,2.w),
                            child: Container(width: 100.w, height: 82.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15.w), topRight: Radius.circular(15.w)),
                                  color: kBlack.withOpacity(0.85)
                        ))),
                      ),
                      ///* Chat Messages
                      Positioned( top: 18.h,
                        child:  Container(width: 100.w, height: 72.h,
                        padding: EdgeInsets.only( bottom: MediaQuery.of(context).viewInsets.bottom),
                         child: ClipRRect(
                         borderRadius: BorderRadius.vertical(top: Radius.circular(15.w)),
                         child: Watcher((context, ref, child) {
                          final data = getLoadMessages(ref);
                          if(isNull(data)||data!.isEmpty){  return const SizedBox();}
                          readMessages(data);

                          DateTime firstDate = data.first.date;

                          return ListView.separated(
                            reverse: true,
                            controller: returnController(ref),
                            itemCount: data.length,
                            separatorBuilder: (context, index) {
                              if(isNotNull(data[index+1])&& firstDate.day != data[index+1].date.day){
                                firstDate = data[index+1].date;
                                return Container(
                                  padding: EdgeInsets.only(bottom: 1.h),
                                  child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(width: 30.w, height: 0.5.w, color: kGrey, ),
                                    TextP2(' ${firstDate.toFormatStringDate()} ', color: kGrey,),
                                    Container(width: 30.w, height: 0.5.w, color: kGrey, )
                                  ],
                                ));
                              }
                              return SizedBox();
                            },
                            itemBuilder: (context, index){
                              Message message = data[index];
                              return MessageBox(message: message);
                            });
                       })))),
                      /// TextField
                      Positioned(bottom: 3.w, left: 5.w,
                      child: SizedBox( width: 90.w,
                        child: TextField(
                          cursorColor: kGreen,
                          controller: _controller,
                          style: TextStyle(fontSize: 4.w, fontFamily: p2, color: kBlack),
                          decoration: InputDecoration(
                              fillColor: kWhite,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(4.w)),
                              ),
                              hintText: 'Escribe algo',
                              hintStyle: TextStyle(fontSize: 4.w, fontFamily: p2, color: kGrey),
                              prefixIcon: Icon(CustomIcons.camera, color: kBlack, size: 6.w,),
                              suffixIcon: GestureDetector(
                                onTap:(){
                                    if(isNotEmpty(_controller.text)){
                                      Message newMessage = Message.create(
                                        message:_controller.text,
                                        type: MessageType.text
                                      );
                                      newMessage.setInDB();
                                    }
                                  _controller.text="";
                                },
                                child: Icon(Icons.send_rounded, color: kBlack, size: 7.w,),
                              )),
                        ),
                      ),)
                    ])),
    );
  }
}

class BoxUserData extends StatelessWidget {
  const BoxUserData({required this.user, Key? key}) : super(key: key);
  final MarvalUser user;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
         decoration: BoxDecoration(
           boxShadow: [kMarvalHardShadow],
           borderRadius: BorderRadius.all(Radius.circular(100.w)),
         ),
         child: CircleAvatar(
             backgroundColor: kBlack,
             radius: 6.h,
             backgroundImage:  isNullOrEmpty(user.profileImage) ?
               null
                 :
               Image.network(user.profileImage!, fit: BoxFit.fitHeight).image
         )),
        SizedBox(width: 2.w),
        Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 3.h,),
          TextH2('${user.name} ${user.lastName}', size: 4),
          TextH2(user.work, size: 3, color: kGrey,),
        ])
      ]);
  }
}
const List<int> _sizes = [0, 4, 8, 12, 16, 20];
const List<int> _margins = [77,65,53,41,29,15];

int _getMarginSize(Message message){
  int labelSize = 0;
  _sizes.where((size) => message.message.length>=size).forEach((element)=> labelSize++);
  return _margins[labelSize-1];
}
class MessageBox extends StatelessWidget {
  const MessageBox({required this.message, Key? key}) : super(key: key);
  final Message message;
  @override
  Widget build(BuildContext context) {
    final bool fromUser = message.user != authUser.uid;
    return Column(
      crossAxisAlignment: fromUser ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children:[ Container(
      padding: EdgeInsets.all(3.w),
      margin: EdgeInsets.only(
          right: fromUser ? _getMarginSize(message).w : 4.w,
          left : fromUser ? 4.w : _getMarginSize(message).w
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight:  fromUser ? Radius.circular(2.w) : Radius.zero,
          topLeft : !fromUser ? Radius.circular(2.w) : Radius.zero,
          bottomLeft: Radius.circular(2.w),
          bottomRight: Radius.circular(2.w),
        ),
        color: fromUser ? kBlack : kBlue,
      ),
      child: TextH2(message.message, color: kWhite, size: 4,textAlign: TextAlign.start),
    ),
    Padding(padding: EdgeInsets.only(left: 4.w, right: 4  .w, bottom: 1.h,),
        child: TextP2(message.date.toFormatStringHour(), color: kGrey,))
    ]);
  }
}
