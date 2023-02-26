import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marvalfit/config/screen_args_data.dart';
import 'package:marvalfit/firebase/messages/model/message.dart';
import 'package:marvalfit/firebase/users/model/user.dart';
import 'package:marvalfit/utils/decoration.dart';
import 'package:marvalfit/widgets/cached_avatar_image.dart';
import 'package:sizer/sizer.dart';

import '../../constants/alerts/show_dialog.dart';

import '../../config/log_msg.dart';
import '../../config/custom_icons.dart';

import '../../constants/colors.dart';
import '../../constants/global_variables.dart';
import '../../constants/string.dart';
import '../../constants/theme.dart';

import '../../utils/extensions.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/audio_system.dart';

import '../../widgets/marval_drawer.dart';

import '../../widgets/show_fullscreen_image.dart';
import 'chat_logic.dart';


///@TODO Let user send Videos

final TextEditingController _controller = TextEditingController();
ScrollController returnController(Ref ref){
  ScrollController  res = ScrollController();
  res.addListener((){ if(res.position.maxScrollExtent==res.offset){ messagesLogic.fetchMore(ref, n: 10); }});
  return res;
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static String routeName = '/chat';
  @override
  Widget build(BuildContext context) {
    String userId = uid!;
    return Scaffold(
    backgroundColor: kWhite,
    drawer: const MarvalDrawer(name: 'Chat',),
    body:  SizedBox( width: 100.w, height: 100.h,
        child: Stack(
            children: [
              /// Grass Image */
              Positioned( top: 0,
               child: SizedBox(width: 100.w, height: 12.h,
               child: Image.asset(
                  'assets/images/grass.png',
                  fit: BoxFit.cover
               )),
              ),
              ///White Container */
              Positioned( top: 8.h,
              child: Container(width: 100.w, height: 10.h,
              decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.w),
                    topRight: Radius.circular(10.w)
                  ),
              ))
              ),
              /// User Data */
              Positioned(  top: 1.h, left: 8.w,
                  child: SafeArea(
                    child:  Watcher((context, ref, child) {
                      User user = userLogic.get(ref) ?? User.empty();
                      return _BoxUserData(user: user);
                    })
              )),
              /// Container */
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
              ///* Messages  */
              Positioned( top: 18.h,
                  child:  Container(width: 100.w, height: 72.h,
                      padding: EdgeInsets.only( bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: ClipRRect(
                      borderRadius: BorderRadius.vertical( top: Radius.circular(15.w) ),
                      child: Watcher((context, ref, child) {
                            List<Message> messages = messagesLogic.getChat(ref);
                            return ListView.builder(
                              reverse: true,
                              itemCount: messages.length,
                              controller: returnController(ref),
                              itemBuilder: (context, index){
                                Message message = messages[index];
                                return Column(
                                crossAxisAlignment: message.trainer ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  if(index == messages.length-1) _DateLine(date: message.date, pastDate: null,), //Put date up to first date shown
                                  if(index != messages.length-1) _DateLine(date:message.date, pastDate: messages[index+1].date,),
                                  message.type == MessageType.IMAGE ? _ImageBox(message: message) : const SizedBox.shrink(),
                                  message.type == MessageType.AUDIO ? _AudioBox(message: message) : const SizedBox.shrink(),
                                  message.type == MessageType.TEXT  ? _MessageBox(message: message) : const SizedBox.shrink(),
                                ]);
                            });
              })))),
              /// TextField */
              Positioned(bottom: 3.w, left: 5.w,
                  child: SafeArea(
                      child: SizedBox( width: 90.w,
                          child: Stack(
                            children: [
                              _ChatTextField(userId: userId),
                              //TIMER LABEL
                              Watcher((context, ref, child){
                                int secs = watchTimer(ref);
                                Duration duration = Duration(seconds: secs);
                                if(secs>=0){
                                  return Center(
                                      child: Container(width: 70.w, height: 5.h,
                                        margin: EdgeInsets.only(top: 1.h), color: kWhite,
                                        child: Padding(padding: EdgeInsets.only(top: 1.3.h, left: 2.w), child: TextH2(duration.printDuration(), size: 3.8,)),
                                      )
                                  );
                                }
                                return const SizedBox.shrink();
                              })
                            ],
                          )
                      ))
              )
            ])),
    );
  }
}
class _DateLine extends StatelessWidget {
  const _DateLine({required this.date, required this.pastDate, Key? key}) : super(key: key);
  final DateTime  date;
  final DateTime? pastDate;
  @override
  Widget build(BuildContext context) {
    if(pastDate != null && date.id == pastDate!.id) return const SizedBox.shrink();
    return  Container(
        padding: EdgeInsets.only(bottom: 1.h),
        child: Row(  mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 30.w, height: 0.5.w, color: kGrey, ),
              TextP2('${date.aestheticStringDate()} ', color: kGrey, size: 3,),
              Container(width: 30.w, height: 0.5.w, color: kGrey, )
            ]));
  }
}




