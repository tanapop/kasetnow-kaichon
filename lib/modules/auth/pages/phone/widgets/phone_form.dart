import 'package:flutter/material.dart';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import '../../../../../imports.dart';

class PhoneFormWidget extends StatefulWidget {
  final TextEditingController codeController;
  final TextEditingController phoneController;
  final Rx<Country> country;
  const PhoneFormWidget({
    Key key,
    @required this.codeController,
    @required this.phoneController,
    @required this.country,
  }) : super(key: key);

  @override
  _PhoneFormWidgetState createState() => _PhoneFormWidgetState();
}

class _PhoneFormWidgetState extends State<PhoneFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          //Phone Code
          SizedBox(
            width: 95,
            child: TextFormField(
              controller: widget.codeController,
              keyboardType: TextInputType.number,
              maxLength: 3,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppStyles.primaryColorTextField),
              decoration: InputDecoration(
                counter: SizedBox.shrink(),
                filled: true,
                fillColor: AppStyles.primaryBackBlackKnowText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide(),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppStyles.primaryColorWhite),
                  borderRadius: BorderRadius.circular(50),
                ),
                labelStyle: TextStyle(color: AppStyles.primaryColorTextField),
                prefix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 30,
                      child: GestureDetector(
                        onTap: () => _countryPickerTapped(context),
                        child: Obx(
                          () => guard(
                            () => CountryPickerUtils.getDefaultFlagImage(
                              widget.country(),
                            ),
                            Icon(Icons.bug_report, color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    Align(
                        alignment: Alignment(0, -10),
                        child: Text('+',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppStyles.primaryColorTextField)))
                  ],
                ),
              ),
              onChanged: (str) {
                if (str.length == 3) {
                  FocusScope.of(context).nextFocus();
                }
                widget.country(guard(
                  () => CountryPickerUtils.getCountryByPhoneCode(str),
                  Country(iso3Code: '', isoCode: '', name: '', phoneCode: ''),
                ));
              },
            ),
          ),

          SizedBox(width: 12),
          //Phone Number Main TextField
          Flexible(
            flex: 4,
            child: TextFormField(
              controller: widget.phoneController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppStyles.primaryColorTextField),
              decoration: InputDecoration(
                counter: SizedBox.shrink(),
                labelText: t.PhoneNumber,
                labelStyle: TextStyle(color: AppStyles.primaryColorTextField),
                filled: true,
                fillColor: AppStyles.primaryBackBlackKnowText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide(),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppStyles.primaryColorWhite),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _countryPickerTapped(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.pink),
        child: CountryPickerDialog(
          titlePadding: EdgeInsets.all(8.0),
          searchCursorColor: Colors.pinkAccent,
          searchInputDecoration: InputDecoration(hintText: t.Searching),
          isSearchable: true,
          title: Text(t.SelectPhoneCode),
          onValuePicked: (v) {
            widget.codeController.text = v.phoneCode;
            widget.country(v);
          },
          itemBuilder: (country) => ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text('+${country.phoneCode}  (${country.name})'),
            leading: CountryPickerUtils.getDefaultFlagImage(country),
          ),
        ),
      ),
    );
  }
}
