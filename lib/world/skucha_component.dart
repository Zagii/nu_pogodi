import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';

class SkuchaComponent extends PositionComponent {
  SkuchaComponent(): super(priority: 10);
  late Sprite skuchaSprite;

  int piskleSzt=0;
  @override
  FutureOr<void> onLoad() async {
    skuchaSprite = await Sprite.load('piskle.png');
  }
  setSkucha(int i)
  {
    piskleSzt=i;
  }
  @override
  void render(Canvas canvas) {
    super.render(canvas);

  if(piskleSzt>0)
  {
    skuchaSprite.render(canvas,size:Vector2.all(100),
    position:Vector2(1480, 580));
  }

  if(piskleSzt>1)
  {
    skuchaSprite.render(canvas,size:Vector2.all(100),
    position:Vector2(1380, 580));
  }
  if(piskleSzt>2)
  {
    skuchaSprite.render(canvas,size:Vector2.all(100),
    position:Vector2(1280, 580));
  }


  }
}