enum TextFieldState { INIT, TEXT, RECORDING, RECORD_END}
Creator<TextFieldState> stateCreator = Creator.value(TextFieldState.INIT);
TextFieldState watchState(Ref ref) => ref.watch(stateCreator);

void updateState(Ref ref, TextFieldState state){
  if(state == TextFieldState.INIT){
    _controller.text = '';
  }
  ref.update<TextFieldState>(stateCreator, (p0) => state);
}

Emitter<AudioSystem> audioEmitter = Emitter((ref, emit) async{
  AudioSystem audioSystem = AudioSystem();
  await audioSystem.initAudioSystem();
  emit(audioSystem);
}, keepAlive: true);

class _ChatTextField extends StatelessWidget {
  const _ChatTextField({required this.userId, Key? key}) : super(key: key);
  final String userId;
  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child) {
      AudioSystem? audioSystem = ref.watch(audioEmitter.asyncData).data;
      return TextField(
          onChanged: (value){
            TextFieldState state = watchState(ref);
            if(state == TextFieldState.TEXT && value.isEmpty){
              updateState(ref, TextFieldState.INIT);
            }else if(state == TextFieldState.INIT && value.isNotEmpty){
              updateState(ref, TextFieldState.TEXT);
            }
          },
          onEditingComplete: () async {
            TextFieldState state = watchState(ref);
            if (isNotEmpty(_controller.text) && state == TextFieldState.TEXT) {
              Message message = Message.create(_controller.text, MessageType.TEXT,  userId);
              messagesLogic.add(ref, message);
              updateState(ref, TextFieldState.INIT);
            }
          },
          enabled: watchState(ref) != TextFieldState.RECORDING || watchState(ref) != TextFieldState.RECORD_END,
          enableInteractiveSelection: watchState(ref) == TextFieldState.INIT || watchState(ref) == TextFieldState.TEXT,
          autofocus: true,
          controller: _controller,
          cursorColor: kGreen,
          style: TextStyle(fontSize: 4.w, fontFamily: p2, color: kBlack),
          decoration: InputDecoration(
            filled: true,
            fillColor: kWhite,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(4.w)),
            ),
            hintText: 'Escribe algo',
            hintStyle: TextStyle(fontSize: 4.w, fontFamily: p2, color: kGrey),
            //CAMERA AND DELETE AUDIO
            prefixIcon:  Watcher((context, ref, child) {
              TextFieldState state = watchState(ref);
              return GestureDetector(
                onTap: () async {
                  if (state == TextFieldState.RECORD_END) {
                    resetTimer(ref);
                    updateState(ref, TextFieldState.INIT);
                  } else if(state == TextFieldState.INIT || state == TextFieldState.TEXT) {
                    await ImagePicker().pickImage(source: ImageSource.gallery)
                        .then((value) { ThrowDialog.uploadImage(context, value!);  })
                        .onError((error, stackTrace) { logError("ImagePicker can't select any image");});
                  }
                },
                child: Container(padding: EdgeInsets.all(3.w),
                child:state == TextFieldState.INIT || state == TextFieldState.TEXT
                    ? Icon( CustomIcons.camera, color:  kBlack, size: 7.w )
                    : Icon( CustomIcons.camera, color: kRed, size: 7.w //CustomIcons.trash
                ),
              ));
            }),
            // SEND AND RECORD
            suffixIcon: Watcher((context, ref, child) {
              TextFieldState state = watchState(ref);
              return Listener(
                  onPointerDown: (details) async {
                    if ((state == TextFieldState.INIT) && audioSystem!.isInit) {
                      audioSystem.record();
                      startTimer(ref, true);
                      updateState(ref, TextFieldState.RECORDING);
                    } else if (state == TextFieldState.RECORD_END && audioSystem != null && audioSystem.uri != null) {
                      logWarning('Uploading Audio');
                      int audioDuration = watchTimer(ref);
                      resetTimer(ref);
                      storageController.uploadChatAudio(userId, audioSystem.uri!)
                      .then((url){
                        Message message = Message.create(url ?? '', MessageType.AUDIO, userId, duration: audioDuration );
                        messagesLogic.add(ref, message);
                      })
                     .onError((error, stackTrace){
                        logError('Unexpected Problem uploading audio');
                      });
                      updateState(ref, TextFieldState.INIT);
                    }
                  },
                  onPointerUp: (details) async {
                    //Stop Recording
                    if (state == TextFieldState.RECORDING && audioSystem!.isInit) {
                      await audioSystem.stopRecorder();
                      stopTimer(ref);
                      updateState(ref, TextFieldState.RECORD_END);
                    }
                    //Send Text MSG
                    else if (isNotEmpty(_controller.text) && state == TextFieldState.TEXT) {
                      Message message = Message.create(_controller.text, MessageType.TEXT,  userId);
                      messagesLogic.add(ref, message);
                      updateState(ref, TextFieldState.INIT);
                    }
                  },
                  child: Container(padding: EdgeInsets.all(3.w),
                  child: Icon(state == TextFieldState.INIT || state == TextFieldState.RECORDING
                      ? Icons.mic_rounded
                      : Icons.send_rounded, color: kBlack, size: 7.w
                  ))
              );
            }),
          )
      );
    });
  }
}

