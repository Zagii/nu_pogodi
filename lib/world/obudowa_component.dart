import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/image_composition.dart';
import 'package:nu_pogodi/my_game.dart';


class ObudowaComponent extends SpriteComponent with TapCallbacks, HasGameRef<MyGame>{
 

  late Vector2 parentSize;

  List<Vector2> buttonsPoz =[
    Vector2(200,954),
    Vector2(200,1221),
    Vector2(2200,954),
    Vector2(2200,1221),
    /////// male butony //////
    Vector2(2182,157),
     Vector2(2182,338),
      Vector2(2182,519),
  ];

  List<Rect>buttonsRect=[
    const Rect.fromLTWH(130,900,300,300),
    const Rect.fromLTWH(130,1200,300,300),
    const Rect.fromLTWH(2110,930,300,300),
    const Rect.fromLTWH(2110,1200,300,300),
    const Rect.fromLTWH(2150,150,300,100),
    const Rect.fromLTWH(2150,330,300,100),
    const Rect.fromLTWH(2150,500,300,100),
  ];

  List<bool>buttonPressed = [false,false,false,false,false,false,false];

  late Sprite pressedSprite;
 // late Sprite unpressedSprite;

 late Sprite pressedMalySprite;
  //late Sprite unpressedMalySprite;
 @override
 FutureOr<void> onLoad() async{

    parentSize=size;
 // final Image img = await images.load('obudowa.png');
    sprite =await Sprite.load('obudowa2.png');
    pressedSprite = await gameRef.loadSprite('BtnDown.png');
    //unpressedSprite = await gameRef.loadSprite('BtnUp.png');
    
    pressedMalySprite = await gameRef.loadSprite('BtnDownMaly.png');
    //unpressedSprite = await gameRef.loadSprite('BtnUp.png');


  return super.onLoad();
  }
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    for(int i=0;i<buttonPressed.length;i++)
    {
      if(buttonPressed[i])
      {
        if(i<4)
        { pressedSprite.render(canvas,position: buttonsPoz[i]);}
        else
        {
          pressedMalySprite.render(canvas,position: buttonsPoz[i]);
        }
      }else{
   //     unpressedSprite.render(canvas,position: buttonsPoz[i]);
  //  pressedMalySprite.render(canvas,position: buttonsPoz[i]);
      }
    }
  }

  @override
  void onParentResize(Vector2 maxSize) {
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
   for(int i=0;i<buttonPressed.length;i++)
    {
      if(buttonsRect[i].contains(klik.toOffset())){
        buttonPressed[i]=true;
      if(i<4 && gameRef.gameState==GameState.game){  gameRef.wilkComponent.setPozycjaWilka(i);}else
      { gameRef.buttonKlik(i);
    //  print(i);
       }
      }else{
        buttonPressed[i]=false;
      }
    }

     super.onTapDown(event);
    return true;
  }
  @override
  void onTapCancel(TapCancelEvent event) {
    for(int i=0;i<buttonPressed.length;i++)
    {
       buttonPressed[i]=false;
     }
     //print("tap cancel");
    super.onTapCancel(event);
  }
     @override
  bool onTapUp(TapUpEvent event) {
   
   Vector2 klik=ekranToPicturePoint(event.localPosition);
   for(int i=0;i<buttonPressed.length;i++)
    {
      if(buttonsRect[i].contains(klik.toOffset())){
        buttonPressed[i]=false;
      }
    }
  //  print(klik.toString());
     super.onTapUp(event);
    return true;
  }
}