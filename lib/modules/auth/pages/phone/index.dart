import 'package:flutter/material.dart';

import 'package:country_pickers/country.dart';
import '../../../../imports.dart';
import '../../data/phone.dart';
import '../widgets/auth_header.dart';
import 'verification.dart';
import 'widgets/phone_form.dart';

class PhoneLoginPage extends StatefulWidget {
  @override
  _PhoneLoginPageState createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final formKey = GlobalKey<FormState>();

  // Phone Number Controllers
  final codeController = TextEditingController();
  final phoneController = TextEditingController();
  String get phoneNumber => '+${codeController.text}${phoneController.text}';

  final country =
      Country(iso3Code: '', isoCode: '', phoneCode: '', name: '').obs;

  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void initState() {
    super.initState();
    PhoneRepository.getInitCountry().then((c) {
      country(c);
      codeController.text = c.phoneCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColorBlackKnow,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: FocusScope.of(context).unfocus,
        child: Column(
          children: [
            AuthTopHeader(),
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: <Widget>[
                  PhoneFormWidget(
                    codeController: codeController,
                    phoneController: phoneController,
                    country: country,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Obx(
                      () => Text(
                        error(),
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: context.height / 4,
                    child: Center(
                      child: Obx(
                        () => AppButton(
                          t.Next,
                          color: AppStyles.primaryColorWhite,
                          backgroundColor: AppStyles.primaryColorRedKnow,
                          suffixIcon: Icon(
                            Icons.chevron_right,
                            color: AppStyles.primaryColorWhite,
                          ),
                          isLoading: isLoading(),
                          onTap: getValidationCode,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getValidationCode() async {
    if (!phoneNumber.isPhoneNumber) {
      BotToast.showText(
          text: t.InvalidPhone,
          backgroundColor: AppStyles.primaryColorGray,
          contentColor: AppStyles.primaryColorWhite);
      return;
    }
    isLoading(true);
    error('');
    appPrefs.prefs.setString('country', country().name);
    PhoneRepository.verifyPhone(
      phoneNumber,
      onCodeSent: (id) => Get.to(
        () => OTPVerificationPage(phoneNumber: phoneNumber, verID: id),
      ),
      onFailed: (e) {
        error(e.message);
        isLoading(false);
      },
    );
    6.delay(() => isLoading(false));
  }
}