class _BoxUserData extends StatelessWidget {
  const _BoxUserData({required this.user, Key? key}) : super(key: key);
  final User user;
  @override
  Widget build(BuildContext context) {
    return SizedBox( width: 90.w,
      child: Row(
        children: [
          Container(
              decoration: BoxDecoration(
                boxShadow: [ BoxShadow(
                  color: kBlack.withOpacity(0.7),
                  offset: Offset(0, 1.3.w),
                  blurRadius: 1.5.w,
                )],
                borderRadius: BorderRadius.all(Radius.circular(100.w)),
              ),
              child: CachedAvatarImage(
                url: user.profileImage,
                size: 5,
                expandable: true,
              )),
          SizedBox(width: 2.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.h,),
              TextH2('${user.name.removeIcon()}${user.lastName}'.maxLength(20), size: 4),
              TextH2(user.work, size: 3, color: kGrey,),
            ]),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(top: 5.h, right: 3.w),
            child: TextH2(user.name.getIcon(), size: 8,),
          )
        ]),
    );
  }
}

class _MessageBox extends StatelessWidget {
  const _MessageBox({required this.message, Key? key}) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    final bool fromTrainer = message.trainer;
    int getMarginSize(Message msg){
      int labelSize = 0;
      List<int> sizes = [0, 4, 8, 12, 16, 20];
      List<int> margins = [77,65,53,41,29,15];
      sizes.where((size) => msg.content.length>=size).forEach((element)=> labelSize++);
      return margins[labelSize-1];
    }

    return SizedBox( width: 100.w,
      child: Column(
          crossAxisAlignment: fromTrainer ?   CrossAxisAlignment.start : CrossAxisAlignment.end,
          children:[ Container(
            padding: EdgeInsets.all(2.3.w),
            margin: EdgeInsets.only(
                left: fromTrainer ? 2.w : getMarginSize(message).w,
                right : fromTrainer ? getMarginSize(message).w : 2.w,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft:  !fromTrainer ? Radius.circular(2.w) : Radius.zero,
                topRight : fromTrainer ? Radius.circular(2.w) : Radius.zero,
                bottomLeft: Radius.circular(2.w),
                bottomRight: Radius.circular(2.w),
              ),
              color: fromTrainer ? kBlack : kBlue,
            ),
            child: TextH2(message.content, color: kWhite, size: 3.3,textAlign: TextAlign.end)),
            Padding(padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 1.h,),
            child: TextP2(message.date.toFormatStringHour(), color: kGrey, size: 3,))
          ]),
    );
  }
}

