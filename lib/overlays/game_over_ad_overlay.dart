import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nu_pogodi/ad_helper.dart';
import 'package:nu_pogodi/my_game.dart';



class GameOverAdOverlayComponent extends StatefulWidget {
   GameOverAdOverlayComponent({super.key, required this.game});
    
  final MyGame game;

  
  @override
  State<GameOverAdOverlayComponent> createState() => _GameOverAdOverlayComponentState();
}

class _GameOverAdOverlayComponentState extends State<GameOverAdOverlayComponent> {
   RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
       _loadRewardedAd();
  }
 void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 69, 65, 65).withAlpha(180),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
              top: 10,
              //  left: 0,
              child: Container(
                  width: 300,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/images/tytul.png'),
                      fit: BoxFit.cover,
                    ),
                  ))),
          const Positioned(
              top: 50,
              //  left: 0,
              child: Text("Continue..?",
                  style: TextStyle(
                      fontFamily: 'niceTango',
                      fontSize: 30,
                      color: Color.fromARGB(255, 48, 132, 44)))),
          Positioned(
              top: 100,
              //  left: 0,
              child: Container(
                  width: 400,
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/images/dialog.png'),
                      fit: BoxFit.fill,
                    ),
                  ))),
          Positioned(
              top: 120,
              left: 250,
              child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/images/zajacOkno.png'),
                      fit: BoxFit.fill,
                    ),
                  ))),
          const Positioned(
              top: 150,
              //left: 0,
              // width: 300,
              child: Text("Want more...?",
                  style:  TextStyle(
                      fontFamily: 'niceTango',
                      fontSize: 25,
                      color: Color.fromARGB(255, 48, 132, 44)))),
           Positioned(
              top: 190,
              //left: 0,
               //width: 500,
              child: Row(
                children: [
                 const SizedBox(
                    width:130,
                    child: Text("Watch video to get bonus",
                        style:  TextStyle(
                            fontFamily: 'niceTango',
                            fontSize: 20,
                            color: Color.fromARGB(255, 48, 132, 44))),
                  ),
                  FloatingActionButton(
                  heroTag: 'wideoTag',
                  highlightElevation: 50,
                  shape:  const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                    //backgroundColor: Colors.red.withAlpha(100),
                  onPressed: () {
                    _rewardedAd?.show(
                          onUserEarnedReward: (_, reward) {
                            widget.game.startBonusLife();
                          },
                        );
                   
                  },
                  child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: ExactAssetImage('assets/images/ok.png'),
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
                ],
              )),
     
          Positioned(
            top: 290,
            //left: 150,
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: (){
                    widget.game.gameOver();
                  },
                  child: const Text("No, thanks",
                              
                      style: TextStyle(
                        
                          fontFamily: 'niceTango',
                          fontSize: 15,
                          color: Color.fromARGB(255, 101, 22, 30))),
                ),
           
              ],
            ),
          ),
        ],
      ),
    );
  }
}
