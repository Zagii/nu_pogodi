import 'package:flutter/material.dart';
import 'package:nu_pogodi/my_game.dart';


class OpcjeOverlayComponent extends StatefulWidget {
  const OpcjeOverlayComponent({super.key,required this.game});

 final MyGame game;

  @override
  State<OpcjeOverlayComponent> createState() => _OpcjeOverlayComponentState();
}

class _OpcjeOverlayComponentState extends State<OpcjeOverlayComponent> {

 @override
  void initState() {
    super.initState();

   
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 69, 65, 65).withAlpha(180),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
              top: 50,
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
              top: 90,
              
              //  left: 0,
              child: Text("Options",
                  style: TextStyle(
                      fontFamily: 'niceTango',
                      fontSize: 30,
                      color: Color.fromARGB(255, 48, 132, 44)))),
          Positioned(
              top: 130,
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
              top: 135,
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
          Positioned(
              top: 170,
              //left: 0,
              // width: 300,
              child: GestureDetector(
                onTap: (){
                  setState(() {
                  widget.game.saveAudioSettings(!widget.game.isAudio);},  
                  );
                },
                child: Text("Audio: ${widget.game.isAudio?"on":"off"}",
                    style: const TextStyle(
                        fontFamily: 'niceTango',
                        fontSize: 25,
                        color: Color.fromARGB(255, 48, 132, 44))),
              )),
          Positioned(
              top: 250,
              //left: 0,
           //   width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("High score mode B: ${widget.game.highScoreB}",
                      style: const TextStyle(
                          fontFamily: 'niceTango',
                          fontSize: 20,
                          color: Color.fromARGB(255, 48, 132, 44))),
                    GestureDetector(
                      onTap: (){},
                      child: const Text("Watch video to reset high score B",
                        style:  TextStyle(
                            fontFamily: 'niceTango',
                            fontSize: 15,
                            color: Color.fromARGB(255, 121, 23, 3))),
                    ),
                ],
              )),
                               Positioned(
              top: 215,
              //left: 0,
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("High score mode A: ${widget.game.highScoreA}",
                      style: const TextStyle(
                          fontFamily: 'niceTango',
                          fontSize: 20,
                          color: Color.fromARGB(255, 48, 132, 44))),
                    GestureDetector(
                      onTap: (){},
                      child: const Text("Reset A",
                        style:  TextStyle(
                            fontFamily: 'niceTango',
                            fontSize: 15,
                            color: Color.fromARGB(255, 121, 23, 3))),
                    ),
                ],
              )),
          Positioned(
            top: 280,
            //left: 150,
            width: 200,
            child: Row(
             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Close ",
                    style: TextStyle(
                        fontFamily: 'niceTango',
                        fontSize: 20,
                        color: Color.fromARGB(255, 48, 132, 44))),
                FloatingActionButton(
                  heroTag: 'newGame_ok',
                  highlightElevation: 50,
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  backgroundColor: Colors.green.withAlpha(100),
                  onPressed: () {
                   widget.game.closeOptionsDialog();
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
