import 'package:flutter/material.dart';
import 'package:nu_pogodi/my_game.dart';


class OverlayController extends StatelessWidget {
  final MyGame game;
  const OverlayController({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Positioned(
        left:10, 
        top:10,
        width: 10,
        height: 10,
        //you can use "right" and "bottom" too
        child:IconButton(icon:const Icon(Icons.home),
        onPressed:(){
         // print("pressed");
          //icon=Image.file(File("assets/images/BtnDown.png");
        }
        
           
        )
      ),
      ],
    );
  }
}
