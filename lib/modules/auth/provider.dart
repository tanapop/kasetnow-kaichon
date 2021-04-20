import 'package:firebase_auth/firebase_auth.dart' hide User;

import '../../imports.dart';
import '../notifications/data/notifications.dart';
import 'data/user.dart';

AuthProvider get authProvider => Get.find();

class AuthProvider {
  AuthProvider._();
  static final auth = FirebaseAuth.instance;
  String get uid => auth.currentUser?.uid;

  final rxUser = Rx<User>();
  User get user => rxUser();
  bool get isLoggedIn => user != null;

  static Future<AuthProvider> init() async {
    final c = AuthProvider._();
    Get.put(c);
    await c._fetchUser();
    if (auth.currentUser != null) {
      if (c.user == null) {
        0.5.delay().then((_) => AppNavigator.toRegister());
      } else {
        NotificationRepo.registerNotification(false);
      }
    }
    return c;
  }

  Future<void> _fetchUser() async {
    if (auth.currentUser == null) return;
    final user = await UserRepository.fetchUser();
    if (user != null) {
      updateUser(user);
      UserRepository.updateActiveAt(true);
    }
  }

  void updateUser(User user) {
    if (user.isBanned) {
      auth.signOut();
      rxUser.nil();
    } else {
      rxUser(user);
    }
  }

  Future<void> login() async {
    try {
      await _fetchUser();
      Get.until((r) => r.isFirst);
      if (user == null) {
        AppNavigator.toRegister();
      } else {
        NotificationRepo.registerNotification(true);
      }
    } catch (e) {
      logError(e);
    }
  }

  Future<void> logout() async {
    BotToast.showLoading();
    try {
      Get.until((r) => r.isFirst);
      await NotificationRepo.clearToken();
      await UserRepository.updateActiveAt(false);
      await 2.delay();
      await auth.signOut();
      rxUser.nil();
    } catch (e) {
      logError(e);
    }
    BotToast.closeAllLoading();
  }
}
