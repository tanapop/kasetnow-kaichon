import 'package:flutter/material.dart';
import '../../../imports.dart';

import '../../../main_menu.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(
      //() => authProvider.isLoggedIn ? MainTabPage() : _WelcomePage(),
      //() => authProvider.isLoggedIn ? MainMenuBottomBar() : _WelcomePage(),
      () => authProvider.isLoggedIn ? MainMenu() : _WelcomePage(),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/splash/splash.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: size.height / 2.5),
            Spacer(),
            Text(
              t.AppName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
            ),
            Text(
              t.AboutApp,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: context.isDarkMode
                    ? Colors.white
                    : context.theme.primaryColor,
              ),
            ),
            Spacer(),
            AppButton(
              t.START,
              color: AppStyles.primaryColorWhite,
              backgroundColor: AppStyles.primaryColorRedKnow,
              borderRadius: 40,
              onTap: GetPlatform.isMobile
                  ? AppNavigator.toPhoneLogin
                  : AppNavigator.toEmailLogin,
            ),
            Spacer(),
          ],
        ),
      ),
    ));
  }
}
