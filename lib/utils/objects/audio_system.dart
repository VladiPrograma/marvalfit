import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/string.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioSystem {
  late FlutterSoundRecorder recorder;
  late Codec codec;
  late String path;
  String? uri;
  bool isInit = false;
  bool recordON = false;

  AudioSystem(){
    recorder = FlutterSoundRecorder();
    codec = Codec.aacADTS;
    path = 'too.aac';
  }

  Future<void> initAudioSystem() async {
  if(!isInit) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    await recorder.openRecorder();

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    isInit = true;
    }
  }


// -------  Here is the code to record  -----------------------

  void record() async {
    await recorder.startRecorder( toFile: path, codec: codec);
    recordON = true;
    //@TODO init timer
  }

  Future<void> stopRecorder() async {
    uri = await recorder.stopRecorder();
    logWarning("$logErrorPrefix RecordStop: $uri");
    recordON = false;

  }

// -------  Here is the code to playback  ---
  void playSound() async{
    FlutterSoundPlayer player = FlutterSoundPlayer();
    await player.openPlayer();
    await player.startPlayer(fromURI: uri);
  }



}
