import 'dart:convert';

import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:akshaya_pathara/Global/bloc.dart';
import 'package:akshaya_pathara/Global/location_class_textfield.dart';
import 'package:akshaya_pathara/Global/location_class_textfield_new.dart';
import 'package:akshaya_pathara/Global/terms_conditions.dart';
import 'package:akshaya_pathara/Global/toast.dart';
import 'package:akshaya_pathara/Pages/my_account.dart';
import 'package:akshaya_pathara/Pages/online_donation_branch/alert_box_donation.dart';
import 'package:akshaya_pathara/Pages/online_donation_branch/donation_category.dart';
import 'package:akshaya_pathara/Pages/online_donation_form.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:akshaya_pathara/Global/global.dart' as global;

class indian_citizen extends StatefulWidget {
  // final List<Map<String, dynamic>> data;
  final String citizenship_type;
  //final void Function({Map<String, dynamic>? passedData})? onNextStep;
  final Function(String url) onNextStep;
  final Function(bool loading) onLoadingStateChanged;

  const indian_citizen({
    // required this.data,
    required this.citizenship_type,
    required this.onNextStep,
    required this.onLoadingStateChanged,

    //  this.onNextStep,
    super.key,
  });
  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<indian_citizen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //final locationFormKey = GlobalKey<DynamicLocationFormState>();

  @override
  void initState() {
    global.isloadingindian_citizen = false;

    quotation();
    donationData = {
      "currency_name": "Indian Rupee",
      "donation_amount": "",
      "citizenship_type": widget.citizenship_type,
      "source": "mobile app",
      "indian_citizenship_details": [],
      "not_residing_india_details": [],
    };
    indianCitizenshipDetails.add(donationData);
    // TODO: implement initState
    super.initState();
  }

  bool charityFormSubmitted = false;

  int? selectedDonationType = 0;
  int? selectedMonth;
  late String jsonData;
  List answerJson = [];
  Map<String, TextEditingController> dateControllers = {};
  double? selectedAmount;
  List<Map<String, dynamic>> indianCitizenshipDetails = [];
  List<Map<String, dynamic>> donation_Category_list = [];

  bool showAmountError = false;

  bool _isSubmitting = false;
  bool showCertificateFields = false;
  bool showPanFields = false;

  bool checkBoxValue = false;
  List<String> donationOptions = ['Donate Once', 'Donate Monthly'];
  List<int> monthOptions = List.generate(12, (index) => index + 1); // 1 to 12
  final TextEditingController customAmountController = TextEditingController();
  final GlobalKey<CharityHierarchyPageState> charityFormKey =
      GlobalKey<CharityHierarchyPageState>();

  final List<double> predefinedAmounts = [100, 250, 500, 1000];

  Map<String, List<String>> termsAndConditionsData = {
    "bullet": [
      "Distributing receipts and thanking donors for donations",
      "Informing donors about upcoming fundraising and other activities of Akshaya Patra",
      "Internal analysis, such as research and analytics",
      "Record keeping",
      "Reporting to applicable government agencies as required by law",
      "Surveys, metrics, and other analytical purposes",
      "Other purposes related to the fundraising operations",
    ],
    "subtitle": ["About Donar"],
    "paragraph": [
      "Anonymous donor information may be used for promotional and fundraising activities. Comments that are provided by donors may be publicly published and may be used in promotional materials. We may use available information to supplement the Donor Data to improve the information we use to drive our fundraising efforts. We may allow donors the option to have their name publicly associated with their donation unless otherwise requested as part of the online donation process.",
      "We use data gathered for payment processors and other service providers only for the purposes described in this policy.",
    ],
  };

  void quotation() {
    jsonData = '''  {
  "fields": [
    
    {
          "field_options": [],
          "field_icon": "",
          "field_type": "text",
          "field_value": "",
          "id": "1",
          "label": "Name",
          "mandatory": false,
          "name": "first_name",
          "category":"basic"
        },
         {
          "field_options": {},
           "field_icon": "",
          "field_type": "email",
          "field_value": "",
          "id": "3",
          "label": "Email ID",
          "mandatory": false,
          "name": "email",
          "category":"basic"
        },
        {
      "field_options": ["I would like to receive 80(G) Certificate"],
      "field_icon": "",
      "field_type": "multi-select", 
      "field_value": "false",
      "id": "6",
      "label": "I would like to receive 80(G) Certificate",
      "mandatory": false,
      "name": "80-g_certificate",
      "category": "basic"
    },
      {
      "field_options": {},
      "field_icon": "",
      "field_type": "numbercard",
      "field_value": "",
      "id": "7",
      "label": "PAN Number",
      "mandatory": true,
      "name": "pan_number", 
      "category": "certificate"
    },
       {
     "field_options": [],
     "field_icon": "",
     "field_type": "location",
     "field_value":"",
     "address": "",
     "city": "",
     "pincode": "",
     "district": "",
     "state": "",
     "latitude": "",
     "longitude": "",
      "id": "6",
      "label": "",
      "mandatory": true,
      "name": "address",
      "category": "certificate"
    }       
         
  ]
}


      ''';
  }

  Map<String, IconData> iconMapping = {
    'name': Ionicons.person_outline,
    'mobileNo': Ionicons.call_outline,
    'email': Ionicons.mail_outline,
    'customer_address': Ionicons.location_outline,
    'comments': Ionicons.chatbubble_ellipses_outline,
    'tags': Ionicons.pricetag_outline,
    'geolocation': Ionicons.map_outline,
    'username': Ionicons.person_circle_outline,
  };
  Map<String, dynamic> donationData = {};

