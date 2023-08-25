import 'package:flutter/material.dart';
import 'package:nu_pogodi/my_game.dart';


class GameOverHighScoreOverlayComponent extends StatefulWidget {
   final MyGame game;

  const GameOverHighScoreOverlayComponent({Key? key, required this.game})
      : super(key: key);
 
  @override
  State<GameOverHighScoreOverlayComponent> createState() =>  _GameOverHighScoreOverlayComponentState();
}

class _GameOverHighScoreOverlayComponentState extends State<GameOverHighScoreOverlayComponent> {
    
   
  String nameHighScore="";

 
  @override
  Widget build(BuildContext context) {
   
    return Container(
      color: const Color.fromARGB(255, 69, 65, 65).withAlpha(180),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
              top: 10,
              //  left: 0,
              child: Container(
                  width: 300,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/images/tytul.png'),
                      fit: BoxFit.cover,
                    ),
                  ))),
          const Positioned(
              top: 50,
              //  left: 0,
              child: Text("Gave Over",
                  style: TextStyle(
                      fontFamily: 'niceTango',
                      fontSize: 30,
                      color: Color.fromARGB(255, 48, 132, 44)))),
          Positioned(
              top: 100,
              //  left: 0,
              child: Container(
                  width: 400,
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/images/dialog.png'),
                      fit: BoxFit.fill,
                    ),
                  ))),
          Positioned(
              top: 120,
              left: 250,
              child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/images/zajacOkno.png'),
                      fit: BoxFit.fill,
                    ),
                  ))),
          const Positioned(
              top: 150,
              //left: 0,
              // width: 300,
              child: Text(
                  "W O W W W !!!",
                  style: TextStyle(
                      fontFamily: 'niceTango',
                      fontSize: 25,
                      color: Color.fromARGB(255, 48, 132, 44)))),
          Positioned(
              top: 180,
              //left: 0,
              // width: 300,
              child: Text(
                  "You get HIGH SCORE: ${widget.game.punkty}",
                  style: const TextStyle(
                      fontFamily: 'niceTango',
                      fontSize: 15,
                      color: Color.fromARGB(255, 48, 132, 44)))),
           Positioned(
              top: 210,
              //left: 0,
               width: 150,
              child: // Note: Same code is applied for the TextFormField as well
                  TextField(
                     onChanged: (String value) {nameHighScore=value;},
                    maxLength: 8,
                   style: const TextStyle(
                      fontFamily: 'niceTango',
                      fontSize: 25,
                      color: Color.fromARGB(255, 48, 132, 44)),  
                decoration: const InputDecoration(
                  label:  Text(
                  "Enter Your name:",
                  style: TextStyle(
                      fontFamily: 'niceTango',
                      fontSize: 15,
                      color: Color.fromARGB(255, 48, 132, 44))),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Colors.greenAccent), 
                  ),
                ),
             
              )),
         
          Positioned(
              top: 130,
              //left: 10,
              //   width: 300,
              child: Text("Game mode ${widget.game.typGry == TypGry.gameA ? "A" : "B"}",
                  style: const TextStyle(
                      fontFamily: 'niceTango',
                      fontSize: 15,
                      color: Color.fromARGB(255, 48, 132, 44)))),
          Positioned(
            top: 260,
            //left: 150,
            //  width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  heroTag: 'gameOverHSGame_ok',
                  highlightElevation: 50,
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  backgroundColor: Colors.green.withAlpha(100),
                  onPressed: () {
                    widget.game.gameIdle();
                    if(widget.game.typGry==TypGry.gameA)
                    {
                      widget.game.saveHighScoreA(widget.game.punkty, nameHighScore);
                    }else
                    {
                      widget.game.saveHighScoreB(widget.game.punkty, nameHighScore);
                    }
                    widget.game.overlays.remove('GameOverHighScoreOverlay');
                  },
                  child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: ExactAssetImage('assets/images/ok.png'),
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
