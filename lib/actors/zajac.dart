import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:nu_pogodi/my_game.dart';

class Zajac extends SpriteComponent with  HasGameRef<MyGame> {

  Zajac(int czasWidocznosci,bool czyDzwonkiAnimowac)
  {
    czas=czasWidocznosci;
    czyDzwonki=czyDzwonkiAnimowac;
  }

  late SpriteSheet dzwonkiSheet;

  late Sprite zajacSprite;
  int czas=0;
  int sumCzas=0;

  int spriteId=0;
  late Timer timer;

  bool czyDzwonki=false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

        zajacSprite = Sprite(await gameRef.images.load('zajac.png'));
   
        dzwonkiSheet = SpriteSheet.fromColumnsAndRows(
            image: await gameRef.images.load('dzwonki.png'),
            columns: 1,
            rows: 2);

      sprite = zajacSprite;
      size = Vector2.all(220);
      position=Vector2(870, 420);

      timer = Timer(
      0.7,
      onTick: () {
        spriteId= spriteId == 0? 1:0;
     // print("timer");
        sumCzas++;
       // czyDzwonki=!czyDzwonki;
        if(czas<=sumCzas)
        {
          removeFromParent();
        }
      },
      autoStart: true,
      repeat: true,
    );
    timer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer.update(dt);
  }

  @override
  void render(Canvas canvas) {
    
    if(czyDzwonki)
    {
      dzwonkiSheet.getSpriteById(spriteId).render(canvas, position:spriteId==0? Vector2(190, 0):Vector2(190, 120),size:Vector2.all(150));
    }

    super.render(canvas);
  }

  @override
  void onRemove() {
    timer.stop();
    super.onRemove();
  }
}
