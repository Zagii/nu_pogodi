import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:nu_pogodi/actors/jajo.dart';
import 'package:nu_pogodi/actors/wilk.dart';
import 'package:nu_pogodi/world/button.dart';
import 'package:nu_pogodi/world/obudowa_component.dart';
import 'package:nu_pogodi/world/skucha_component.dart';
import 'package:nu_pogodi/world/tlo_comonent.dart';

enum GameState { idle, game, extraLife, gameOver, pause }

class MyGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  double chickenScaleFactor = 3.0;

  int skucha = 0;
  int punkty = 0;
  int level = 1;
  int nextLvlUp = 5;
  int typGry = 4;

  GameState gameState = GameState.idle;

  late Timer timer;

  late WilkComponent wilkComponent;
  late RectangleComponent tloPodwietlenie;
  //late final JoystickComponent joystick;
  late ObudowaComponent obudowaComponent;
  late SpriteComponent tloFixComponent;
  late TloComponent tloComponent;

  late TextComponent punktyTextComponent;
  late SkuchaComponent skuchaComponent;

  late ButtonComponent buttonLD;

  Vector2 ekranSize = Vector2(1285, 845);
  Vector2 ekranPos = Vector2(665, 370);

  int charlieEnergy = 0;

  final world = World();
  late final CameraComponent cameraComponent;
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    //  cameraComponent = CameraComponent(world: world);
    cameraComponent = CameraComponent.withFixedResolution(
      world: world,
      width: 2611,
      height: 1579,
    );

    add(cameraComponent);

    //cameraComponent.viewport.apply()
    //Vector2(2611,1579);
    camera.viewport = FixedResolutionViewport(Vector2(2611, 1579));
    //  camera.viewport = FixedResolutionViewport(Vector2.all(maxSide));

    tloPodwietlenie = RectangleComponent(
        size: ekranSize,
        position: ekranPos,
        paint: Paint()..color = Colors.white.withOpacity(1.0));
    add(tloPodwietlenie);

    tloFixComponent =
        SpriteComponent.fromImage(await images.load('fix.png'), priority: 10)
          ..size = ekranSize
          ..position = ekranPos;

    add(tloFixComponent);

    wilkComponent = WilkComponent()
      ..position = ekranPos
      ..size = Vector2(100, 200); //ekranSize ;// Vector2(0, 50);
    add(wilkComponent);

    var style = const TextStyle(
        color: Colors.black,
        fontSize: 100,
        fontFamily: 'digits',
        fontWeight: FontWeight.w900);
    final regular = TextPaint(style: style);
    punktyTextComponent =
        TextComponent(text: '000000', priority: 10, textRenderer: regular)
          ..anchor = Anchor.topCenter
          ..x = 1500
          ..y = 450;

    skuchaComponent = SkuchaComponent();
    add(skuchaComponent);

    add(punktyTextComponent);
    tloComponent = TloComponent()
      ..size = tloFixComponent.size
      ..position = tloFixComponent.position;
    add(tloComponent);

    obudowaComponent = ObudowaComponent(); //..size=ekranSize;
    add(obudowaComponent);

    cameraComponent.follow(obudowaComponent);

    buttonLD = ButtonComponent()
      ..position = Vector2(118, 470)
      ..size = Vector2(120, 120);
    // add(buttonLD);
    // overlays.add('ButtonController');

    timer = Timer(
      calcCzestotliwoscJaj(),
      onTick: () {
        var rand = Random().nextInt(typGry);
        add(Jajo(calcSpeedJaj(), typJajo: Typ.values[rand]));
      },
      autoStart: false,
      repeat: true,
    );
  }

  @override
  void onGameResize(Vector2 size) {
    // TODO: implement onGameResize
    //ekranSize=size;
    super.onGameResize(size);
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer.update(dt);
  }

  double calcSpeedJaj() {
    double r = 1 - level * 0.005;
    if (r < 0.07) {
      r = 0.070;
    }
    return r;
  }
  double calcCzestotliwoscJaj() {
    double r = 2.5 - level * 0.01;
    if (r < 0.3) {
      r = 0.30;
    }
    return r;
  }

  prepareNowaGra(int i) {
    pauseEngine();
    overlays.add('NewGameOverlay');
  }

  nowaGra() {
    resumeEngine();
    //  overlays.remove('NewGameOverlay');
    //print("Start nowej gry");
    level = 1;
    nextLvlUp = 5;
    punkty = 0;
    skucha = 0;
    skuchaComponent.setSkucha(skucha);

    gameState = GameState.game;
    timer.limit=calcCzestotliwoscJaj();
    timer.start();

    add(Jajo(calcSpeedJaj()));
  }

  gameIdle() {
    gameState = GameState.idle;
  }

  gameOver() {
    gameState = GameState.gameOver;
    timer.stop();
    pauseEngine();
    overlays.add("GameOverOverlay");
  }

  gamePause() {
    gameState = GameState.pause;
    pauseEngine();
    overlays.add('PauseGameOverlay');
    //timer.pause();
  }

  gameResume() {
    gameState = GameState.game;
    resumeEngine();
    // timer.resume();
  }

  addjajoSkucha() {
    skucha++;
    skuchaComponent.setSkucha(skucha);
    //print("skucha: $skucha");
    if (skucha >= 2) {
      //TODO: bonus punkt!!
     gameOver();
    }
  }

  addPunkt() {
    if (gameState != GameState.game) {
      return;
    }
    punkty++;
    punktyTextComponent.text = punkty.toString().padLeft(6, '0');
    if (punkty == nextLvlUp) {
      //print("leelUp");
      level++;
      //nextLvlUp *= 2;
      nextLvlUp += 5;
      timer.limit = calcCzestotliwoscJaj();
      print("lvl: $level,  ${timer.limit}, predkJaj: ${calcSpeedJaj()}");
    }
    
    //nowaGra();
  }

  buttonKlik(int i) {
    switch (gameState) {
      case GameState.game:
        gamePause();
        break;
      case GameState.idle:
        if (i == 4 || i == 5) {
          typGry = i == 4 ? 4 : 3;
          prepareNowaGra(i);
        }
        break;
      case GameState.pause:
        gameResume();
        break;
      default: //,extraLife,gameOver,pause}
        break;
    }
  }

  @override
  void onRemove() {
    timer.stop();
    super.onRemove();
  }
}
