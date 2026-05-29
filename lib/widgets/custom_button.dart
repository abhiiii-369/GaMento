import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

final String text;

final VoidCallback onPressed;

const CustomButton({

super.key,
required this.text,
required this.onPressed

});

@override
Widget build(BuildContext context){

return SizedBox(

width:250,

height:55,

child: ElevatedButton(

onPressed:onPressed,

style: ElevatedButton.styleFrom(

backgroundColor:
const Color(0xff7C3AED),

shape:
RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(20)

)

),

child:Text(
text,
style:
const TextStyle(
fontSize:18
)
),

)

);

}

}