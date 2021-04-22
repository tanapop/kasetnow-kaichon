// Generated file. Do not edit.

import 'package:flutter/material.dart';

import 'package:fast_i18n/fast_i18n.dart';

const String _baseLocale = 'th';

String _locale = _baseLocale;

Map<String, Strings> _strings = {
  'th': Strings.instance,
};

/// Method A: Simple
///
/// Widgets using this method will not be updated when locale changes during runtime.
/// Translation happens during initialization of the widget (call of t).
///
/// Usage:
/// String translated = t.someKey.anotherKey;
Strings t = _strings[_locale];

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // get t variable
/// String translated = t.someKey.anotherKey; // use t variable
class Translations {
  Translations._(); // no constructor

  static Strings of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedLocaleData>()
        .translations;
  }
}

class LocaleSettings {
  LocaleSettings._(); // no constructor

  /// Use locale of the device, fallbacks to base locale.
  /// Returns the locale which has been set.
  static String useDeviceLocale() {
    String deviceLocale = FastI18n.getDeviceLocale();
    return setLocale(deviceLocale);
  }

  /// Set locale, fallbacks to base locale.
  /// Returns the locale which has been set.
  static String setLocale(String locale) {
    _locale =
        FastI18n.selectLocale(locale, _strings.keys.toList(), _baseLocale);
    t = _strings[_locale];

    if (_translationProviderKey.currentState != null) {
      _translationProviderKey.currentState.setLocale(_locale);
    }

    return _locale;
  }

  /// Get current locale.
  static String get currentLocale {
    return _locale;
  }

  /// Get base locale.
  static String get baseLocale {
    return _baseLocale;
  }

  /// Get supported locales.
  static List<String> get locales {
    return _strings.keys.toList();
  }
}

GlobalKey<_TranslationProviderState> _translationProviderKey =
    new GlobalKey<_TranslationProviderState>();

class TranslationProvider extends StatefulWidget {
  TranslationProvider({@required this.child})
      : super(key: _translationProviderKey);

  final Widget child;

  @override
  _TranslationProviderState createState() => _TranslationProviderState();
}

class _TranslationProviderState extends State<TranslationProvider> {
  String locale = _locale;

