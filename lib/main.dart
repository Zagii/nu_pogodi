import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:nu_pogodi/actors/jajo.dart';
import 'package:nu_pogodi/world/button.dart';

import 'actors/wilk.dart';
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
           }
         },
      ),
    ),
  ));

  //final game = FlameGame();
  //runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  double chickenScaleFactor = 3.0;



  late WilkComponent wilkComponent;
  late RectangleComponent tloPodwietlenie;
  //late final JoystickComponent joystick;
  late ObudowaComponent obudowaComponent;
  late SpriteComponent tloFixComponent;
  late TloComponent tloComponent;

  late ButtonComponent buttonLD;

  Vector2 ekranSize= Vector2(1285,845);
  Vector2 ekranPos=Vector2(665, 370);

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
     camera.viewport = FixedResolutionViewport(Vector2(2611,1579));
    //  camera.viewport = FixedResolutionViewport(Vector2.all(maxSide));

   

    tloPodwietlenie = RectangleComponent(size:ekranSize ,position: ekranPos,paint: Paint()..color = Colors.white.withOpacity(1.0));
    add(tloPodwietlenie);
   
   debugMode = true;
    tloFixComponent = SpriteComponent.fromImage(await images.load('fix.png'))
      ..size =ekranSize
      ..position = ekranPos;
      
    add(tloFixComponent);

    wilkComponent = WilkComponent()..position =ekranPos
    ..size=Vector2(100,200);//ekranSize ;// Vector2(0, 50);
    add(wilkComponent);

    tloComponent = TloComponent()
          ..size = tloFixComponent.size
      ..position = tloFixComponent.position;
    add(tloComponent);

    obudowaComponent=ObudowaComponent();//..size=ekranSize;
    add(obudowaComponent);

cameraComponent.follow(obudowaComponent);

    debugMode=true;
    buttonLD = ButtonComponent()..position=Vector2(118, 470)..size=Vector2(120, 120);
   // add(buttonLD);
  overlays.add('ButtonController');

  add(Jajo());

  }

@override
  void onGameResize(Vector2 size) {
    // TODO: implement onGameResize
    //ekranSize=size;
    super.onGameResize(size);
  }

}

class ObudowaComponent extends SpriteComponent with TapCallbacks, HasGameRef<MyGame>{
 

  late Vector2 parentSize;

  List<Vector2> buttonsPoz =[
    Vector2(200,954),
    Vector2(200,1221),
    Vector2(2200,954),
    Vector2(2200,1221),
  ];

  List<Rect>buttonsRect=[
    const Rect.fromLTWH(130,900,300,300),
    const Rect.fromLTWH(130,1200,300,300),
    const Rect.fromLTWH(2110,930,300,300),
    const Rect.fromLTWH(2110,1200,300,300),
  ];

  List<bool>buttonPressed = [false,false,false,false];

  late Sprite pressedSprite;
  late Sprite unpressedSprite;

 @override
 FutureOr<void> onLoad() async{
    // TODO: implement onLoad
    parentSize=size;
 // final Image img = await images.load('obudowa.png');
    sprite =await Sprite.load('obudowa.png');
    pressedSprite = await gameRef.loadSprite('BtnDown.png');
    unpressedSprite = await gameRef.loadSprite('BtnUp.png');



  return super.onLoad();
  }
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    for(int i=0;i<4;i++)
    {
      if(buttonPressed[i])
      {
        pressedSprite.render(canvas,position: buttonsPoz[i]);
      }else{
        unpressedSprite.render(canvas,position: buttonsPoz[i]);
      }
    }
  }

  @override
  void onParentResize(Vector2 maxSize) {
    // TODO: implement onParentResize
   // print(maxSize.toString());
    parentSize=maxSize;
    super.onParentResize(maxSize);
  }

  //pobiera w parametrze punkt z ekranu i przelicza go na wspólrzedne viewportu dla fixed resolution
  Vector2 ekranToPicturePoint(Vector2 ekranPoint)
  {
 //var p =event.localPosition;
   //  print("Player tap down on ${event.localPosition.toString()}, ${event.canvasPosition.toString()}, ${event.devicePosition.toString()}");
    var myRatio=size[0]/size[1];
    //print("size: ${size.toString()}, ratio: ${myRatio}");
    var parentRatio=parentSize[0]/parentSize[1];
    //print("parentSize: ${parentSize.toString()}, ratio: ${parentSize[0]/parentSize[1]}");

    Vector2 rozmiarObrazka=Vector2(parentSize.x, parentSize.y);
 //   Vector2 klikEkranu = ekranPoint; //event.localPosition;
    Vector2 dif=Vector2(0, 0);
    
    if(myRatio>parentRatio)//za duze w pionie
    {
      
      //czyli y ma czarne pole wiec 
      rozmiarObrazka.y=parentSize.x/myRatio;
      dif.y=parentSize.y-rozmiarObrazka.y;
      
    //  print('tmpY: $tmpY');

    }else{
      //za duze w poziomie
        //var tmpX
        rozmiarObrazka.x=parentSize.y*myRatio;
        dif.x=parentSize.x-rozmiarObrazka.x;
        
    //  print('tmpX: $tmpX');
    }

    
    
   // Vector2 k = Vector2(event.localPosition.x*size[0]/parentSize[0],event.localPosition.y*size[1]/parentSize[1]);
    
    Vector2 klik=ekranPoint-dif/2;
  //  print("klikEkranu x= ${klikEkranu.x.round().toString()}, y= ${klikEkranu.y.round().toString()}");
  //   print("rozmiarObrazka x= ${rozmiarObrazka.x.round().toString()}, y= ${rozmiarObrazka.y.round().toString()}");
   //  print("dif: x= ${dif.x.round().toString()}, y= ${dif.y.round().toString()}");
   // print("Klik: x= ${klik.x.round().toString()}, y= ${klik.y.round().toString()}");

    var mnoznik = size.x/rozmiarObrazka.x;
    Vector2 klikOryg=klik*mnoznik;
  // print("KlikOryg: x= ${klikOryg.x.round().toString()}, y= ${klikOryg.y.round().toString()}");

    return klikOryg;
  }
   @override
  bool onTapDown(TapDownEvent event) {
   
   Vector2 klik=ekranToPicturePoint(event.localPosition);
   for(int i=0;i<4;i++)
    {
      if(buttonsRect[i].contains(klik.toOffset())){
        buttonPressed[i]=true;
        gameRef.wilkComponent.setPozycjaWilka(i);
      }else{
        buttonPressed[i]=false;
      }
    }

     super.onTapDown(event);
    return true;
  }
     @override
  bool onTapUp(TapUpEvent event) {
   
   Vector2 klik=ekranToPicturePoint(event.localPosition);
   for(int i=0;i<4;i++)
    {
      if(buttonsRect[i].contains(klik.toOffset())){
        buttonPressed[i]=false;
      }
    }
    print(klik.toString());
     super.onTapUp(event);
    return true;
  }
}

class TloComponent extends PositionComponent {
  late Sprite tloPrzod;

  @override
  FutureOr<void> onLoad() async {
    tloPrzod = await Sprite.load('szklo.png');
  }

  @override
  render(Canvas canvas) {
    super.render(canvas);
    ///var rect = const Rect.fromLTWH(100, 100, 202, 220);
   // Paint opacityPaint = Paint()..color = Colors.white.withOpacity(0.7);
    

    // tloPrzod.render(canvas);
    tloPrzod.render(
      canvas,
      size:size,
    //  position: position,
    //  overridePaint: opacityPaint,
    );
  }
}
