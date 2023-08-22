import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:nu_pogodi/actors/jajo.dart';
import 'package:nu_pogodi/main.dart';

class WilkComponent extends PositionComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  final lg = 0;
  final ld = 1;
  final pg = 2;
  final pd = 3;
  final wilkL = 4;
  final wilkP = 5;

  late SpriteComponent rekaComponent;
  late SpriteComponent wilkComponent;
  late RectangleHitbox hitbox;

late WilkKolizaComponent wilkKolizjaComponent;

  late int pozycja;
  List<MojSprite> spriteList = [];

  var skalaWilka = 0.6;
  var skalaLap = 0.6;

  @override
  FutureOr<void> onLoad() async {
    debugMode = true;
    pozycja = 0;
    spriteList.add(MojSprite(await Sprite.load('lewyGora.png'),
        Vector2(320, 340), Vector2(300, 300) * skalaLap));
    spriteList.add(MojSprite(await Sprite.load('lewyDol.png'),
        Vector2(300, 510), Vector2(350, 300) * skalaLap));
    spriteList.add(MojSprite(await Sprite.load('prawyGora.png'),
        Vector2(810, 365), Vector2(300, 300) * skalaLap));
    spriteList.add(MojSprite(await Sprite.load('prawyDol.png'),
        Vector2(795, 520), Vector2(300, 300) * skalaLap));
    spriteList.add(MojSprite(await Sprite.load('wilkLewy.png'),
        Vector2(430, 340), Vector2(400, 630) * skalaWilka));
    spriteList.add(MojSprite(await Sprite.load('wilkPrawy.png'),
        Vector2(640, 340), Vector2(365, 630) * skalaWilka));

    wilkKolizjaComponent=WilkKolizaComponent()..position=spriteList[pozycja].pozycja..size=Vector2(150,150);
    add(wilkKolizjaComponent);
    //add(RectangleHitbox().re..position=Vector2(330,300)..size=Vector2(300,400));
    print("wilkOnLoad comple");
    return super.onLoad();
  }

  @override
  render(Canvas canvas) {
    super.render(canvas);

    for (int i = 0; i < 4; i++) {
      if (pozycja == i) {
        spriteList[i].sprite.render(canvas,
            size: spriteList[i].rozmiar, position: spriteList[i].pozycja);
      }
    }

    if (pozycja == lg || pozycja == ld) {
      spriteList[wilkL].sprite.render(canvas,
          size: spriteList[wilkL].rozmiar, position: spriteList[wilkL].pozycja);
    } else {
      spriteList[wilkP].sprite.render(canvas,
          size: spriteList[wilkP].rozmiar, position: spriteList[wilkP].pozycja);
    }
  }

  @override
  update(double dt) {}
  setPozycjaWilka(int _pozycja) {
    pozycja = _pozycja;
    for (int i = 0; i < 4; i++) {
      if (pozycja == i) {
        wilkKolizjaComponent.position=spriteList[i].pozycja;
        
      }
    }
  }

  startGame() {
    pozycja = pg;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Jajo) {
      print("jajo kolizja");
    }
  }
}

class MojSprite {
  final Sprite sprite;
  final Vector2 pozycja;
  final Vector2 rozmiar;

  MojSprite(this.sprite, this.pozycja, this.rozmiar);
}

class WilkKolizaComponent extends PositionComponent
    with CollisionCallbacks, HasGameRef<MyGame> {


  @override
  FutureOr<void> onLoad() async {
    debugMode = true;
    RectangleHitbox hitbox = RectangleHitbox();


    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Jajo) {
      print("jajo kolizja");
    }
  }
}