  void setLocale(String newLocale) {
    setState(() {
      locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedLocaleData(
      translations: _strings[locale],
      child: widget.child,
    );
  }
}

class _InheritedLocaleData extends InheritedWidget {
  final Strings translations;
  _InheritedLocaleData({this.translations, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(_InheritedLocaleData oldWidget) {
    return oldWidget.translations != translations;
  }
}

// translations

class Strings {
  Strings._(); // no constructor

  static Strings _instance = Strings._();
  static Strings get instance => _instance;

  String AppName = 'ไก่ชน';
  String AboutApp = 'เกษตรก้าวไกล ใส่ใจความพอเพียง';
  String AppVersion = '1.0.0';
  String UnknownError = 'Oops, Something went Wrong!';
  String Next = 'ถัดไป';
  String EmailUser = 'Are you Email User, Login here!';
  String Email = 'อีเมล';
  String Password = 'Password';
  String Login = 'Login';
  String PhoneNumber = 'เบอร์โทรศัพท์';
  String PhoneVerification = 'ยืนยันรหัส OTP';
  String EnterCode = 'กรอกรหัส OTP ที่ส่งไปยังเบอร์ ';
  String DidntRecieveCode = 'หากไม่ได้รับรหัส OTP ? ';
  String InvalidSMSCode = 'รหัสยืนยัน OTP ไม่ถูกต้อง';
  String RESEND = 'ขอ OTP ใหม่';
  String VERIFY = 'ยืนยัน';
  String POSTS = 'โพส';
  String POSTS_ADS = 'โฆษณา';
  String FOLLOWERS = 'ผู้ติดตาม';
  String FOLLOWINGS = 'กำลังติดตาม';
  String Follow = 'ติดตาม';
  String Following = 'กำลังติดตาม';
  String Register = 'ลงทะเบียน';
  String Username = 'Kasetnow ID';
  String FirstName = 'ชื่อ';
  String LastName = 'นามสกุล';
  String FullName = 'ชื่อเต็ม';
  String Status = 'สถานะ';
  String AddValidUsername = 'Add a valid username';
  String AddValidFirstName = 'Add a valid first name';
  String AddValidLastName = 'Add a valid last name';
  String SelectGender = 'กรุณาเลือกเพศของคุณ';
  String Male = 'ชาย';
  String Female = 'หญิง';
  String Other = 'อื่นๆ';
  String AcceptTerms = 'ฉันยอมรับข้อกำหนดและเงื่อนไขทั้งหมด';
  String AcceptPolicy = 'ฉันยอมรับนโยบายความเป็นส่วนตัว';
  String Save = 'บันทึก';
  String Search = 'ค้นหา';
  String Searching = 'กำลังค้นหา...';
  String SelectPhoneCode = 'Select a phone code';
  String InvalidEmail = 'Invalid Email';
  String ShortPassword = 'Password Must Contain At Least 8 characters';
  String UsernameTaken = 'ไอดีนี้มีผู้ใช้แล้ว';
  String InvalidPhone = 'กรุณากรอกเบอร์โทรของคุณ';
  String Message = 'แชท';
  String LoginFirst = 'Oops, Please login first';
  String START = 'เริ่มใช้งาน';
  String Wallpapers = 'Wallpapers';
  String Profile = 'โปรไฟล์';
  String NoInternet = 'ไม่มีอินเตอร์เน็ต';
  String Settings = 'Settings';
  String Account = 'Account';
  String EditProfile = 'แก้ไขโปรไฟล์';
  String OnlineStatus = 'สถานะออนไลน์';
  String OnlineDescription = 'Anyone can see when you\'re last Online';
  String Logout = 'ออกจากระบบ';
  String DirectMsgs = 'แชทส่วนตัว';
  String DirectMsgsDescr = 'Recieve all Direct Chat Notificatins';
  String GroupsMsgs = 'กลุ่มแชท';
  String GroupsMsgsDesc = 'Recieve all Groups Notifications';
  String AddGroupName = 'Please! Add Group Name';
  String About = 'About';
  String RateUs = 'Rate Us';
  String EULA = 'EULA Agreement';
  String PrivacyPolicy = 'Privacy Policy';
  String Feed = 'ไทม์ไลน์';
  String Post = 'โพสต์';
  String Gallery = 'Gallery';
  String Stories = 'Stories';
  String MyPosts = 'โพสของฉัน';
  String Favorites = 'Favorites';
  String Announcement = 'Announcement';
  String WhatOnMind = 'คุณกำลังคิดอะไรอยู่?';
  String Likes = 'ถูกใจ';
  String Comments = 'ความคิดเห็น';
  String CreatePost = 'สร้างโพสต์';
  String CreatePostAds = 'สร้างโฆษณา';
  String AdsSupporter = 'ผู้สนับสนุน';
  String Share = 'แชร์';
  String Edit = 'แก้ไข';
  String Delete = 'ลบ';
  String Copy = 'คัดลอก';
  String Copied = 'คัดลอกแล้ว';
  String ReadMore = '...อ่านเพิ่มเติม';
  String SuccessPostPublish = 'โพสสำเร็จ';
  String SuccessPostEdited = 'แก้ไขโพสสำเร็จ';
  String TypeComment = 'เขียนความคิดเห็น ...';
  String NotAllowedToPublish = 'Sorry! You are not allowed to publish anymore';
  String NotAllowedToComment = 'Sorry! You are not allowed to comment';
  String PostRemoveConfirm = 'Are you sure you want to delete this post?';
  String CommentRemoveConfirm = 'Are you sure you want to delete this comment?';
  String AddSomeContent = '\'Please add some content before posting\'';
  String Reply = 'ตอบกลับ';
  String Replies = 'ตอบกลับทั้งหมด';
  String Chats = 'แชท';
  String Live = 'ถ่ายทอดสด';
  String KTV = 'KTV';
  String OnlineUsers = 'ผู้ใช้ออนไลน์';
  String RecentChats = 'แชทล่าสุด';
  String RemoveConversation = 'ลบการแชท';
  String Messaging = 'ข้อความ...';
  String CannotChatWithUser = 'Sorry! You can\'t chat wih this user';
  String MsgDeleteConfirm = 'Are you sure you want to delete the message?';
  String NoChatFound = 'No Recents chat yet, start chatting!';
  String Online = 'ออนไลน์';
  String Typing = 'กำลังพิมพ์ ...';
  String Image = 'รูปภาพ';
  String Voice = 'เสียง';
  String Video = 'วิดีโอ';
  String Emoji = 'อีโมจิ';
  String GIF = 'GIF';
  String Sticker = 'Sticker';
  String Groups = 'กลุ่มแชท';
  String CreateGroup = 'สร้างกลุ่มแชท';
  String EditGroup = 'แก้ไขกลุ่มแชท';
  String Members = 'Members';
  String PhotosLibrary = 'เลือกรูปจากอัลบัม';
  String TakePicture = 'ถ่ายรูป';
  String VideosLibrary = 'Videos Library';
  String RecordVideo = 'Record Video';
  String Cancel = 'ยกเลิก';
  String SlideToCancel = 'เลื่อนเพื่อยกเลิก';
  String On = 'เปิด';
  String Off = 'ปิด';
  String Group = 'กลุ่มแชท';
  String LeaveGroup = 'ออกจากกลุ่มแชท';
  String GroupName = 'ชื่อกลุ่มแชท';
  String Join = 'เข้าร่วม';
  String Public = 'สาธารณะ';
  String Private = 'ส่วนตัว';
  String GroupType = 'Group Type';
  String RemoveMember = 'Remove member';
  String AddMembers = 'Add Members';
  String Block = 'บล็อก';
  String Unblock = 'ปลดล็อก';
  String Ban = 'แบน';
  String Unban = 'ยกเลิกแบน';
  String Banned = 'Banned';
  String Newest = 'Newest';
  String Trending = 'Trending';
  String MostDownloaded = 'Most Downloaded';
  String Categories = 'Categories';
  String AddWallpaper = 'Add Wallpaper';
  String WallpaperName = 'Wallpaper Name';
  String Category = 'Category';
  String Upload = 'Upload';
  String Home = 'Home';
  String Lock = 'Lock';
  String Both = 'Both';
  String SetAsWallpaper = 'Set as Wallpaper';
  String WallpaperSet = 'Wallpaper Set Successfully';
  String FailedToUpload = 'Oops! Upload Failed, Please try again';
  String UploadFinished = 'Upload Finished';
  String Downloading = 'Downloading';
  String NoWallpaperSelectedMsg = 'Please Select Wallpaper to continue';
  String NoImgSelected = 'No Image Selected';
  String Notifications = 'Notifications';
  String StartFollowingMsg = 'start following you';
  String PostReactionMsg = 'reacted to your post';
  String PostCommentMsg = 'commented your post';
  String ReplyMsg = 'replied to your comment';
  String CommentReactedMsg = 'reacted to your comment';
  String CannotFindFile = 'Oops! Cannot find the file';
  String NoFilePicked = 'Trying to upload and no file is picked';
  String SentYouMsg = 'Sent you message';
  String Report = 'Report';
  String Unreport = 'Unreport';
  String ReportDesc = 'We remove post that has: ';
  String ReportReasons =
      '⚫️ Sexual content. \n\n⚫️ Violent or repulsive content. \n\n⚫️ Hateful or abusive content. \n\n⚫️ Spam or misleading.';
  String ReportNote = 'We wont let them know if you take this action.';
  String ReportThanks =
      'We will check your request, Thanks for helping improve our community';
  String Admin = 'Admin';
  String ProfanityDetected =
      'Bad words detected, your account may get suspended!';
  String AreYouSure = 'Are you sure to';
  String ConfirmChatDeletion = 'Are you sure to delete chat';
  String ReportedPosts = 'Reported Posts';
  String AllChats = 'All Chats';
  String Users = 'Users';
}
