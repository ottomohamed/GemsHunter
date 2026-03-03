import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static String bannerId = "ca-app-pub-6500154299593172/3844752216";
  static String interstitialId = "ca-app-pub-6500154299593172/1748383555";
  static String rewardedId = "ca-app-pub-6500154299593172/2667401917";

  static InterstitialAd? interstitialAd;
  static bool isInterstitialLoading = false;

  static void loadInterstitial() {
    if (isInterstitialLoading || interstitialAd != null) return;
    
    isInterstitialLoading = true;
    InterstitialAd.load(
      adUnitId: interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          isInterstitialLoading = false;
          debugPrint("Interstitial Ad Loaded Successfully ✅");
        },
        onAdFailedToLoad: (error) {
          interstitialAd = null;
          isInterstitialLoading = false;
          debugPrint("Interstitial Ad Failed to Load ❌: $error");
        },
      ),
    );
  }

  static void showInterstitial() {
    if (interstitialAd != null) {
      interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          interstitialAd = null;
          loadInterstitial(); // Preload the next one
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          interstitialAd = null;
          loadInterstitial();
        },
      );
      interstitialAd!.show();
    } else {
      debugPrint("Interstitial Ad NOT ready yet! ⏳ Attempting to reload...");
      loadInterstitial();
    }
  }

  // Rewarded Ads Logic
  static RewardedAd? rewardedAd;
  static bool isRewardedLoading = false;

  static void loadRewarded() {
    if (isRewardedLoading || rewardedAd != null) return;
    
    isRewardedLoading = true;
    RewardedAd.load(
      adUnitId: rewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          isRewardedLoading = false;
        },
        onAdFailedToLoad: (error) {
          rewardedAd = null;
          isRewardedLoading = false;
        },
      ),
    );
  }

  static void showRewarded(Function reward) {
    if (rewardedAd != null) {
      rewardedAd!.show(onUserEarnedReward: (ad, rewardItem) {
        reward();
      });
      rewardedAd = null;
      loadRewarded();
    }
  }
}