  // void _storeDonationData() {
  //   donationData = {
  //     "currency_name": "Indian Rupee",
  //     "donation_amount":
  //         selectedAmount?.toStringAsFixed(0) ?? customAmountController.text,
  //     "citizenship_type": widget.citizenship_type,
  //     "source": "mobile app",
  //     "indian_citizenship_details": [],
  //     "not_residing_india_details": [],
  //   };
  //
  //   indianCitizenshipDetails.clear();
  //   indianCitizenshipDetails.add(donationData);
  //

  // }
  void _storeDonationData() {
    final updatedAmount =
        selectedAmount?.toStringAsFixed(0) ?? customAmountController.text;
    donationData["donation_amount"] = updatedAmount;

    if (indianCitizenshipDetails.length > 0) {
      indianCitizenshipDetails[0] = donationData;
    } else {
      indianCitizenshipDetails.insert(0, donationData);
    }
    // print("Updated donation amount:");
    // print(indianCitizenshipDetails);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Stack(
      children: [
        Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Donation Amount',
              style: theme.typography.bodyText1.override(fontSize: 14),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Wrap(
                spacing: 6,
                runSpacing: 10,
                children: [
                  ...predefinedAmounts.map((amount) {
                    final isSelected =
                        selectedAmount == amount &&
                        customAmountController.text.isEmpty;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSelected
                                ? Colors.greenAccent
                                : Colors.lightBlue[50],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedAmount = amount;
                          customAmountController.clear();
                          showAmountError = false;
                          showPanFields = false;

                          _storeDonationData();
                        });
                      },
                      child: Text(
                        "₹ ${amount.toStringAsFixed(0)}",
                        style: theme.typography.bodyText1.override(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }),
                  SizedBox(
                    height: 45,
                    width: 110,
                    child: TextField(
                      style: theme.typography.bodyText1.override(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: customAmountController,
                      onChanged: (val) {
                        setState(() {
                          selectedAmount = double.tryParse(val);
                          showAmountError = false;
                          if ((selectedAmount ?? 0) >= 50000) {
                            showPanFields = true;
                          } else {
                            showPanFields = false;
                          }
                          _storeDonationData();
                        });
                      },
                      decoration: InputDecoration(
                        prefixText: '₹ ',
                        prefixStyle: theme.typography.bodyText1.override(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        hintText: 'Other Amount',
                        hintStyle: theme.typography.bodyText2.override(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                        ),
                        filled: true,
                        fillColor:
                            customAmountController.text.isNotEmpty
                                ? Colors.greenAccent
                                : Colors.blue.shade50,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Colors.grey.shade100),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Colors.black54),
                        ),
                        counterText: '',
                      ),
                    ),
                  ),
                  if (showAmountError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                      child: Text(
                        "select or enter donation amount",
                        style: theme.typography.bodyText1.override(
                          color: Colors.red,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 10),
            Text(
              'Select donation type',
              style: theme.typography.bodyText1.override(fontSize: 14),
            ),
            SizedBox(height: 10),

            // Radio Buttons
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: List.generate(donationOptions.length, (index) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: RadioListTile<int>(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: index,
                    groupValue: selectedDonationType,
                    onChanged: (val) {
                      setState(() {
                        selectedDonationType = val;
                        selectedMonth = val == 1 ? 2 : null;
                      });
                    },
                    title: Text(
                      donationOptions[index],
                      style: theme.typography.bodyText2.override(),
                    ),
                    activeColor: Colors.blue,
                  ),
                );
              }),
            ),

            // Monthly Donation Dropdown
            if (selectedDonationType == 1) ...[
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Select Number of months you wish to donate (Maximum number of debits set for the donation plan.)',
                        style: theme.typography.bodyText3.override(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: selectedMonth,
                        hint: Text("Select", style: TextStyle(fontSize: 12)),
                        style: theme.typography.bodyText1.override(),

                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                        ),
                        items:
                            monthOptions.map((month) {
                              return DropdownMenuItem<int>(
                                value: month,
                                child: Text(
                                  month.toString(),
                                  style: theme.typography.bodyText2.override(),
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMonth = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 20),

            CharityHierarchyPage(
              donation_Category_list,
              key: charityFormKey,
              onSubmitted: (success) {
                setState(() {
                  charityFormSubmitted = success;
                });
              },
            ),
            Form(key: _formKey, child: Column(children: getWidgets())),
          ],
        ),
        /*    if (global.isloadingindian_citizen)
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.6),
              child: Center(
                child: Image.asset(
                  'assets/gif/loader_blue.gif',
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.width * 0.2,
                ),
              ),
            ),
          ),*/
      ],
    );
  }