class _ImageBox extends StatelessWidget {
  const _ImageBox({required this.message, Key? key}) : super(key: key);
  final Message message;
  @override
  Widget build(BuildContext context) {
    final bool fromTrainer = !message.trainer;
    return SizedBox( width: 100.w,
      child: Column(
          crossAxisAlignment: fromTrainer ?   CrossAxisAlignment.end : CrossAxisAlignment.start,
          children:[ Container(
              padding: EdgeInsets.all(2.3.w),
              margin: EdgeInsets.only(
                  left: fromTrainer ? 0 : 2.w,
                  right : fromTrainer ? 2.w : 0
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft:  fromTrainer ? Radius.circular(3.w) : Radius.zero,
                  topRight : !fromTrainer ? Radius.circular(3.w) : Radius.zero,
                  bottomLeft: Radius.circular(3.w),
                  bottomRight: Radius.circular(3.w),
                ),
                color: fromTrainer ? kBlue : kBlack,
              ),
                child: SizedBox(width: 50.w, height: 20.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft:  fromTrainer ? Radius.circular(2.w) : Radius.zero,
                      topRight : !fromTrainer ? Radius.circular(2.w) : Radius.zero,
                      bottomLeft: Radius.circular(2.w),
                      bottomRight: Radius.circular(2.w),
                    ),
                    child: CachedNetworkImage(
                        imageUrl: message.content,
                        fadeInCurve: Curves.easeInOutExpo,
                        placeholder: (context, url) => Center(child: Icon(CustomIcons.camera, size: 8.w, color: kWhite)),
                        errorWidget: (context, url, error) =>
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.w),
                                  color: kWhite,
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt_rounded, size: 8.w, color: kRed),
                                      SizedBox(height: 1.h,),
                                      const TextP1("Fallo en la descarga", color: kRed, size: 3,)
                                    ])),
                        imageBuilder: (context, imageProvider) {
                          return FullScreenImage(url: message.content, image: imageProvider);}),
                  ),
                )),
            Padding(padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 1.h,),
                child: TextP2(message.date.toFormatStringHour(), color: kGrey, size: 3,))
          ]),
    );
  }
}

Creator<String> _currentAudio = Creator.value("");
final AudioPlayer _audioPlayer = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
Emitter<Duration?>   _positionStream = Emitter.stream((p0) => _audioPlayer.onPositionChanged);
Emitter<Duration?>   _durationStream = Emitter.stream((p0) => _audioPlayer.onDurationChanged);
Emitter<PlayerState?>   _stateStream = Emitter.stream((p0) => _audioPlayer.onPlayerStateChanged);


void _init(Ref ref, String url, int milliseconds) async{
  await _audioPlayer.setSourceUrl(url);
  if(milliseconds > 0){
    await _audioPlayer.seek(Duration(milliseconds: milliseconds));
  }
  await _audioPlayer.resume();
  ref.update<String>(_currentAudio, (p0) => url);
}
Future<void> _play(Ref ref) async {
  final position = ref.watch(_positionStream.asyncData).data;
  if (isNotNull(position) && position!.inMilliseconds > 0) {
    await _audioPlayer.seek(position);
  }
  await _audioPlayer.resume();
}
Future<void> _pause() async => await _audioPlayer.pause();


class _AudioBox extends StatelessWidget {
  const _AudioBox({required this.message, Key? key}) : super(key: key);
  final Message message;
  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child){
      String audio = ref.watch(_currentAudio);
      if(audio == message.content){
        return _AudioBoxPLayer(message: message);
      }
      return _StaticAudioBox(message: message);

    });
  }
}

