
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:nu_pogodi/my_game.dart';
import 'package:nu_pogodi/overlays/game_over_overlay.dart';
import 'package:nu_pogodi/overlays/new_game_overlay.dart';
import 'package:nu_pogodi/overlays/pause_game_overlay.dart';

import 'overlays/overlay_component.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setLandscape();
  Flame.device.fullScreen();
  runApp(MaterialApp(
    home: Scaffold(
      body: GameWidget(
        game: MyGame(),
         overlayBuilderMap: {
           'ButtonController': (BuildContext context, MyGame game) {
             return OverlayController(
               game: game,
             );
           },
          'NewGameOverlay': (BuildContext context, MyGame game) {
             return NewGameOverlayComponent(
               game: game,
             );
           },
           'PauseGameOverlay': (BuildContext context, MyGame game) {
              return PauseGameOverlayComponent( game: game);},
            'GameOverOverlay': (BuildContext context, MyGame game) {
              return GameOverOverlayComponent( game: game);}
             
         },
      ),
    ),
  ));
}
