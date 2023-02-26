import 'dart:async';
import 'package:creator/creator.dart';

/// TIMER STATE MANAGEMENT */
Timer? _timer ;
Creator<int> _timerCreator = Creator.value(-1);
void startTimer(Ref ref, bool refresh){
  if(refresh){
    ref.update<int>( _timerCreator, (s) => 0);
    refresh = false;
  }
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    ref.update<int>( _timerCreator, (s) => s+1);
  });
}
void stopTimer(Ref ref) => _timer?.cancel();
void resetTimer(Ref ref) => ref.update<int>( _timerCreator, (s) => -1);
int watchTimer(Ref ref) => ref.watch(_timerCreator);

