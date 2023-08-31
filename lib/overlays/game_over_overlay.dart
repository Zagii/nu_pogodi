
import 'package:flutter/material.dart';
import 'package:nu_pogodi/my_game.dart';

class GameOverOverlayComponent extends StatelessWidget {
  const GameOverOverlayComponent({Key? key, required this.game}) : super(key: key);
  final MyGame game;

  @override
  Widget build(BuildContext context) {
    const double y=40;
    return Container(
      color: const Color.fromARGB(255, 69, 65, 65).withAlpha(180),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
              top: y+10,
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
              top: y+50,
              //  left: 0,
              child: Text("Gave Over",
                  style: TextStyle(
                      fontFamily: 'niceTango',
                      fontSize: 30,
                      color: Color.fromARGB(255, 48, 132, 44)))),
          Positioned(
              top: y+90,
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
              top: y+120,
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
              top: y+150,
              //left: 0,
              // width: 300,
              child: Text("Your score: ${game.punkty}",
                  style: const TextStyle(
                      fontFamily: 'niceTango',
                      fontSize: 25,
                      color: Color.fromARGB(255, 48, 132, 44)))),
          Positioned(
              top: y+210,
              //left: 0,
            //  width: 300,
              child: Text("High score: ${game.typGry==TypGry.gameA? game.highScoreA:game.highScoreB}",
                  style: const TextStyle(
                      fontFamily: 'niceTango',
                      fontSize: 25,
                      color: Color.fromARGB(255, 48, 132, 44)))),
                          Positioned(
              top: y+180,
              //left: 0,
           //   width: 300,
              child: Text("Game mode ${game.typGry==TypGry.gameA? "A":"B"}",
                  style: const TextStyle(
                      fontFamily: 'niceTango',
                      fontSize: 10,
                      color: Color.fromARGB(255, 18, 86, 15)))),
          Positioned(
            top: y+250,
            //left: 150,
          //  width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               
                FloatingActionButton(
                  heroTag: 'gameOverGame_ok',
                  highlightElevation: 50,
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  backgroundColor: Colors.green.withAlpha(100),
                  onPressed: () {
                    game.gameIdle();
                    game.overlays.remove('GameOverOverlay');
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
