
import 'package:flutter/material.dart';
import 'package:nu_pogodi/main.dart';

class PauseGameOverlayComponent extends StatelessWidget {
  const PauseGameOverlayComponent({Key? key, required this.game}) : super(key: key);
  final MyGame game;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      height: 600,
      child: 
          Container(
            color: Color.fromARGB(143, 209, 213, 215),
            child: Column(
              children: [
                Text("Pause Game" ),
                IconButton(
                  iconSize: 50,
                  icon: const Icon(Icons.play_arrow),
                  color: Colors.white,
                  onPressed: () {
                   game.gameResume();
                   game.overlays.remove('PauseGameOverlay');
                  },
                ),
              ]
      ),
    ));
  }
}