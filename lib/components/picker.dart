import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../imports.dart';

Future<FileModel> pickFile(
  BuildContext context, [
  bool showVideoPicker,
]) =>
    showMaterialModalBottomSheet(
      context: context,
      builder: (_) => MediaPickerWidget(
        showVideoPicker: showVideoPicker ?? false,
      ),
    );

class MediaPickerWidget extends StatelessWidget {
  final bool showVideoPicker;

  const MediaPickerWidget({
    this.showVideoPicker,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
      decoration: BoxDecoration(
        color: AppStyles.primaryColorWhite,
        //borderRadius: BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(
          color: AppStyles.primaryColorGray,
          //width: 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AttachmentBtn(
            text: t.PhotosLibrary.toUpperCase(),
            icon: Icons.image,
            onPressed: () => onPickImage(context, ImageSource.gallery),
          ),
          _AttachmentBtn(
            icon: Icons.camera_alt,
            text: t.TakePicture.toUpperCase(),
            onPressed: () => onPickImage(context, ImageSource.camera),
          ),
        ],
      ),
    );
  }

  Future<void> onPickImage(BuildContext context, ImageSource source) async {
    final picked = await ImagePicker().getImage(
      source: source,
      imageQuality: appConfigs.imageCompressQuality,
    );
    Navigator.of(context).pop(ImageModel(picked?.path ?? ''));
  }
}

class _AttachmentBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String text;
  const _AttachmentBtn({
    Key key,
    @required this.icon,
    @required this.onPressed,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.fromLTRB(0, 8, 8, 0),
      onPressed: onPressed,
      child: Row(
        children: <Widget>[
          Icon(icon, color: AppStyles.primaryColorTextField),
          Padding(
            padding: EdgeInsets.only(left: 32),
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppStyles.primaryColorTextField),
            ),
          ),
        ],
      ),
    );
  }
}