class _AudioBoxPLayer extends StatelessWidget {
  const _AudioBoxPLayer({required this.message, Key? key}) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    final bool fromTrainer = !message.trainer;
    return Column(
        crossAxisAlignment: fromTrainer ?   CrossAxisAlignment.end : CrossAxisAlignment.start,
        children:[
        Container(
          padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.w),
          margin: EdgeInsets.only(
              left: fromTrainer ? 25.w : 2.w,
              right : fromTrainer ? 2.w : 25.w
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft:  fromTrainer ? Radius.circular(3.w) : Radius.zero,
              topRight : !fromTrainer ? Radius.circular(3.w) : Radius.zero,
              bottomLeft: Radius.circular(3.w),
              bottomRight: Radius.circular(3.w),
            ),
            color: fromTrainer ? kBlue : kBlack,
          ),
           child: Row(
                  children: [
                    // PLAY BUTTON
                    Watcher((context, ref, child){
                      PlayerState? state =  ref.watch(_stateStream.asyncData).data;
                      return GestureDetector(
                        onTap: (){
                          double v = _sliderMap[message.content] ?? 0;
                          int pos  = (v * message.duration * 1000).round();
                          if(state == PlayerState.stopped){ _init(ref, message.content, pos); }
                          else if(state == PlayerState.playing){ _pause(); }
                          else{ _play(ref); }
                        },
                        child: state == PlayerState.paused || state == PlayerState.completed
                        ? Icon(Icons.play_circle_fill_rounded, color: kWhite, size: 8.w,)
                        : Icon(Icons.pause_circle_filled_rounded, color: kWhite, size: 8.w,)
                      );
                    }),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 1.2.h,),
                        SizedBox(width: 60.w, height: 2.h,
                            child: Watcher((context, ref, child) {
                              Duration? position = ref.watch(_positionStream.asyncData).data;
                              Duration? duration = ref.watch(_durationStream.asyncData).data;
                              return Slider(
                                onChanged: (v) {
                                  if (duration != null) {
                                    final position = v * duration.inMilliseconds;
                                    _audioPlayer.seek(Duration( milliseconds: position.round()));
                                  }
                                  _sliderMap[message.content] = v;
                                },
                                value: position != null && duration != null &&
                                    position.inMilliseconds > 0 && position.inMilliseconds < duration.inMilliseconds
                                    ? position.inMilliseconds / duration.inMilliseconds
                                    : _sliderMap[message.content] ?? 0.0,
                                inactiveColor: fromTrainer ? kBlueSec : kGrey,
                                activeColor: fromTrainer ? kBlack : kWhite,
                                thumbColor: fromTrainer ? kBlack : kWhite,
                              );
                            })),
                        Padding(padding: EdgeInsets.only(left: 5.w, top: 0.4.h),
                            child: Watcher((context, ref, child) {
                              final duration = ref.watch(_positionStream.asyncData).data ?? Duration.zero;
                              return TextP1("${Duration(seconds: message.duration -  duration.inSeconds ).printDuration()} ", size: 2.5, color: kWhite);
                        }))
                  ])
           ])),
          // SENDING DATETIME
          Padding(padding: EdgeInsets.only(left: 4.w, right: 4 .w, bottom: 1.h,),
              child: TextP2(message.date.toFormatStringHour(), color: kGrey, size: 3,))
        ]);
  }
}

class _StaticAudioBox extends StatelessWidget {
  const _StaticAudioBox({required this.message, Key? key}) : super(key: key);
  final Message message;
  @override
  Widget build(BuildContext context) {
    final bool fromTrainer = !message.trainer;
    return Column(
        crossAxisAlignment: fromTrainer ?   CrossAxisAlignment.end : CrossAxisAlignment.start,
        children:[
          Container(
          padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.w),
          margin: EdgeInsets.only(
              left: fromTrainer ? 25.w : 2.w,
              right : fromTrainer ? 2.w : 25.w
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft:  fromTrainer ? Radius.circular(3.w) : Radius.zero,
              topRight : !fromTrainer ? Radius.circular(3.w) : Radius.zero,
              bottomLeft: Radius.circular(3.w),
              bottomRight: Radius.circular(3.w),
            ),
            color: fromTrainer ? kBlue : kBlack,
          ),
            child:  Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        double v = _sliderMap[message.content] ?? 0;
                        int pos  = (v * message.duration * 1000).round();
                        _init(context.ref, message.content, pos);
                      },
                      child: Icon(Icons.play_circle_fill_rounded,  color: kWhite, size: 8.w,),
                    ),
                   _FakeSlider(message: message,),
                ])
          ),
          Padding(padding: EdgeInsets.only(left: 4.w, right: 4 .w, bottom: 1.h,),
           child: TextP2(message.date.toFormatStringHour(), color: kGrey, size: 3,))
        ]);
  }
}

class _FakeSlider extends StatefulWidget {
  const _FakeSlider({required this.message, Key? key}) : super(key: key);
  final Message message;
  @override
  State<_FakeSlider> createState() => _FakeSliderState();
}


Map _sliderMap = {};
class _FakeSliderState extends State<_FakeSlider> {
  @override
  Widget build(BuildContext context) {
    final bool fromTrainer = widget.message.trainer;
    final String content = widget.message.content;
    final int duration = widget.message.duration;
    final int durationPosition = duration - (duration * (_sliderMap[content] ?? 0)).toInt();
    return  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1.4.h,),
          // Fake slider
          SizedBox(width: 60.w, height: 2.h,
              child: Slider(
                  onChanged: (v) {
                    setState(() {
                      _sliderMap[content] = v;
                    });
                  },
                  value: _sliderMap[content] ?? 0,
                  inactiveColor: fromTrainer ? kBlueSec : kGrey,
                  activeColor: fromTrainer ? kBlack : kWhite,
                  thumbColor: fromTrainer ? kBlack : kWhite,
                )),
          Padding(padding: EdgeInsets.only(left: 5.w, top: 0.4.h),
              child: TextP1("${Duration(seconds: durationPosition ).printDuration()} ", size: 2.5, color: kWhite)
          ),
        ]);
  }
}
