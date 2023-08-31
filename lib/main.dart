

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nu_pogodi/my_game.dart';
import 'package:nu_pogodi/overlays/baner_overlay.dart';
import 'package:nu_pogodi/overlays/game_over_ad_overlay.dart';
import 'package:nu_pogodi/overlays/game_over_hs_overaly.dart';
import 'package:nu_pogodi/overlays/game_over_overlay.dart';
import 'package:nu_pogodi/overlays/new_game_overlay.dart';
import 'package:nu_pogodi/overlays/opcje_overlay.dart';
import 'package:nu_pogodi/overlays/pause_game_overlay.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import 'overlays/overlay_component.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //SharedPreferences.setMockInitialValues({});
  Flame.device.setLandscape();
  Flame.device.fullScreen();
  MobileAds.instance.initialize();
  
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
            'OptionsOverlay': (BuildContext context, MyGame game) {
              return OpcjeOverlayComponent( game: game);},
            'GameOverOverlay': (BuildContext context, MyGame game) {
              return GameOverOverlayComponent( game: game);},
            'GameOverHighScoreOverlay': (BuildContext context, MyGame game) {
              return GameOverHighScoreOverlayComponent( game: game);},
            'GameOverAdScoreOverlay': (BuildContext context, MyGame game) {
              return GameOverAdOverlayComponent( game: game);},
            'BanerOverlay': (BuildContext context, MyGame game) {
              return const BanerOverlayComponent();},
             
         },
      ),
    ),
  ));
}
