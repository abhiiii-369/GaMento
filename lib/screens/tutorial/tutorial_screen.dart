import 'package:flutter/material.dart';

import '../home/home_screen.dart';

class TutorialScreen
extends StatelessWidget{

const TutorialScreen(
{super.key});

@override
Widget build(
BuildContext context){

return Scaffold(

appBar:
AppBar(
title:
const Text(
"How To Play"
)
),

body:Padding(

padding:
const EdgeInsets.all(20),

child:Column(

children:[

const Text(

'''
1 Watch sequence

2 Remember sequence

3 Repeat correctly

4 Level increases

5 Wrong tap = Game Over
''',

style:
TextStyle(
fontSize:20
)

),

const Spacer(),

ElevatedButton(

onPressed:(){

Navigator.push(

context,

MaterialPageRoute(

builder:
(_)=>const HomeScreen()

)

);

},

child:
const Text(
"Start"
)

)

]

)

)

);

}

}