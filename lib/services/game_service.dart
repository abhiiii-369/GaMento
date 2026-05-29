import 'dart:math';

class GameService {

List<int> sequence=[];

List<int> playerSequence=[];

int level=0;

Random random=Random();

void startGame(){

sequence.clear();

playerSequence.clear();

level=0;

nextLevel();

}

void nextLevel(){

playerSequence.clear();

level++;

sequence.add(
random.nextInt(4)
);

}

bool checkInput(int value){

playerSequence.add(value);

int current=
playerSequence.length-1;

if(playerSequence[current]
!=sequence[current]){

return false;
}

if(playerSequence.length
==
sequence.length){

nextLevel();
}

return true;

}

}