import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nu_pogodi/ad_helper.dart';
import 'package:nu_pogodi/my_game.dart';


class PauseGameOverlayComponent extends StatefulWidget {
  const PauseGameOverlayComponent({super.key,required this.game});

 final MyGame game;

  @override
  State<PauseGameOverlayComponent> createState() => _PauseGameOverlayComponentState();
}

class _PauseGameOverlayComponentState extends State<PauseGameOverlayComponent> {

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
              child: Text("Pause",
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
              child: Text("Score: ${widget.game.punkty}",
                  style: const TextStyle(
                      fontFamily: 'niceTango',
                      fontSize: 25,
                      color: Color.fromARGB(255, 48, 132, 44)))),
          Positioned(
              top: 220,
              //left: 0,
              width: 300,
              child: Text("High score: ${widget.game.typGry==TypGry.gameA? widget.game.highScoreA:widget.game.highScoreB}",
                  style: const TextStyle(
                      fontFamily: 'niceTango',
                      fontSize: 20,
                      color: Color.fromARGB(255, 48, 132, 44)))),
          Positioned(
            top: 270,
            //left: 150,
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Resume game",
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
                    widget.game.gameResume();
                    widget.game.overlays.remove('PauseGameOverlay');
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
