import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_helper/constants.dart';
import 'package:whatsapp_helper/services/whatsapp_unilink.dart';

class ChatScreen extends StatefulWidget {
  static const route = "/chat-screen";
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String countryCode = '+91';
  String countryName = 'India';

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Widget _buildCountryDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Text("+${country.phoneCode}"),
          SizedBox(width: 8.0),
          Flexible(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                country.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ],
      );

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final adaptiveTheme = AdaptiveTheme.of(context);
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
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: adaptiveTheme.mode == AdaptiveThemeMode.dark
                      ? [
                          ColorPalette.darkGradientHigh,
                          ColorPalette.darkGradientLow
                        ]
                      : [
                          ColorPalette.lightGradientLow,
                          ColorPalette.lightGradientHigh,
                        ],
                ),
              ),
              alignment: Alignment.center,
              height: size.height * 0.6,
              child: Lottie.asset('assets/animation/send.json'),
            ),
            Column(
              children: [
                Container(
                  height: size.height -
                      360 - // Container Size
                      32 - // 2*verticalPadding
                      MediaQuery.of(context).padding.bottom,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Material(
                    elevation: 8.0,
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                    child: Container(
                      height: 360,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(2)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(child: LayoutBuilder(
                                  builder: (_, constraints) {
                                    return Row(
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(
                                              maxWidth:
                                                  constraints.maxWidth * 0.6),
                                          child: Text(
                                            '$countryName ',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24),
                                          ),
                                        ),
                                        Text(
                                          '($countryCode)',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24),
                                        ),
                                      ],
                                    );
                                  },
                                )),
                                IconButton(
                                  icon: Icon(
                                    Icons.location_on,
                                    color: adaptiveTheme.mode ==
                                            AdaptiveThemeMode.dark
                                        ? ColorPalette.darkAccent
                                        : ColorPalette.lightAccent,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => CountryPickerDialog(
                                          titlePadding: EdgeInsets.all(8.0),
                                          searchInputDecoration:
                                              InputDecoration(
                                                  hintText: 'Search'),
                                          isSearchable: true,
                                          title: Text(
                                            'Select your phone code',
                                            style: TextStyle(
                                                color: adaptiveTheme.mode ==
                                                        AdaptiveThemeMode.dark
                                                    ? ColorPalette.darkActive
                                                    : ColorPalette
                                                        .lightInactive),
                                          ),
                                          onValuePicked: (Country country) {
                                            setState(() {
                                              countryCode =
                                                  '+' + country.phoneCode;
                                              countryName = country.name;
                                            });
                                          },
                                          priorityList: [
                                            CountryPickerUtils
                                                .getCountryByIsoCode('TR'),
                                            CountryPickerUtils
                                                .getCountryByIsoCode('US'),
                                          ],
                                          itemBuilder: _buildCountryDialogItem),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _textEditingController,
                              onSubmitted: (_) {
                                _openWhatsApp();
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Phone Number',
                                hintStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[350]),
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Chat without Saving Number',
                              style: TextStyle(
                                color:
                                    adaptiveTheme.mode == AdaptiveThemeMode.dark
                                        ? ColorPalette.darkGradientLow
                                        : ColorPalette.lightGradientHigh,
                              ),
                            ),
                          ),
                          Spacer(),
                          Material(
                            elevation: 2,
                            color: Color(0xFF13D776),
                            child: InkWell(
                              onTap: _openWhatsApp,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: 48,
                                decoration: BoxDecoration(
                                    color:
                                        adaptiveTheme.mode == AdaptiveThemeMode.dark
                                            ? ColorPalette.darkGradientHigh
                                            : ColorPalette.lightGradientLow),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'NEXT',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
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

  void _openWhatsApp() async {
    try {
      final link = WhatsAppUnilink(
        phoneNumber: countryCode + _textEditingController.text,
        text: "Hey",
      );
      // Convert the WhatsAppUnilink instance to a string.
      // Use either Dart's string interpolation or the toString() method.
      // The "launch" method is part of "url_launcher".
      await launch('$link');
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }
}
