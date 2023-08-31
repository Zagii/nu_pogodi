import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:nu_pogodi/actors/wilk.dart';
import 'package:nu_pogodi/my_game.dart';

enum Typ { lewaGora, lewaDol, prawaGora, prawaDol }

class Jajo extends SpriteComponent with CollisionCallbacks, HasGameRef<MyGame> {
  Jajo(double speedJajo, {Typ typJajo = Typ.lewaDol}) //: super(priority: 2)
  {
    speed = speedJajo;

    typ = typJajo;
    // print("jajo speed: $speed");
  }
  final pozycjaStartu = [
    Vector2(780, 600),
    Vector2(780, 790),
    Vector2(1780, 590),
    Vector2(1780, 780),
  ];

  Typ typ = Typ.lewaGora;
  // late SpriteAnimation jajoAnimation;
  late SpriteSheet spriteSheetJajo;
  late Sprite spriteSkorupka;
  late SpriteSheet spriteSheetKurczak;

  Vector2 jajoSize = Vector2(96, 128) * 5 / 6;
  Vector2 skorupkaSize = Vector2(311, 148) * 2 / 3;
  Vector2 piskleSize = Vector2(148, 247) * 2 / 3;

  int spirteIndex = 0;
  double speed = .5;

  double lastUpdate = 0;
  bool czyStluczone = false;
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    switch (typ) {
      case Typ.lewaGora:
        spriteSheetJajo = SpriteSheet.fromColumnsAndRows(
            image: await gameRef.images.load('jajoLG.png'),
            columns: 5,
            rows: 1);

        spriteSheetKurczak = SpriteSheet.fromColumnsAndRows(
            image: await gameRef.images.load('kurczakL.png'),
            columns: 4,
            rows: 1);
        spriteSkorupka = await Sprite.load("skorupkiL.png");
        break;
      case Typ.lewaDol:
        spriteSheetJajo = SpriteSheet.fromColumnsAndRows(
            image: await gameRef.images.load('jajoLD.png'),
            columns: 5,
            rows: 1);

        spriteSheetKurczak = SpriteSheet.fromColumnsAndRows(
            image: await gameRef.images.load('kurczakL.png'),
            columns: 4,
            rows: 1);
        spriteSkorupka = await Sprite.load("skorupkiL.png");
        break;
      case Typ.prawaGora:
        spriteSheetJajo = SpriteSheet.fromColumnsAndRows(
            image: await gameRef.images.load('jajoPG.png'),
            columns: 5,
            rows: 1);

        spriteSheetKurczak = SpriteSheet.fromColumnsAndRows(
            image: await gameRef.images.load('kurczakP_166.png'),
            columns: 4,
            rows: 1);
        spriteSkorupka = await Sprite.load("skorupkiP.png");
        break;
      case Typ.prawaDol:
        spriteSheetJajo = SpriteSheet.fromColumnsAndRows(
            image: await gameRef.images.load('jajoPD.png'),
            columns: 5,
            rows: 1);

        spriteSheetKurczak = SpriteSheet.fromColumnsAndRows(
            image: await gameRef.images.load('kurczakP_166.png'),
            columns: 4,
            rows: 1);
        spriteSkorupka = await Sprite.load("skorupkiP.png");
        break;
    }
    sprite = spriteSheetJajo.getSpriteById(spirteIndex);
    size = jajoSize;

    skorupkaSize = (typ == Typ.lewaDol || typ == Typ.lewaGora)
        ? Vector2(311, 148) * 2 / 3
        : Vector2(329, 143) * 2 / 3;
    piskleSize = (typ == Typ.lewaDol || typ == Typ.lewaGora)
        ? Vector2(148, 247) * 2 / 3
        : Vector2(166, 247) * 2 / 3;

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
    late Sprite r;
    spirteIndex++;
    if (spirteIndex < 5) {
      r = spriteSheetJajo.getSpriteById(spirteIndex);
      size = jajoSize;
    }
    if (spirteIndex == 5) {
      r = spriteSheetJajo.getSpriteById(0);
      size = jajoSize;
    }
    if (spirteIndex == 6) {
      r = spriteSkorupka;
      size = skorupkaSize;
    }
    if (spirteIndex > 6) {
      r = spriteSheetKurczak.getSpriteById(spirteIndex - 7);
      size = piskleSize;
    }

    return r;
  }

  double sum = 0;
  @override
  void update(double dt) {
    super.update(dt);
    ///speed = 1.0;

    sum += dt;
    if (sum < speed) {
      return;
    }
    sum = 0;

    sprite = getNextSprite();
    position.y += 23;
    int znak = (typ == Typ.lewaGora || typ == Typ.lewaDol) ? 1 : -1;

    if (!czyStluczone) { // jesli nie stluczone
      if (spirteIndex > 5) { // rozbicie skorupki
       
        position.x = (typ == Typ.lewaGora || typ == Typ.lewaDol)? 930 : 1500;
        position.y = 1030;
        czyStluczone = true;
        gameRef.addjajoSkucha();
      } else { //turlanie
        position.x += 40 * znak;
      }
    } else { // stluczone
      if(spirteIndex==7)
      {position.x = (typ == Typ.lewaGora || typ == Typ.lewaDol)? 930 : 1580;}
      position.x -= 50 * znak;
      position.y = 970;
      if (spirteIndex >= 12) {
        removeFromParent();
      }
    }

  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is WilkKolizaComponent) {
     // print("wilk");
      gameRef.addPunkt();
      removeFromParent();
    }
  }
}
