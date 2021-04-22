import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaichon/modules/auth/pages/widgets/register_header.dart';
import '../../../../components/form_field.dart';
import '../../../../imports.dart';
import '../../data/register.dart';
import 'widgets/gender.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Form Fields
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final bioController = TextEditingController();
  final emailController = TextEditingController();

  final photoUploader = AppUploader();

  String gender = t.Male;

  final usernameErrorText = Rx<String>();
  final accepted = false.obs;
  final isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      //appBar: Appbar(titleStr: t.Register),
      backgroundColor: AppStyles.primaryBackBlackKnowText,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
            child: Stack(children: [
          RegisterTopHeader(),
          Positioned(
              top: 100,
              left: size.width / 3.3,
              right: size.width / 3.3,
              child: Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    color: AppStyles.primaryBackBlackKnowText,
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    border: Border.all(
                      color: Colors.white,
                      width: 4.0,
                    ) //                 <--- border radius here
                    ),
                child: Obx(
                  () => AvatarWidget(
                    photoUploader.path(),
                    onTap: () => photoUploader.pick(context),
                    radius: 150,
                  ),
                ),
              )),
          Column(
            children: <Widget>[
              //SizedBox(height: 20),

              SizedBox(height: context.height / 2.5),
              Obx(
                () => AppTextFormField(
                  label: t.Username,
                  icon: Icons.alternate_email,
                  controller: usernameController,
                  keyboardType: TextInputType.name,
                  formatters: [
                    TextInputFormatter.withFunction((o, n) {
                      final match =
                          RegExp(r"^[a-zA-Z0-9_\-]+$").hasMatch(n.text);
                      return !match
                          ? o
                          : n.copyWith(text: n.text.toLowerCase());
                    })
                  ],
                  maxLength: 20,
                  validator: (s) => s.length < 3 ? t.AddValidUsername : null,
                  errorText: usernameErrorText(),
                  borderRadius: 50.0,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: AppTextFormField(
                      label: t.FirstName,
                      controller: firstNameController,
                      maxLength: 10,
                      validator: (s) => s.isEmpty ? t.AddValidFirstName : null,
                      borderRadius: 50.0,
                    ),
                  ),
                  Expanded(
                    child: AppTextFormField(
                      label: t.LastName,
                      controller: lastNameController,
                      maxLength: 10,
                      validator: (s) => s.isEmpty ? t.AddValidLastName : null,
                      borderRadius: 50.0,
                    ),
                  ),
                ],
              ),
              AppTextFormField(
                label: '${t.Email} (ไม่ต้องกรอกก็ได้)',
                icon: Icons.email,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                borderRadius: 50.0,
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment(-0.8, 0),
                child: Text(
                  t.SelectGender,
                  style: TextStyle(
                      color: AppStyles.primaryColorTextField, fontSize: 16),
                ),
              ),

              GenderWidget(onSelect: (v) => gender = v),
              SizedBox(height: 8),
              ListTile(
                leading: Obx(
                  () => Checkbox(
                    activeColor: AppStyles.primaryColorRedKnow,
                    checkColor: AppStyles.primaryColorWhite,
                    value: accepted(),
                    onChanged: accepted,
                  ),
                ),
                title: Text(
                  t.AcceptTerms,
                  style: theme.textTheme.headline6.copyWith(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      color: AppStyles.primaryColorRedKnow),
                ),
                onTap: () => launchURL(appConfigs.termsURL),
              ),
              SizedBox(height: 10),
              Obx(
                () => AppButton(
                  t.Save,
                  color: AppStyles.primaryColorWhite,
                  backgroundColor: AppStyles.primaryColorRedKnow,
                  isLoading: isLoading(),
                  onTap: accepted() ? onSave : null,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ])),
      ),
    );
  }

  Future<void> onSave() async {
    if (!formKey.currentState.validate()) return;
    isLoading(true);
    try {
      final username = usernameController.text;
      usernameErrorText.nil();
      if (await RegisterRepository.checkIfUsernameTaken(username)) {
        usernameErrorText(t.UsernameTaken);
        throw Exception(t.UsernameTaken);
      }
      String photoURL;
      if (photoUploader.isPicked) {
        await photoUploader.upload(
          StorageHelper.profilesPicRef,
          onSuccess: (f) => f.when(image: (v) => photoURL = v.path),
          onFailed: (e) => BotToast.showText(text: e),
        );
      }
      await RegisterRepository.createNewUser(
        username: username,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        photoURL: photoURL,
        gender: gender,
      );
      await authProvider.login();
    } catch (e) {
      BotToast.showText(text: AppAuthException.handleError(e).message);
    }
    isLoading(false);
  }
}
