import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:nu_pogodi/actors/wilk.dart';
import 'package:nu_pogodi/main.dart';

enum Typ { lewaGora, lewaDol, prawaGora, prawaDol }

class Jajo extends SpriteComponent with CollisionCallbacks, HasGameRef<MyGame> {
  final pozycjaStartu = [
    Vector2(750, 570),
  ];

  Typ typ = Typ.lewaGora;
  // late SpriteAnimation jajoAnimation;
  late SpriteSheet spriteSheet;
  int spirteIndex = 0;
  double speed = .5;

  double lastUpdate = 0;
  bool czyStluczone = false;
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    //final spriteSheet = SpriteAnimation.

    // jajoAnimation =
    //     spriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 4);

    spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: await gameRef.images.load('jajoLG.png'), columns: 5, rows: 1);
    // jajoAnimation =
    //     spriteSheet.createAnimation(row: 0, stepTime: speed, from: 0, to: 5);

    sprite = spriteSheet.getSpriteById(spirteIndex);

    add(
      RectangleHitbox(
        size: size, //Vector2.all(300),
        anchor: Anchor.center,
        position: size / 2,
      ),
    );

    position = pozycjaStartu[typ.index];
  }

  Sprite getNextSprite() {
    spirteIndex++;
    if (spirteIndex < 5) {
      return spriteSheet.getSpriteById(spirteIndex);
    }
    return spriteSheet.getSpriteById(0);
  }

  double sum = 0;
  @override
  void update(double dt) {
    super.update(dt);
    speed = 1.0;

    sum += dt;
    if (sum < speed) {
      return;
    }
    sum = 0;

    sprite = getNextSprite();
    position.y += 23;
    if (typ == Typ.lewaGora || typ == Typ.lewaDol) {
      if (!czyStluczone) {
        
        if (spirteIndex>5) {
          position.y = 1000;
          czyStluczone = true;
        }else{
        position.x += 40;}
      }else
      {
        position.x-=40;
        position.y = 1000;
        if(position.x<700)
        {
          czyStluczone=false;
          position = pozycjaStartu[typ.index];
          spirteIndex = 0;
        }
      }
    } else {
      position.x -= 30;
    }

    // if (position.y >= 850) {
    //   position = pozycjaStartu[typ.index];
    //   spirteIndex = 0;
    // }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is WilkComponent) {
      print("wilk");
    }
  }
}
