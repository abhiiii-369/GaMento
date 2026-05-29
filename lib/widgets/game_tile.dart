import 'package:flutter/material.dart';

class GameTile
extends StatelessWidget{

final Color color;

final VoidCallback onTap;

const GameTile({

super.key,
required this.color,
required this.onTap

});

@override
Widget build(
BuildContext context){

return GestureDetector(

onTap:onTap,

child:Container(

height:120,

width:120,

margin:
const EdgeInsets.all(
10
),

decoration:

BoxDecoration(

color:color,

borderRadius:
BorderRadius.circular(
20
),

boxShadow:[

BoxShadow(

color:
color,

blurRadius:20

)

]

)

)

);

}

}