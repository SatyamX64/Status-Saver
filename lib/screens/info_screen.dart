import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';

class InfoScreen extends StatelessWidget {
  static const route = '/info-screen';
  InfoScreen({Key? key}) : super(key: key);
  final InAppReview inAppReview = InAppReview.instance;

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final adaptiveTheme = AdaptiveTheme.of(context);

    Widget _gradientBackground = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: adaptiveTheme.mode == AdaptiveThemeMode.dark
              ? [ColorPalette.darkGradientHigh, ColorPalette.darkGradientLow]
              : [
                  ColorPalette.lightGradientLow,
                  ColorPalette.lightGradientHigh,
                ],
        ),
      ),
      alignment: Alignment.center,
      height: size.height * 0.6,
      child: Lottie.asset('assets/animation/send.json'),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            _gradientBackground,
            Column(
              children: [
                Container(height: size.height * 0.4),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Material(
                    elevation: 8.0,
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                    child: Container(
                      height: 360,
                      width: double.maxFinite,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(2)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Status Saver ✨',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                            child: Center(
                              child: Divider(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              '◉ Save WhatsApp Status',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              '◉ Chat without Saving Number',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: RichText(
                              text: TextSpan(
                                text: '◉ Made By : ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: adaptiveTheme.mode ==
                                            AdaptiveThemeMode.dark
                                        ? ColorPalette.darkActive
                                        : ColorPalette.lightInactive),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'SatyamX64',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        try {
                                          await launch(portfolioLink);
                                        } catch (e) {
                                          print(
                                              'Something went Wrong : ${e.toString()}');
                                        }
                                      },
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: adaptiveTheme.mode ==
                                              AdaptiveThemeMode.dark
                                          ? ColorPalette.darkGradientLow
                                          : ColorPalette.lightGradientHigh,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await inAppReview.openStoreListing();
                                    } catch (e) {
                                      print(
                                          'Something went wrong : ${e.toString()}');
                                    }
                                  },
                                  child: Text(
                                    'Rate',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    try {
                                      Share.share(
                                          'Check this out : $playStoreLink',
                                          subject: 'Status Saver');
                                    } catch (e) {
                                      print(
                                          'Something went Wrong : ${e.toString()}');
                                    }
                                  },
                                  child: Text(
                                    'Share',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
