import 'package:flutter/material.dart';

import '../services/game_service.dart';

class GameProvider
extends ChangeNotifier{

GameService game=
GameService();

void start(){

game.startGame();

notifyListeners();

}

void tapButton(int value){

game.checkInput(value);

notifyListeners();

}

int get level=>
game.level;

List<int> get sequence=>
game.sequence;

}