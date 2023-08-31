import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nu_pogodi/ad_helper.dart';



class BanerOverlayComponent extends StatefulWidget {
  const BanerOverlayComponent({super.key});


  @override
  State<BanerOverlayComponent> createState() => _BanerOverlayComponentState();
}

class _BanerOverlayComponentState extends State<BanerOverlayComponent> {

  BannerAd? _ad1;
  BannerAd? _ad2;
  @override
  void dispose() {
     _ad1?.dispose();
     _ad2?.dispose();
    super.dispose();
  }
 @override
  void initState() {
    super.initState();

    // COMPLETE: Load a banner ad
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId1,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad1 = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          debugPrint(
              'Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    ).load();
        BannerAd(
      adUnitId: AdHelper.bannerAdUnitId2,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad2 = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          debugPrint(
              'Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [       
          Container(
              width: _ad1==null? 0: _ad1!.size.width.toDouble(),
              height: 75.0,
              alignment: Alignment.center,
              child: _ad1==null? const Placeholder() : AdWidget(ad: _ad1!),
            ),
             Container(
              width: _ad2==null? 0: _ad2!.size.width.toDouble(),
              height: 75.0,
              alignment: Alignment.center,
              child: _ad2==null? const Placeholder() : AdWidget(ad: _ad2!),
            ),
        ]);
        
  }
}