  getWidgets() {
    final theme = AppTheme.of(context);

    List<Widget> widgetList = [];
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    List fields = jsonDecode(jsonData)['fields'];

    widgetList.add(SizedBox(height: 10));

    if (answerJson.isEmpty) {
      answerJson = fields;
    }

    for (var ele in fields) {
      Map<String, dynamic> element = Map<String, dynamic>.from(ele);
      Map<String, dynamic> field = Map<String, dynamic>.from(element);

      if (element['category'] == 'certificate') {
        if (!showPanFields && !showCertificateFields) {
          continue;
        }
        if (showPanFields && !showCertificateFields) {
          if (element['name'] != 'pan_number') {
            continue;
          }
        }
      }

      IconData? iconData =
          (element['field_icon'] != null &&
                  element['field_icon'].toString().isNotEmpty)
              ? iconMapping[element['field_icon']]
              : null;

      String fieldType = element['field_type'] ?? '';
      bool hide = FormUtils.shouldHideElement(
        element,
        answerJson.map((e) => Map<String, dynamic>.from(e)).toList(),
      );

      if (!hide &&
          [
            'text',
            'name',
            'multi-line',
            'phone',
            'number',
            'numbercard',
            'email',
            'pincode',
          ].contains(fieldType)) {
        widgetList.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: screenWidth * 0.9,
                child: TextFormField(
                  initialValue: element['field_value'] ?? '',
                  maxLength:
                      fieldType == 'phone'
                          ? 10
                          : fieldType == 'pincode'
                          ? 6
                          : null,
                  maxLines: fieldType == 'multi-line' ? 2 : 1,
                  keyboardType:
                      fieldType == 'email'
                          ? TextInputType.emailAddress
                          : fieldType == 'phone' || fieldType == 'pincode'
                          ? TextInputType.phone
                          : fieldType == 'number'
                          ? TextInputType.number
                          : TextInputType.text,
                  inputFormatters: [
                    if (fieldType == 'name')
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z \s]')),
                    if (fieldType == 'phone' || fieldType == 'number')
                      FilteringTextInputFormatter.digitsOnly,
                    if (fieldType == 'text' || fieldType == 'multi-line')
                      FilteringTextInputFormatter.allow(
                        RegExp(
                          r'''[a-zA-Z0-9\s !@#\$%\^&\*\(\)_\+\-=\[\]\{\};:'",.<>\/\?\\|`~]''',
                        ),
                      ),
                    if (fieldType == 'numbercard')
                      UppercaseAlphanumericFormatter(),
                  ],
                  validator: (value) {
                    // PHONE VALIDATION
                    if (fieldType == 'phone') {
                      if (element["mandatory"] == true &&
                          (value == null || value.trim().isEmpty)) {
                        return 'Mandatory Field';
                      }
                      if (value != null && value.trim().isNotEmpty) {
                        if (!RegExp(r'^[0-9]+$').hasMatch(value.trim()) ||
                            value.trim().length != 10) {
                          return "Enter valid Phone Number";
                        }
                      }
                    }
                    if (element['name'] == 'pan_number') {
                      if (element["mandatory"] == true &&
                          (value == null || value.trim().isEmpty)) {
                        return 'Please enter PAN number';
                      }
                      if (value != null &&
                          value.trim().isNotEmpty &&
                          !RegExp(
                            r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$',
                          ).hasMatch(value.trim().toUpperCase())) {
                        return 'Enter valid PAN number';
                      }
                    }
                    // EMAIL VALIDATION
                    if (fieldType == 'email' || element['name'] == 'email') {
                      if (element["mandatory"] == true &&
                          (value == null || value.trim().isEmpty)) {
                        return 'Please enter email address';
                      }
                      if (value != null &&
                          value.trim().isNotEmpty &&
                          !RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          ).hasMatch(value.trim())) {
                        return 'Please enter valid email address';
                      }
                    }
                    // GENERIC MANDATORY FIELD
                    if (element["mandatory"] == true &&
                        (value == null || value.trim().isEmpty)) {
                      return 'Mandatory Field';
                    }

                    return null;
                  },

                  decoration: DecorationUtils.commonInputDecoration(
                    context: context,
                    iconData: iconData,
                    labelText: element['label'],
                    mandatory: element["mandatory"],
                  ),
                  cursorColor: Colors.deepPurple,
                  style: theme.typography.bodyText2.override(
                    color: theme.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: (data) {
                    setState(() {
                      element['field_value'] = data;
                      answerJson.removeWhere(
                        (item) => item['name'] == element['name'],
                      );
                      answerJson.add(element);
                    });
                  },
                ),
              ),
            ),
          ),
        );
      } else if (field['field_type'] == 'location') {
        widgetList.add(
          DynamicLocationForm(
            //  key: locationFormKey,
            locationFields: [field],
            answerJson:
                answerJson.map((e) => Map<String, dynamic>.from(e)).toList(),
            onAnswersChanged: (updatedAnswers) {
              setState(() {
                answerJson = updatedAnswers;
              });
            },
          ),
        );
      } else if (element['field_type'] == "select") {
        bool hide = FormUtils.shouldHideElement(
          element,
          answerJson.map((e) => Map<String, dynamic>.from(e)).toList(),
        );
        if (!hide) {
          List<dynamic> options = element['field_options'];
          widgetList.add(
            /*Material(
            elevation: 8,
            shadowColor: Colors.deepPurple.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),*/
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 3,
                    shadowColor: Colors.deepPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: DropdownButtonFormField(
                        validator:
                            element['mandatory']
                                ? (value) {
                                  if (value == null ||
                                      value.toString().trim().isEmpty) {
                                    return 'Mandatory Field';
                                  }
                                  return null;
                                }
                                : null,
                        isExpanded: true,
                        decoration: DecorationUtils.commonInputDecoration(
                          context: context,
                          iconData: iconData,
                          labelText: element['label'],
                          mandatory: element["mandatory"],
                        ),
                        style: theme.typography.bodyText1.override(
                          color: theme.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                        dropdownColor: Colors.grey[200],
                        iconEnabledColor: Colors.deepPurple,
                        items:
                            options.map<DropdownMenuItem<String>>((
                              dynamic value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(
                                  value.toString(),
                                  style: theme.typography.bodyText2.override(
                                    color: theme.secondaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            answerJson.removeWhere(
                              (item) => item['name'] == element['name'],
                            );
                            element['field_value'] = value;
                            answerJson.add(element);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //   )
          );
        }
      } else if (element['field_type'] == 'date') {
        bool hide = FormUtils.shouldHideElement(
          element,
          answerJson.map((e) => Map<String, dynamic>.from(e)).toList(),
        );
        if (!hide) {
          if (!dateControllers.containsKey(element['name'])) {
            dateControllers[element['name']] = TextEditingController();
          }
          TextEditingController datashower = dateControllers[element['name']]!;
          if (element['field_value'] != null &&
              element['field_value'].isNotEmpty) {
            datashower.text = element['field_value'].toString().trim();
          }

          widgetList.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 3,
                shadowColor: Colors.deepPurple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    validator:
                        element['mandatory']
                            ? (value) {
                              if (value == null || value.isEmpty) {
                                return 'Mandatory Field';
                              }
                              return null;
                            }
                            : null,
                    controller: datashower,
                    decoration: DecorationUtils.commonInputDecoration(
                      context: context,
                      iconData: iconData,
                      labelText: element['label'],
                      mandatory: element["mandatory"],
                      HintText: 'dd / mm / yyyy',
                    ),
                    readOnly: true,
                    style: theme.typography.bodyText2.override(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.secondaryText,
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate:
                            element['name'] == 'birthday_date'
                                ? DateTime.now()
                                : DateTime(2101),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Colors.deepPurple,
                              colorScheme: const ColorScheme.light(
                                primary: Colors.blue,
                                onPrimary: Colors.white,
                                surface: Colors.white,
                                onSurface: Colors.black,
                              ),
                              dialogBackgroundColor: Colors.white,
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        String formattedDate = DateFormat(
                          'dd-MM-yyyy',
                        ).format(pickedDate);
                        String formattedDate1 = DateFormat(
                          'yyyy-MM-dd 00:00:01.12345',
                        ).format(pickedDate);
                        setState(() {
                          datashower.text = formattedDate;
                          answerJson.removeWhere(
                            (item) => item['name'] == element['name'],
                          );
                          element['field_value'] =
                              formattedDate1.toString().trim();
                          answerJson.add(element);
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          );
        }
      } else if (element['name'] == 'mobile_no') {
        widgetList.add(
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Text(
              "Please share your WhatsApp number for donation updates and receipts.",
              style: theme.typography.bodyText3.override(),
            ),
          ),
        );
      } else if (element['field_type'] == 'multi-select' &&
          element['name'] == '80-g_certificate') {
        widgetList.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: showCertificateFields,
                  onChanged: (val) {
                    setState(() {
                      showCertificateFields = val ?? false;
                      answerJson.removeWhere(
                        (item) => item['name'] == element['name'],
                      );
                      element['field_value'] = val;
                      answerJson.add(element);

                      if (!showCertificateFields) {
                        // locationFormKey.currentState?.removeAnswer(
                        //   'geolocation',
                        // );
                        clearControllerValue('pan_number');
                        clearControllerValue('address');
                      }
                    });
                  },
                  activeColor: Colors.blue,
                ),
                Flexible(
                  child: Text(
                    "I would like to receive 80(G) Certificate",
                    style: theme.typography.bodyText2.override(),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    widgetList.add(
      Padding(
        padding: EdgeInsets.fromLTRB(8, 20, 8, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: /*Transform.scale(
                scale: 0.9, // Shrink checkbox size
                child: */ Checkbox(
                value: checkBoxValue,
                activeColor: Colors.blue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                onChanged: (bool? newValue) {
                  setState(() {
                    checkBoxValue = newValue!;
                  });
                },
              ),
              // ),
            ),
            SizedBox(width: 4),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: 'I have read through the websites ',
                  style: theme.typography.bodyText2.override(),
                  children: [
                    TextSpan(
                      text: 'Privacy Policy & Terms and Conditions ',
                      style: theme.typography.bodyText2.override(
                        color: Colors.blue,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: "Terms",
                                transitionDuration: Duration(milliseconds: 300),
                                pageBuilder: (_, __, ___) {
                                  return Align(
                                    alignment: Alignment.centerRight,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Center(
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.7,
                                          padding: EdgeInsets.all(16),
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 10,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Terms and Conditions",
                                                    style: theme.title3,
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.close),
                                                    onPressed:
                                                        () =>
                                                            Navigator.of(
                                                              context,
                                                            ).pop(),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: buildTermsWidgets(
                                                      context,
                                                      termsAndConditionsData,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Align(
                                                alignment: Alignment.center,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      checkBoxValue = true;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.white,
                                                      ),
                                                  child: Text(
                                                    "I Agree",
                                                    style: theme
                                                        .typography
                                                        .bodyText2
                                                        .override(
                                                          color: Colors.blue,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                transitionBuilder: (_, anim, __, child) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: Offset(1, 0),
                                      end: Offset(0, 0),
                                    ).animate(anim),
                                    child: child,
                                  );
                                },
                              );
                            },
                    ),
                    TextSpan(
                      text: ' to make a donation.',
                      style: theme.typography.bodyText2.override(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    widgetList.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 24.0),
        child: SizedBox(
          width: screenWidth * 0.25,
          height: screenHeight * 0.058,
          child: ElevatedButton(
            onPressed:
                _isSubmitting
                    ? null
                    : () async {
                      setState(() => _isSubmitting = true);

                      try {
                        List<ConnectivityResult> connectivityResult =
                            await Connectivity().checkConnectivity();

                        if (connectivityResult != ConnectivityResult.none) {
                          if (_formKey.currentState!.validate()) {}
                          if (!charityFormSubmitted) {
                            charityFormKey.currentState?.triggerSubmit();
                          }
                          if (checkBoxValue) {
                            bool totaldata = false;

                            List data =
                                answerJson.where((element) {
                                  final isMandatory =
                                      element["mandatory"] == true;
                                  final isCorrectCategory =
                                      showCertificateFields
                                          ? (element["category"] == "basic" ||
                                              element["category"] ==
                                                  "certificate")
                                          : showPanFields
                                          ? (element["category"] == "basic" ||
                                              (element["category"] ==
                                                      "certificate" &&
                                                  element["name"] ==
                                                      "pan_number"))
                                          : element["category"] == "basic";

                                  final hasNoAppearance =
                                      !element.containsKey("appearance");
                                  return isMandatory &&
                                      isCorrectCategory &&
                                      hasNoAppearance;
                                }).toList();

                            // if (data.isNotEmpty) {
                            //   List reqfields =
                            //       data.where((element) {
                            //         bool hasFieldValue =
                            //             element['field_value'] != null &&
                            //             ((element['field_value'] is String &&
                            //                     element['field_value']
                            //                         .toString()
                            //                         .trim()
                            //                         .isNotEmpty) ||
                            //                 (element['field_value'] is List &&
                            //                     element['field_value']
                            //                         .isNotEmpty) ||
                            //                 (element['field_value'] is Map &&
                            //                     element['field_value']
                            //                         .isNotEmpty));
                            //         bool isValidPhone =
                            //             element['field_type'] == 'phone' &&
                            //             element['field_value']
                            //                     .toString()
                            //                     .length ==
                            //                 10;
                            //         bool isValidEmail =
                            //             element['field_type'] == 'email' &&
                            //             RegExp(
                            //               r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                            //             ).hasMatch(
                            //               element['field_value'].toString(),
                            //             );
                            //
                            //         bool isValidPan =
                            //             element['name'] == 'pan_number' &&
                            //             RegExp(
                            //               r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$',
                            //             ).hasMatch(
                            //               element['field_value']
                            //                   .toString()
                            //                   .toUpperCase(),
                            //             );
                            //
                            //         return hasFieldValue &&
                            //             (element['field_type'] != 'phone' ||
                            //                 isValidPhone) &&
                            //             (element['field_type'] != 'email' ||
                            //                 isValidEmail) &&
                            //             (element['name'] != 'pan_number' ||
                            //                 isValidPan);
                            //       }).toList();
                            //   totaldata = data.length == reqfields.length;
                            // } else {
                            //   totaldata = true;
                            // }
                            if (data.isNotEmpty) {
                              List reqfields =
                                  data.where((element) {
                                    final fieldType = element['field_type'];
                                    final fieldValue = element['field_value'];

                                    bool hasFieldValue =
                                        fieldValue != null &&
                                        ((fieldValue is String &&
                                                fieldValue.trim().isNotEmpty) ||
                                            (fieldValue is List &&
                                                fieldValue.isNotEmpty) ||
                                            (fieldValue is Map &&
                                                fieldValue.isNotEmpty));

                                    bool isValidPhone =
                                        fieldType == 'phone' &&
                                        fieldValue.toString().length == 10;

                                    bool isValidEmail =
                                        fieldType == 'email' &&
                                        RegExp(
                                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                                        ).hasMatch(fieldValue.toString());

                                    bool isValidPan =
                                        element['name'] == 'pan_number' &&
                                        RegExp(
                                          r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$',
                                        ).hasMatch(
                                          fieldValue.toString().toUpperCase(),
                                        );

                                    bool isValidLocation =
                                        fieldType == 'location' &&
                                        element['address']
                                            .toString()
                                            .trim()
                                            .isNotEmpty &&
                                        element['city']
                                            .toString()
                                            .trim()
                                            .isNotEmpty &&
                                        element['pin_code']
                                            .toString()
                                            .trim()
                                            .isNotEmpty &&
                                        element['district']
                                            .toString()
                                            .trim()
                                            .isNotEmpty &&
                                        element['state']
                                            .toString()
                                            .trim()
                                            .isNotEmpty;

                                    return (fieldType == 'location'
                                        ? isValidLocation
                                        : hasFieldValue &&
                                            (fieldType != 'phone' ||
                                                isValidPhone) &&
                                            (fieldType != 'email' ||
                                                isValidEmail) &&
                                            (element['name'] != 'pan_number' ||
                                                isValidPan));
                                  }).toList();

                              totaldata = data.length == reqfields.length;
                            } else {
                              totaldata = true;
                            }

                            bool hasValidAmount = false;

                            if (indianCitizenshipDetails.isNotEmpty) {
                              final amountStr =
                                  indianCitizenshipDetails[0]["donation_amount"]
                                      ?.toString()
                                      .trim() ??
                                  '';
                              if (amountStr.isNotEmpty) {
                                final amount = double.tryParse(amountStr);
                                hasValidAmount = amount != null && amount > 0;
                              }
                            }

                            showAmountError = !hasValidAmount;

                            // print(totaldata);
                            // print(hasValidAmount);
                            // print(charityFormSubmitted);
                            // print("Updateddonationtoatl:");
                            // print(answerJson);
                            // print(indianCitizenshipDetails);
                            // for (var item in answerJson) {
                            //   if (item["field_type"] == "location") {
                            //     print("Location Field: ${item.toString()}");
                            //   } else {
                            //     print(
                            //       "Mandatorytest: ${item["mandatory"]}, Name: ${item["name"]}, Field Value: ${item["field_value"]}",
                            //     );
                            //   }
                            // }
                            if (totaldata &&
                                hasValidAmount &&
                                charityFormSubmitted) {
                              addAnswerJsonToCitizenshipDetails(
                                // List<Map<String, dynamic>>.from(answerJson),
                              );
                            } else {
                              SnackbarHelper.show(
                                context,
                                'Please fill in all the mandatory fields.',
                              );
                            }
                          } else {
                            SnackbarHelper.show(
                              context,
                              'Please read and accept the Terms & Conditions.',
                            );
                          }
                        } else {
                          SnackbarHelper.show(
                            context,
                            'Please check the internet connection',
                          );
                        }
                      } catch (e) {
                        SnackbarHelper.show(
                          context,
                          'An unexpected error occurred. Please try again later.',
                          bgcolor: Colors.red,
                        );
                      } finally {
                        if (mounted) setState(() => _isSubmitting = false);
                      }
                    },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child:
                !_isSubmitting
                    ? Text(
                      'Donate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                    : Center(
                      child: LoadingAnimationWidget.hexagonDots(
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
          ),
        ),
      ),
    );

    return widgetList;
  }

  Future<void> addAnswerJsonToCitizenshipDetails(
    //  List<Map<String, dynamic>> answerJson,
  ) async {
    if (indianCitizenshipDetails.isEmpty) return;

    // Step 1: Clear existing data
    indianCitizenshipDetails[0]['indian_citizenship_details'] = [];

    Map<String, dynamic> details = {};

    // Step 2: Add mobile number
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobileNumber = prefs.getString('mobile_number');
    details['mobile_no'] = mobileNumber?.toString() ?? '';

    // Step 3: Add fields from answerJson
    for (var item in answerJson) {
      if (item is Map<String, dynamic>) {
        final key = item['name'];
        final value = item['field_value'];
        if (item['field_type'] == 'location') {
          final fields = [
            'address',
            'city',
            'pin_code',
            'district',
            'state',
            'latitude',
            'longitude',
          ];

          for (var field in fields) {
            if (item[field] != null) {
              details[field] = item[field];
            }
          }
        } else {
          if (key != null && value != null) {
            details[key] = value;
          }
        }
      }
    }

    // Step 4: Add donation type and month
    details['donation_type'] =
        selectedDonationType != null
            ? donationOptions[selectedDonationType!]
            : '';
    details['donation_monthcount'] = selectedMonth?.toString() ?? '';

    // ✅ Step 5: Flatten donation_Category_list[0] into the same map
    if (donation_Category_list.isNotEmpty) {
      details.addAll(donation_Category_list[0]);
    }

    // Step 6: Assign the single flat object to the list
    indianCitizenshipDetails[0]['indian_citizenship_details'] = [details];

    // Step 7: Final confirmation
    Map<String, dynamic> finalPayload = indianCitizenshipDetails.first;
    if (finalPayload['indian_citizenship_details'] != null &&
        finalPayload['indian_citizenship_details'] is List &&
        finalPayload['indian_citizenship_details'].isNotEmpty) {
      showDonationConfirmationAlert(finalPayload);
      print("✅ finalPayload $finalPayload");
    } else {
      print("❌ Payload not ready. Skipping alert.");
    }
  }

  //============================================================================================================================================
  // ============================================================================================================================================
  // Add this method to your widget class
  void clearControllerValue(String name) {
    var existingField = answerJson.firstWhere(
      (item) => item['name'] == name,
      orElse: () => <String, dynamic>{},
    );

    if (existingField.isNotEmpty) {
      if (existingField['field_type'] == 'location') {
        // Clear all location-related fields
        existingField['field_value'] = '';
        existingField['address'] = '';
        existingField['city'] = '';
        existingField['pincode'] = '';
        existingField['district'] = '';
        existingField['state'] = '';
        existingField['latitude'] = '';
        existingField['longitude'] = '';
      } else {
        // Clear normal field
        if (existingField.containsKey('field_value') &&
            existingField['field_value'] != null &&
            existingField['field_value'].toString().trim().isNotEmpty) {
          existingField['field_value'] = '';
        }
      }
    }
  }

  void showDonationConfirmationAlert(Map<String, dynamic> finalPayload) {
    // Create formatted data for display
    Map<String, String> formattedData = formatDonationData(finalPayload);

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Donation Confirmation",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        final theme = AppTheme.of(context);

        return Align(
          alignment: Alignment.center,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 24,
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 10),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Header
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  finalPayload["indian_citizenship_details"]
                                          .isNotEmpty
                                      ? (finalPayload["indian_citizenship_details"][0]["program"] ??
                                          '')
                                      : '',
                                  style: theme.typography.bodyText1.override(
                                    color: Colors.blue,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Icon(
                                Icons.close,
                                color: Colors.blue,
                                size: 25,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        Text(
                          'Please confirm your details',
                          style: theme.typography.bodyText1.override(),
                        ),
                        const SizedBox(height: 20),

                        // Scrollable Content
                        /*   Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // Basic Information Section
                                if (_hasBasicInfo(formattedData)) ...[
                                  _buildSectionTable(
                                    'Basic Information',
                                    formattedData,
                                    [
                                      'Currency',
                                      'Donation Amount',
                                      'Citizenship Type',
                                      'Source',
                                      'Donation Type',
                                      'Monthly Count',
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],

                                // Personal Details Section
                                if (_hasPersonalInfo(formattedData)) ...[
                                  _buildSectionTable(
                                    'Personal Details',
                                    formattedData,
                                    [
                                      'Name',
                                      'Email',
                                      'PAN Number',
                                      'Address',
                                      'City',
                                      'State',
                                      'Pin Code',
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],

                                // Program Details Section
                                if (_hasProgramInfo(formattedData)) ...[
                                  _buildSectionTable(
                                    'Program Details',
                                    formattedData,
                                    [
                                      'Category',
                                      'Subcategory',
                                      'Program',
                                      'Region',
                                      '80G Certificate',
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ],
                            ),
                          ),
                        ),*/
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                _buildSectionTable(
                                  'Donation Summary',
                                  formattedData,
                                  [
                                    'Name',
                                    'Email',
                                    'PAN Number',
                                    'Donation Amount',
                                    '80G Certificate',
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        // Confirm Button
                        Center(
                          child: ElevatedButton(
                            onPressed:
                                global.isloadingindian_citizen
                                    ? null
                                    : () async {
                                      widget.onLoadingStateChanged(true);
                                      Navigator.of(context).pop();
                                      await _submitDonation(finalPayload);
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child:
                                !global.isloadingindian_citizen
                                    ? Text(
                                      'Confirm & Donate',
                                      style: theme.typography.bodyText1
                                          .override(color: Colors.white),
                                    )
                                    : Center(
                                      child: LoadingAnimationWidget.hexagonDots(
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Close Button Outside Top-Right
              // Positioned(
              //   top: 0,
              //   right: 0,
              //   child: GestureDetector(
              //     onTap: () => Navigator.of(context).pop(),
              //     child: Container(
              //       padding: const EdgeInsets.all(10),
              //       decoration: const BoxDecoration(
              //         color: Colors.white,
              //         shape: BoxShape.circle,
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.black26,
              //             blurRadius: 4,
              //             offset: Offset(2, 2),
              //           ),
              //         ],
              //       ),
              //       child: const Icon(
              //         Icons.close,
              //         color: Colors.blue,
              //         size: 20,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  Map<String, String> formatDonationData(Map<String, dynamic> payload) {
    Map<String, String> formatted = {};

    // Basic fields mapping
    Map<String, String> fieldMappings = {
      'currency_name': 'Currency',
      'donation_amount': 'Donation Amount',
      'citizenship_type': 'Citizenship Type',
    };

    // Add basic fields
    fieldMappings.forEach((key, label) {
      var value = payload[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        formatted[label] =
            key == 'donation_amount'
                ? '₹${value.toString().trim()}'
                : value.toString().trim();
      }
    });

    // Extract details from indian_citizenship_details
    if (payload['indian_citizenship_details'] != null &&
        payload['indian_citizenship_details'] is List &&
        (payload['indian_citizenship_details'] as List).isNotEmpty) {
      Map<String, dynamic> details = payload['indian_citizenship_details'][0];

      Map<String, String> detailMappings = {
        'first_name': 'Name',
        'email': 'Email',
        'pan_number': 'PAN Number',
        'address': 'Address',
        'city': 'City',
        'state': 'State',
        'pin_code': 'Pin Code',
        'donation_type': 'Donation Type',
        'donation_monthcount': 'Monthly Count',
        'category': 'Category',
        'subcategory': 'Subcategory',
        'program': 'Program',
        'region': 'Region',
        '80-g_certificate': '80G Certificate',
      };

      detailMappings.forEach((key, label) {
        var value = details[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          if (key == '80-g_certificate') {
            formatted[label] = value.toString() == "true" ? 'Yes' : 'No';
          } else if (key == 'donation_monthcount') {
            formatted[label] = '${value.toString().trim()} months';
          } else {
            formatted[label] = value.toString().trim();
          }
        }
      });
    }

    return formatted;
  }

  // Helper method to check if basic info exists
  bool _hasBasicInfo(Map<String, String> data) {
    List<String> basicFields = [
      'Currency',
      'Donation Amount',
      'Citizenship Type',
      'Source',
      'Donation Type',
      'Monthly Count',
    ];
    return basicFields.any(
      (field) => data.containsKey(field) && data[field]!.isNotEmpty,
    );
  }

  // Helper method to check if personal info exists
  bool _hasPersonalInfo(Map<String, String> data) {
    List<String> personalFields = [
      'Name',
      'Email',
      'PAN Number',
      'Address',
      'City',
      'State',
      'Pin Code',
    ];
    return personalFields.any(
      (field) => data.containsKey(field) && data[field]!.isNotEmpty,
    );
  }

  // Helper method to check if program info exists
  bool _hasProgramInfo(Map<String, String> data) {
    List<String> programFields = [
      'Category',
      'Subcategory',
      'Program',
      'Region',
      '80G Certificate',
    ];
    return programFields.any(
      (field) => data.containsKey(field) && data[field]!.isNotEmpty,
    );
  }

  // Helper method to build section table
  Widget _buildSectionTable(
    String sectionTitle,
    Map<String, String> data,
    List<String> keys,
  ) {
    // Filter keys that have actual data
    List<String> validKeys =
        keys
            .where((key) => data.containsKey(key) && data[key]!.isNotEmpty)
            .toList();

    if (validKeys.isEmpty) return SizedBox.shrink();
    final theme = AppTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Text(
            sectionTitle,
            style: theme.typography.bodyText1.override(),

            textAlign: TextAlign.center,
          ),
        ),

        // Table Content
        Material(
          elevation: 2,
          shadowColor: Colors.blue.shade100,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(2.5),
              1: FlexColumnWidth(3.5),
            },
            border: TableBorder.all(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children:
                validKeys.map((key) {
                  return TableRow(
                    decoration: const BoxDecoration(color: Colors.white),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          key,
                          style: theme.typography.bodyText2.override(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          data[key] ?? '',
                          style: theme.typography.bodyText2.override(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  // Separate API call method
  Future<void> _submitDonation(Map<String, dynamic> finalPayload) async {
    // setState(() => global.isloadingindian_citizen = true);
    //await Future.delayed(Duration(seconds: 5));

    try {
      Bloc bloc = Bloc();
      var response = await bloc.SubmitOnlineDonation(finalPayload);
      // print("API Response: $response");

      if (response["status"] == "success") {
        final donationData = response["data"];
        String fullAmount = donationData["total_donation_amount"].toString();
        String numberPart = fullAmount.split('(')[0].trim();
        String roundedAmount = (double.tryParse(numberPart) ?? 0.0)
            .toStringAsFixed(2);
        String donationRefId = donationData["donation_ref_id"] ?? '';
        String createdDate =
            donationData["created_date"]?.split('T')?.first ?? '';
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String mobileNumber = prefs.getString('mobile_number') ?? '';
        SnackbarHelper.show(
          context,
          'Donation Details submitted successfully.',
          bgcolor: Colors.green,
        );
        widget.onLoadingStateChanged(false);

        _createDonationPayment(
          donationRefId: donationRefId,
          roundedAmount: roundedAmount,
          createdDate: createdDate,
          mobileNumber: mobileNumber,
        );
        setState(() {});
      } else {
        widget.onLoadingStateChanged(false);

        SnackbarHelper.show(
          context,
          'Server Issue. Please try again later',
          bgcolor: Colors.red,
        );
      }
    } catch (e) {
      widget.onLoadingStateChanged(false);

      SnackbarHelper.show(
        context,
        'An unexpected error occurred. Please try again later.',
        bgcolor: Colors.red,
      );
    } finally {
      if (mounted) setState(() => global.isloadingindian_citizen = false);
    }
  }

  Future<void> _createDonationPayment({
    required String donationRefId,
    required String roundedAmount,
    required String createdDate,
    required String mobileNumber,
  }) async {
    final String paymentUrl = "http://3.111.159.123:9001/graphql/";
    final headers = {'Content-Type': 'application/json'};

    final requestBody = {
      "query": """
      mutation CreatePayment(\$inputpayment: PaymentInput!) {
        createPayment(inputpayment: \$inputpayment) {
          payment {
            merchantTransactionId
            PaymentID
          }
          message 
          success
          responseurl
          responsecode
        }
      }
    """,
      "variables": {
        "inputpayment": {
          "amount": roundedAmount,
          "createdby": createdDate,
          "mobileno": mobileNumber,
          "paymentmethod": "PAGE",
          "paymentcategory": "Donation",
          "redirecturl":
              "https://devextension.origa.market/mvdonationpaymentredirect?id=$donationRefId",
          "paymentcategoryrecordid": donationRefId,
        },
      },
    };

    try {
      final res = await http.post(
        Uri.parse(paymentUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      final body = jsonDecode(res.body);

      final paymentData = body["data"]["createPayment"];
      if (paymentData["success"] == true) {
        String url = paymentData["responseurl"];
        String merchantId = paymentData["payment"]["merchantTransactionId"];
        String responseCode = paymentData["responsecode"];

        if (url.isNotEmpty) {
          Bloc bloc = Bloc();
          var saveRes = await bloc.SavePayInfoDonation(
            donationRefId,
            merchantId,
            url,
            responseCode,
          );
          if (saveRes["status"] == "success") {
            widget.onNextStep(url);
          } else {
            ToastHelper.show("Server Error. Kindly check after sometime.");
          }
        } else {
          ToastHelper.show("Server Error. Kindly check after sometime.");
        }
      } else {
        ToastHelper.show("Payment creation failed: ${paymentData["message"]}");
      }
    } catch (e) {
      print("Exception: $e");
      ToastHelper.show("An unexpected error occurred.");
    }
  }
}
