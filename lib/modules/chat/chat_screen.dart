import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/components.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:marvalfit/utils/decoration.dart';
import 'package:marvalfit/utils/marval_arq.dart';
import 'package:sizer/sizer.dart';

import '../../config/custom_icons.dart';
import '../../constants/colors.dart';
import '../../constants/string.dart';
import '../../utils/objects/message.dart';
import '../../utils/objects/user.dart';
import '../../widgets/marval_drawer.dart';

final trainerCreator = Emitter.stream((ref) async {
  return  FirebaseFirestore.instance.collection('users').where('email', isEqualTo: 'marval@gmail.com').snapshots();
});

final authEmitter = Emitter.stream((p0) => FirebaseAuth.instance.authStateChanges());
final userCreator = Emitter.stream((ref) async {
  final authId = await ref.watch(
      authEmitter.where((auth) => auth!=null).map((auth) => auth!.uid));
  return FirebaseFirestore.instance.collection('users').doc(authId).snapshots();
});

final _counter = Creator.value(<Message>[]);

List<Message> counter(Ref ref)=> ref.watch(_counter);
void addMessage(Ref ref, Message msg) => ref.update<List<Message>>(_counter , (n)=> [...n, msg]);

final TextEditingController _controller = TextEditingController();

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static String routeName = '/chat';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        drawer: const MarvalDrawer(name: 'Chat',),
        body:  Container( width: 100.w, height: 100.h,
            child: Stack(
                    children: [
                      /// Grass Image
                      Positioned( top: 0,
                          child: Container(width: 100.w, height: 18.h,
                              child: Image.asset('assets/images/grass.png', fit: BoxFit.cover))
                      ),
                      ///White Container
                      Positioned( top: 12.h,
                          child: Container(width: 100.w, height: 20.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.w), topRight: Radius.circular(10.w)),
                                  color: kWhite
                              ))),
                      /// Marval Trainer Data
                      Positioned(  top: 9.5.h, left: 8.w,
                        child: Watcher((context, ref, _) {
                          final query = ref.watch(trainerCreator.asyncData).data;
                          if(isNull(query)||query!.size==0){
                            return BoxUserData(user: MarvalUser.empty());
                          }
                          final map = query.docs.first.data();
                          final MarvalUser user = MarvalUser.fromJson(map);
                          return BoxUserData(user: user);
                        }),
                      ),
                      /// Chat Container
                      Positioned( top: 23.h,
                        child:  InnerShadow(
                            color: Colors.black,
                            blur: 10,
                            offset: Offset(0,2.w),
                            child: Container(width: 100.w, height: 77.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15.w), topRight: Radius.circular(15.w)),
                                  color: kBlack.withOpacity(0.85)
                        ))),
                      ),
                      ///* Chat Messages
                      Positioned( top: 23.h,
                        child:  Container(width: 100.w, height: 77.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15.w), topRight: Radius.circular(15.w)),
                              ),
                              child: Watcher((context, ref, child) {
                                logInfo('Rebuildeao');
                                final data = counter(ref);
                                return ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index){
                                    Message msg = data[index];
                                    if(msg.user == authUser!.uid){
                                      return TextH2(msg.message, color: kWhite, size: 4,);
                                    }
                                    return TextH2('Que pedo');
                                  });
                              },)
                            )),
                      /// TextField
                      Positioned(bottom: 3.w, left: 5.w,
                      child: SizedBox( width: 90.w,
                        child: TextField(
                          controller: _controller,
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
                                      logInfo('Khe');
                                      Message newMsg = Message.create(_controller.text, MessageType.text);
                                      newMsg.setInDB();
                                      addMessage(context.ref, newMsg);
                                    }
                                  _controller.text="";
                                },
                                child: Icon(Icons.send_rounded, color: kBlack, size: 7.w,),
                              )

                          ),
                          style: TextStyle(fontSize: 4.w, fontFamily: p2, color: kBlack),
                          cursorColor: kGreen,
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h,),
            TextH2(user.name, size: 4),
            TextH2(user.work, size: 3, color: kGrey,),
          ],
        )
      ],
    );
  }
}
