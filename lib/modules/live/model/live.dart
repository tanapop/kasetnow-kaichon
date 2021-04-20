import 'package:flutter/material.dart';

class Live {
  String username;
  String fullName;
  String photoURL;
  int channelId;
  String channelName;
  bool me;
  String eventName;
  String eventPhotoURL;
  String sponsorLogo1;
  String sponsorLogo2;

  Live(
      {this.username,
      this.fullName,
      this.me,
      this.photoURL,
      this.channelId,
      this.channelName,
      this.eventName,
      this.eventPhotoURL,
      this.sponsorLogo1,
      this.sponsorLogo2});
}
