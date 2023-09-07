import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
//import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:nu_pogodi/actors/jajo.dart';
import 'package:nu_pogodi/actors/wilk.dart';
import 'package:nu_pogodi/actors/zajac.dart';
import 'package:nu_pogodi/ad_helper.dart';
import 'package:nu_pogodi/world/button.dart';
import 'package:nu_pogodi/world/obudowa_component.dart';
import 'package:nu_pogodi/world/skucha_component.dart';
import 'package:nu_pogodi/world/tlo_comonent.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum GameState { idle, game, extraLife, gameOver, pause,optiosDialog }

enum TypGry { gameA, gameB }
enum AudioPlay { jajoLD,jajoLG,jajoPD,jajoPG,skucha,gameOver,highScore,odliczanie}
class MyGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  int skucha = 0;
  int punkty = 0;
  int level = 1;
  int nextLvlUp = 5;
  TypGry typGry = TypGry.gameA;
  bool isBonusGame = false;

  int highScoreA = 0;
  String highScoreNameA = "";
  int highScoreB = 0;
  String highScoreNameB = "";
  bool isAudio = false;

  final String highScoreATag = "A";
  final String highScoreBTag = "B";

  final String highScoreNameATag = "Aname";
  final String highScoreNameBTag = "Bname";
  final String isAudioTag = "isAudio"; //TODO obsluga audio

  late SharedPreferences prefs;

  GameState gameState = GameState.idle;

  late Timer timerJaj;
  late Timer timerIdle;

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

  bool isGameModeComponentVisible = true;

  late AppLifecycleReactor appLifecycleReactor;

  final world = World();
  late final CameraComponent cameraComponent;

  final audioFiles=['1-mixkit-quick-lock-sound-2854.wav', '2-mixkit-arcade-game-jump-coin-216.wav',
                    '3-mixkit-explainer-video-game-alert-sweep-236.wav', '4-mixkit-retro-game-notification-212.wav',
       /*skucha*/   '5-mixkit-arcade-space-shooter-dead-notification-272.wav',
       /*gameOver*/ '6-mixkit-retro-arcade-game-over-470.wav',
       /*highScore*/'7-mixkit-fairy-arcade-sparkle-866.wav',
       /*odliczanie*/'8-mixkit-race-countdown-1953.wav'];
  
  //List<AudioPool>  audioList=[];
  
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // for(String f in audioFiles)
    // {
    //  // audioList.add(await FlameAudio.createPool(f, maxPlayers: 16));
    // }

    // AdHelper appOpenAdManager = AdHelper()..loadAd();
    // appLifecycleReactor =
    //     AppLifecycleReactor(appOpenAdManager: appOpenAdManager);

    prefs = await SharedPreferences.getInstance();

    highScoreA = prefs.getInt(highScoreATag) ?? 0;
    highScoreB = prefs.getInt(highScoreBTag) ?? 0;

    highScoreNameA = prefs.getString(highScoreNameATag) ?? "unknown";
    highScoreNameB = prefs.getString(highScoreNameBTag) ?? "unknown";

    isAudio = prefs.getBool(isAudioTag) ?? true;

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
          ..anchor = Anchor.topCenter;

    setGameModeText();

    skuchaComponent = SkuchaComponent();
    add(skuchaComponent);

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

    timerJaj = Timer(
      calcCzestotliwoscJaj(),
      onTick: () {
        try{
      //  print("*************tick timer");
        var rand = Random().nextInt(typGry == TypGry.gameA ? 4 : 3);

        add(Jajo(calcSpeedJaj(), typJajo: Typ.values[rand]));
        
       
        }catch(e){
          print("timer exception");
        }
      },
      autoStart: true,
      repeat: true,
    );

    timerIdle=Timer(
      0.5,
     onTick: () {
      if (gameState == GameState.idle) {
          int popPoz = wilkComponent.pozycja;
          int r = Random().nextInt(4);
          while (r == popPoz) {
            r = Random().nextInt(4);
          }
          if(wilkComponent.isLoaded)
          {wilkComponent.setPozycjaWilka(r);}

          setGameModeTextVisible(isGameModeComponentVisible);
          isGameModeComponentVisible = !isGameModeComponentVisible;
          skuchaComponent.setSkucha(Random().nextInt(5));
        }},
         autoStart: true,
      repeat: true,
    );
    children.register<Jajo>();
     children.register<TextComponent>();

    add(Zajac(7, true));
   //
    gameIdle();
  }

  setGameModeTextVisible(bool v) {
    if (isGameModeComponentVisible) {
      if(gameModeTextComponent.parent==null)
       { add(gameModeTextComponent);}
    } else {
      if(gameModeTextComponent.parent!=null)
      {remove(gameModeTextComponent);}
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if(!timerJaj.isRunning()) // nie wiem czemu sie on zatrzymal
    {
      print("wznawiam timerJaj");
      timerJaj.start();
    }
    timerJaj.update(dt);
    if(gameState==GameState.idle){ 
       if(!timerIdle.isRunning())
    {
      print("wznawiam timerIdle");
      timerIdle.start();
    }
      timerIdle.update(dt);
      }
  }

  double calcSpeedJaj() {
    double r = 1 - level * 0.005;
    if (r < 0.07) {
      r = 0.070;
    }
    return r;
  }

  double calcCzestotliwoscJaj() {
    double r = 2.0 - level * 0.01;
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
    children.query<Jajo>().forEach((element) {
      remove(element);
    });
    // print(jaja.length);
    resumeEngine();
    add(punktyTextComponent);

// timer.start();

    level = 1;
    isBonusGame = false;
    nextLvlUp = 2;

    setPunkty(0);
    skucha = 0;
    skuchaComponent.setSkucha(skucha);

    gameState = GameState.game;
    setGameModeText();
    timerJaj.limit = calcCzestotliwoscJaj();

    add(Jajo(calcSpeedJaj()));
  }

  setGameModeText() {
    switch (gameState) {
      case GameState.idle:
        isGameModeComponentVisible = true;
        gameModeTextComponent.text = "D E M O";

        gameModeTextComponent.position = Vector2(1400, 500);

        break;
      case GameState.game:
        if (typGry == TypGry.gameA) {
          isGameModeComponentVisible = true;
          gameModeTextComponent.text = "Mode A";
          gameModeTextComponent.position = Vector2(850, 1120);
        } else {
          isGameModeComponentVisible = true;
          gameModeTextComponent.text = "Mode B";
          gameModeTextComponent.position = Vector2(1800, 1120);
        }
        break;
      default:
        gameModeTextComponent.text = "";
        break;
    }
  }

  gameIdle() {
    // if(children.contains(punktyTextComponent))
    // {remove(punktyTextComponent);}
    gameState = GameState.idle;
    timerIdle.start();
    resumeEngine();
    setGameModeText();

    level = 200;
    timerJaj.limit = calcCzestotliwoscJaj();
  }

  saveHighScoreA(int pkt, String name) {
    highScoreA = pkt;
    prefs.setInt(highScoreATag, pkt);
    prefs.setString(highScoreNameATag, name);
  }

  saveHighScoreB(int pkt, String name) {
    highScoreB = pkt;
    prefs.setInt(highScoreBTag, pkt);
    prefs.setString(highScoreNameBTag, name);
  }

  saveAudioSettings(bool isActive) {
    isAudio = isActive;
    prefs.setBool(isAudioTag, isAudio);
  }

  startBonusLife() {
    overlays.remove('GameOverAdScoreOverlay');
    isBonusGame = true;
    children.query<Jajo>().forEach((element) {
      remove(element);
    });
    // print(jaja.length);
    resumeEngine();
   // children.contains(punktyTextComponent);
    //add(punktyTextComponent);

    level = level>150? 150: level~/2;
    
    nextLvlUp = 2;

    skucha = 2;
    skuchaComponent.setSkucha(skucha);

    setGameModeText();
    timerJaj.limit = calcCzestotliwoscJaj();
    gameResume();
  }

  gameOverAskBonus() {
    gameState = GameState.gameOver;
    setGameModeText();
    pauseEngine();
    overlays.add("GameOverAdScoreOverlay");
  }

  gameOver() {
    gameState = GameState.gameOver;
    setGameModeText();
    // timer.stop();
    pauseEngine();
    if(overlays.isActive('GameOverAdScoreOverlay'))
    {
       overlays.remove('GameOverAdScoreOverlay');
    }
    if (typGry == TypGry.gameA) {
      // game A
      if (punkty > highScoreA) {
        overlays.add("GameOverHighScoreOverlay");
      } else {
        overlays.add("GameOverOverlay");
      }
    } else {
      // game B
      if (punkty > highScoreB) {
        overlays.add("GameOverHighScoreOverlay");
      } else {
        overlays.add("GameOverOverlay");
      }
    }

    //remove(punktyTextComponent);
  }
  late GameState stateBeforeOptions;
  closeOptionsDialog()
  {
    gameState=stateBeforeOptions;
    resumeEngine();
    overlays.remove('OptionsOverlay');
    overlays.remove('BanerOverlay');
      setGameModeText();
  }
 showOptionsDialog() {
  stateBeforeOptions=gameState;
    gameState = GameState.optiosDialog;
    pauseEngine();
    overlays.add('OptionsOverlay');
    setGameModeText();
    overlays.add('BanerOverlay');

 }
  gamePause() {
    gameState = GameState.pause;
    pauseEngine();
    overlays.add('PauseGameOverlay');
    setGameModeText();
    overlays.add('BanerOverlay');
  }

  gameResume() {
    overlays.remove('BanerOverlay');
    gameState = GameState.game;
    resumeEngine();
    setGameModeText();
  }

  addjajoSkucha() {
    if (gameState != GameState.game) {
      return;
    }
    children.query<Jajo>().forEach((element) {
      if (!element.czyStluczone) {
        remove(element);
      }
    });
    skucha++;
    skuchaComponent.setSkucha(skucha);
    //print("skucha: $skucha");
    if (skucha >= 3) {
      //TODO: bonus punkt!!
      if(isBonusGame) {gameOver();}else{gameOverAskBonus();}
    } else {
      add(Zajac(7, true));
    }
  }

  setPunkty(int p) {
    punkty = p;
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
      if (level < 70) {
        nextLvlUp += 1;
      }
      if (level >= 70 && level < 100) {
        nextLvlUp += 2;
      }
      if (level >= 100 && level < 150) {
        nextLvlUp += 4;
      }
      if (level >= 150 && level < 200) {
        nextLvlUp += 8;
      }
      if (level >= 200) {
        nextLvlUp += 10;
      }
      timerJaj.limit = calcCzestotliwoscJaj();
      if (level % 20 == 0) {
        add(Zajac(3, false));
      }
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
    if(i==6)
    {
      showOptionsDialog();
    }
  }

  @override
  void onRemove() {
    timerJaj.stop();
    timerIdle.stop();
    super.onRemove();
  }
  
 
}
