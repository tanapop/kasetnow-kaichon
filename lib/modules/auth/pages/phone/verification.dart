import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_social/imports.dart';

import 'package:kaichon/imports.dart';
import 'package:kaichon/modules/auth/pages/widgets/verification_header.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../imports.dart';
import '../../data/phone.dart';

class OTPVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String verID;

  const OTPVerificationPage({
    Key key,
    @required this.phoneNumber,
    @required this.verID,
  }) : super(key: key);

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final isLoading = false.obs;
  String enteredOTP = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: AppStyles.primaryColorBlackKnow,
        body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: FocusScope.of(context).unfocus,
            child: Column(children: [
              VerificationTopHeader(),
              Expanded(
                  child: ListView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      children: <Widget>[
                    //SizedBox(height: 12),
                    AppText(
                      t.PhoneVerification,
                      color: AppStyles.primaryColorWhite,
                      size: 22,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8),
                      child: RichText(
                        text: TextSpan(
                          text: t.EnterCode,
                          children: [
                            TextSpan(
                              text: widget.phoneNumber,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppStyles.primaryColorTextField),
                            ),
                          ],
                          style: TextStyle(
                            color: AppStyles.primaryColorWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            //decoration: TextDecoration.underline,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 30),
                      child: PinCodeTextField(
                        appContext: context,
                        cursorColor: AppStyles.primaryColorRedKnow,
                        length: 6,
                        keyboardType: TextInputType.number,
                        backgroundColor: Colors.transparent,
                        pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            selectedColor: AppStyles.primaryColorWhite,
                            inactiveColor: AppStyles.primaryColorRedKnow,
                            activeColor: Colors.green),
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: AppStyles.primaryColorWhite),
                        onChanged: (v) => enteredOTP = v,
                      ),
                    ),
                    SizedBox(height: 20),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: t.DidntRecieveCode,
                            style: TextStyle(
                              color: AppStyles.primaryColorWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              //decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: t.RESEND,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context);
                              },
                            style: TextStyle(
                              color: AppStyles.primaryColorRedKnow,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: context.height / 4,
                      child: Center(
                        child: Obx(
                          () => AppButton(
                            t.VERIFY,
                            backgroundColor: AppStyles.primaryColorRedKnow,
                            isLoading: isLoading(),
                            onTap: login,
                            color: AppStyles.primaryColorWhite,
                          ),
                        ),
                      ),
                    ),
                  ]))
            ])));
    /*return Scaffold(
      backgroundColor: AppStyles.primaryColorLight,
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/login-header-bg/login-head.png"),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200, bottom: 20),
            child: Image.asset(Assets.images.logo.path),
          ),
          /*SizedBox(height: 25),
          SizedBox(
            height: context.height / 3,
            child: FlareActor(
              'assets/flare/otp.flr',
              shouldClip: false,
              alignment: Alignment.bottomCenter,
              animation: 'otp',
            ),
          ),*/
          SizedBox(height: 12),
          AppText(
            t.PhoneVerification,
            size: 22,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
            child: RichText(
              text: TextSpan(
                text: t.EnterCode,
                children: [
                  TextSpan(
                    text: widget.phoneNumber,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
                style: theme.textTheme.subtitle2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
            child: PinCodeTextField(
              appContext: context,
              length: 6,
              keyboardType: TextInputType.number,
              backgroundColor: Colors.transparent,
              pinTheme: PinTheme(shape: PinCodeFieldShape.underline),
              textStyle: theme.textTheme.headline6,
              onChanged: (v) => enteredOTP = v,
            ),
          ),
          SizedBox(height: 20),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: t.DidntRecieveCode,
                  style: theme.textTheme.subtitle2,
                ),
                TextSpan(
                  text: t.RESEND,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pop(context);
                    },
                  style: TextStyle(
                    color: Color(0xFF91D3B3),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: context.height / 4,
            child: Center(
              child: Obx(
                () => AppButton(
                  t.VERIFY,
                  isLoading: isLoading(),
                  onTap: login,
                ),
              ),
            ),
          ),
        ],
      ),
    );*/
  }

  Future<void> login() async {
    if (enteredOTP.length < 6 || widget.verID.isEmpty) {
      BotToast.showText(text: t.InvalidSMSCode);
      return;
    }
    isLoading(true);
    try {
      await PhoneRepository.login(widget.verID, enteredOTP);
      await authProvider.login();
    } catch (e) {
      BotToast.showText(
        text: AppAuthException.handleError(e).message,
        duration: Duration(seconds: 3),
      );
    }
    isLoading(false);
  }
}
