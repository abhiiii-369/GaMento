import 'package:flutter/material.dart';

class TimerProvider
extends ChangeNotifier{

Duration selectedTime=
const Duration(minutes:30);

void setTimer(
Duration duration){

selectedTime=
duration;

notifyListeners();

}

}