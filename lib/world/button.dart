import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:nu_pogodi/my_game.dart';

class ButtonComponent extends PositionComponent//<ButtonState>
    with HasGameRef<MyGame>, TapCallbacks {
//  ButtonComponent(Vector2 position): super(
//       position: position, 
//       size: Vector2(310, 310), 
//       anchor: Anchor.topLeft,
//     );
  late Rect _rect;
  late Sprite pressedSprite;
  late Sprite unpressedSprite;

bool isPressed=false;

  @override
  Future<void>? onLoad() async {

    
    pressedSprite = await gameRef.loadSprite('BtnDown.png');
    _rect=const Rect.fromLTWH(100,100, 100,100 );
    unpressedSprite = await gameRef.loadSprite('BtnUp.png');
//sprite=pressedSprite;
  //    sprites = {
  //     ButtonState.down: pressedSprite,
  //     ButtonState.up:unpressedSprite
  // //     ButtonState.unpressed: unpressedSprite,
  //    };

   //  current = ButtonState.up;
  super.onLoad();
  }
    @override
  bool containsLocalPoint(Vector2 point) => _rect.contains(point.toOffset());

  @override
  void render(Canvas canvas) {

    _rect=Rect.fromLTWH(0,0,size[0],size[1]);
   // canvas.drawRect(_rect, Paint()..color=Colors.black..style=PaintingStyle.stroke);

    if(isPressed){pressedSprite.render(canvas,size: size);}
    else {unpressedSprite.render(canvas,size: size);}

    super.render(canvas);
  }
  @override
  bool onTapDown(TapDownEvent event) {
  
   isPressed=true;
    
     super.onTapDown(event);
    return true;
  }
  @override
  bool onTapUp(TapUpEvent event) {
   
    super.onTapUp(event);
    isPressed=false;
     return true;
  }
  // tap methods handler omitted...
}