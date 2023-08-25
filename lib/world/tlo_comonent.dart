import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';

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

