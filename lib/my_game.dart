import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:nu_pogodi/actors/jajo.dart';
import 'package:nu_pogodi/actors/wilk.dart';
import 'package:nu_pogodi/world/button.dart';
import 'package:nu_pogodi/world/obudowa_component.dart';
import 'package:nu_pogodi/world/skucha_component.dart';
import 'package:nu_pogodi/world/tlo_comonent.dart';
import 'package:shared_preferences/shared_preferences.dart';
enum GameState { idle, game, extraLife, gameOver, pause }

enum TypGry {gameA,gameB}

class MyGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  double chickenScaleFactor = 3.0;

  int skucha = 0;
  int punkty = 0;
  int level = 1;
  int nextLvlUp = 5;
  TypGry typGry = TypGry.gameA;

  int highScoreA=0;
  String highScoreNameA="";
  int highScoreB=0;
  String highScoreNameB="";
  bool isAudio=false;

  final String highScoreATag="A";
  final String highScoreBTag="B";

  final String highScoreNameATag="Aname";
  final String highScoreNameBTag="Bname";
  final String isAudioTag="isAudio"; //TODO obsluga audio

 late SharedPreferences prefs;

  GameState gameState = GameState.idle;

  late Timer timer;

  late WilkComponent wilkComponent;
  late RectangleComponent tloPodwietlenie;
  //late final JoystickComponent joystick;
  late ObudowaComponent obudowaComponent;
  late SpriteComponent tloFixComponent;
  late TloComponent tloComponent;

  late TextComponent punktyTextComponent;
  late TextComponent gameModeTextComponent;
  late SkuchaComponent skuchaComponent;

  late ButtonComponent buttonLD;

  Vector2 ekranSize = Vector2(1285, 845);
  Vector2 ekranPos = Vector2(665, 370);

  bool isGameModeComponentVisible=true;

  int charlieEnergy = 0;

  final world = World();
  late final CameraComponent cameraComponent;
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    prefs = await SharedPreferences.getInstance();

    highScoreA= prefs.getInt(highScoreATag)??0;
    highScoreB= prefs.getInt(highScoreBTag)??0;

    highScoreNameA= prefs.getString(highScoreNameATag)??"unknown";
    highScoreNameB= prefs.getString(highScoreNameBTag)??"unknown";

    isAudio =  prefs.getBool(isAudioTag)??true;

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
    var style2 = const TextStyle(
        color: Colors.black,
        fontSize: 40,
        fontFamily: 'digits',
        fontWeight: FontWeight.w900);
    final regular2 = TextPaint(style: style2);
    punktyTextComponent =
        TextComponent(text: '000000', priority: 10, textRenderer: regular)
          ..anchor = Anchor.topCenter
          ..x = 1500
          ..y = 450;

    gameModeTextComponent =
     TextComponent(text: "D E M O", priority: 10, textRenderer: regular2)
          ..anchor = Anchor.topCenter
          ..x = 1500
          ..y = 650;
    
    setGameModeText();


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

    // buttonLD = ButtonComponent()
    //   ..position = Vector2(118, 470)
    //   ..size = Vector2(120, 120);
 

    timer = Timer(
      calcCzestotliwoscJaj(),
      onTick: () {
        var rand = Random().nextInt(typGry==TypGry.gameA?4:3);
        add(Jajo(calcSpeedJaj(), typJajo: Typ.values[rand]));
        if(gameState==GameState.idle){
          int popPoz=wilkComponent.pozycja;
          int r=Random().nextInt(4);
          while(r==popPoz){r=Random().nextInt(4);}
          wilkComponent.setPozycjaWilka(r);

          setGameModeTextVisible(isGameModeComponentVisible);
          isGameModeComponentVisible=!isGameModeComponentVisible;     
          
        }
      },
      autoStart: true,
      repeat: true,
    );
    children.register<Jajo>();
    gameIdle();
  }

  setGameModeTextVisible(bool v)
  {
    if(isGameModeComponentVisible)
          {
            add(gameModeTextComponent);
          }else
          {
            remove(gameModeTextComponent);
          }
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

  prepareNowaGra() {
    pauseEngine();
    overlays.add('NewGameOverlay');
  }

  nowaGra() {
    
    children.query<Jajo>().forEach((element) {remove(element);});
   // print(jaja.length);
    resumeEngine();
    //  overlays.remove('NewGameOverlay');
    //print("Start nowej gry");
    level = 1;
    nextLvlUp = 5;
    
    setPunkty(0);
    skucha = 0;
    skuchaComponent.setSkucha(skucha);

    gameState = GameState.game;
    setGameModeText();
    timer.limit=calcCzestotliwoscJaj();
    //timer.start();

    add(Jajo(calcSpeedJaj()));
  }

  setGameModeText()
  {
    switch(gameState)
    {
      case GameState.idle:
      isGameModeComponentVisible=true;
      gameModeTextComponent.text="D E M O";
      
      gameModeTextComponent.position=Vector2(1200, 600);

        break;
      case GameState.game:
      if(typGry==TypGry.gameA)
      {
        isGameModeComponentVisible=true;
        gameModeTextComponent.text="Mode A";
        gameModeTextComponent.position=Vector2(850, 1120);
      }else{
        isGameModeComponentVisible=true;
        gameModeTextComponent.text="Mode B";
        gameModeTextComponent.position=Vector2(1800, 1120);
      }
      break;
      default:
        gameModeTextComponent.text="";
      break;
    }
    
  }
  gameIdle() {
    
    gameState = GameState.idle;
    resumeEngine();
    setGameModeText();
  
    level=250;
    timer.limit = calcCzestotliwoscJaj();
  }

  saveHighScoreA(int pkt,String name)
  {
    highScoreA=pkt;
    prefs.setInt(highScoreATag,pkt);
    prefs.setString(highScoreNameATag,name);
  }
  saveHighScoreB(int pkt,String name)
  {
    highScoreB=pkt;
    prefs.setInt(highScoreBTag,pkt);
    prefs.setString(highScoreNameBTag,name);
  }
  saveAudioSettings(bool isActive)
  {
    isAudio=isActive;
    prefs.setBool(isAudioTag, isAudio);
  }

  gameOver() {
    
    gameState = GameState.gameOver;
    setGameModeText();
   // timer.stop();
    pauseEngine();
    if(typGry==TypGry.gameA)
    { // game A
      if(punkty>highScoreA)
      {
       overlays.add("GameOverHighScoreOverlay");
      }else { overlays.add("GameOverOverlay");}
    }else
    { // game B
    if(punkty>highScoreB)
      {
       overlays.add("GameOverHighScoreOverlay");
      }else { overlays.add("GameOverOverlay");}
    }
    
  }

  gamePause() {
   
    gameState = GameState.pause;
    pauseEngine();
    overlays.add('PauseGameOverlay');
    setGameModeText();
  }

  gameResume() {
    
    gameState = GameState.game;
    resumeEngine();
  setGameModeText();
  }

  addjajoSkucha() {
     if (gameState != GameState.game) {
      return;
    }
    skucha++;
    skuchaComponent.setSkucha(skucha);
    //print("skucha: $skucha");
    if (skucha >=3 ) {
      //TODO: bonus punkt!!
     gameOver();
    }
  }
  setPunkty(int p)
  {
    punkty=p;
    punktyTextComponent.text = p.toString().padLeft(6, '0');
  }
  addPunkt() {
    if (gameState != GameState.game) {
      return;
    }
    setPunkty(++punkty);
    
    if (punkty == nextLvlUp) {
      //print("leelUp");
      level++;
      //nextLvlUp *= 2;
      nextLvlUp += 5;
      timer.limit = calcCzestotliwoscJaj();
     // print("lvl: $level,  ${timer.limit}, predkJaj: ${calcSpeedJaj()}");
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
          typGry = i == 4 ? TypGry.gameA : TypGry.gameB;
          prepareNowaGra();
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
