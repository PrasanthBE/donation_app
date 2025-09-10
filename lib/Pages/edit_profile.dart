import 'dart:convert';

import 'dart:io';

import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:akshaya_pathara/Global/bloc.dart';
import 'package:akshaya_pathara/Global/drawer.dart';
import 'package:akshaya_pathara/Global/location_class_textfield.dart';
import 'package:akshaya_pathara/Global/location_class_textfield_new.dart';
import 'package:akshaya_pathara/Pages/dashboard.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:path/path.dart' show join;

class edit_profile_page extends StatefulWidget {
  // String mobile_number;

  edit_profile_page({Key? key /*required this.mobile_number*/})
    : super(key: key);

  @override
  State<edit_profile_page> createState() {
    // TODO: implement createStates
    return CardExample();
  }
}

class CardExample extends State<edit_profile_page> {
  @override
  CardExample();

  final _formKey = GlobalKey<FormState>();

  String factory_location = '';
  bool gotLocation = false;
  String gpsLocation = '';
  String gpsAddress = '';
  String locationbuttonText = 'Get Location'.tr;
  String state = '';
  String city = '';
  String address = '';
  bool _iconLoading = false;
  List<dynamic> checkboxAns = [];
  List<dynamic> jsoncheckboxAns = [];
  List answerJson = [];
  String selectedState = '';
  String selectedDistrict = '';
  List<String> districts = [];
  // Map<String, dynamic> lineitemData = {};
  late String jsonData;
  late String jsonString;
  bool apiCalled = false;
  //phone num
  /* TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();*/
  TextEditingController mobiles = TextEditingController();
  // TextEditingController Addaddress = TextEditingController();
  String name = 'Guest User';
  String email = "";
  String enginner = "";
  String company_name = "";
  String mobileNumber = 'No mobile number';
  List<String> Addaddress = [];
  late String? fcm_token;
  List fields = [];
  Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    quotation();
    loadUserDetails();
    parseJsonAndInitializeControllers();
    //mobiles.text = widget.mobile_number;
    print("mobile&");
    //  print(widget.mobile_number);
    super.initState(); //hai
  }

  List<String> states = [
    "Andaman and Nicobar Islands",
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chandigarh",
    "Chhattisgarh",
    "Dadra and Nagar Haveli",
    "Daman and Diu",
    "Delhi",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Lakshadweep",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Orissa",
    "Puducherry",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Tripura",
    "Uttarakhand",
    "Uttar Pradesh",
    "West Bengal",
    "Seemandhra",
    "Telangana",
  ];

  Map<String, IconData> iconMapping = {
    'phone': Icons.check_circle,
    'email': Ionicons.mail_outline,
    'person': Ionicons.person_outline,
    'enginner': Icons.engineering_outlined,
    'organization': Ionicons.business_outline,
  };
  Map<String, String> Prefilllist = {
    "name": "Prakash",
    "organization_name": "Origa Foundation",
    "email": "prakash@gmail.com",
    "mobile": "9361696509",
  };
  void parseJsonAndInitializeControllers() {
    fields = List<Map<String, dynamic>>.from(jsonDecode(jsonData)['fields']);

    for (var field in fields) {
      String name = field['name'];
      String prefillValue = Prefilllist[name] ?? '';
      field['field_value'] = prefillValue;
      controllers[name] = TextEditingController(text: prefillValue);
    }
    answerJson = fields.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  void quotation() {
    jsonData = '''  {
      "fields": [
      {
          "field_options": [],
          "field_icon": "person",
          "field_type": "text",
          "field_value": "",
          "id": "1",
          "label": "Name",
          "mandatory": true,
          "name": "name",
          "category":"basic"
        },
        {
          "field_options": [],
          "field_icon": "organization",
          "field_type": "text",
          "field_value": "",
          "id": "2",
          "label": "Organization Name",
          "mandatory": false,
          "name": "organization_name",
          "category":"basic"
        },
      
        {
          "field_options": {},
           "field_icon": "email",
          "field_type": "email",
          "field_value": "",
          "id": "3",
          "label": "Email ID",
          "mandatory": false,
          "name": "email",
          "category":"basic"
        },
        {
          "field_options": {},
          "field_icon": "phone",
          "field_type": "phone",
          "field_value": "${mobiles.text}",
          "id": "4",
          "label": "Mobile Number",
          "mandatory": false,     
          "name": "mobile",
          "category":"basic"
        }, 
        {
     "field_options": [],
     "field_icon": "",
     "field_type": "location",
      "address_line_1": "",
      "city": "",
      "pin_code": "",
      "district": "",
      "state": "",
      "latitude": "",
      "longitude": "",
      "id": "6",
      "label": "",
      "mandatory": true,
      "name": "company_location",
      "category": "basic"
    } 
       
      ]
    }
    ''';
  }

  Future<void> loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'Prakash';
      mobileNumber = prefs.getString('mobile_number') ?? '9952271804';
      mobiles.text = mobileNumber;
    });
  }

  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Center(
          child: Text(
            'Edit Profile',
            style: theme.title3,
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.menu, color: Colors.black87),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      drawer: AppDrawer(currentPage: 'my_account'),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ), // Add some padding to the body
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade400,
                      ),
                      child: const Icon(
                        Ionicons.person,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Name and mobile number on the right
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: theme.title3),
                        const SizedBox(height: 4),
                        Text(
                          mobileNumber,
                          style: theme.typography.bodyText2.override(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                child: Text(
                  "Keep your profile updated. it builds trust and encourages others to follow your generous example.",
                  style: theme.typography.bodyText2.override(
                    fontSize: 12,
                    color: Colors.blue,
                    height: 1.8,
                  ),

                  textAlign: TextAlign.center,
                ),
              ),
              // Center(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Text("Edit Profile", style: theme.title1),
              //       SizedBox(height: 20),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text(
              //           "Keep your profile updated \n it builds trust and encourages others to follow your generous example.",
              //           style: theme.typography.bodyText2.override(
              //             fontSize: 13,
              //             color: Colors.grey,
              //             height: 1.8,
              //           ),
              //
              //           textAlign: TextAlign.center,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: getWidgets(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getWidgets() {
    final theme = AppTheme.of(context);

    List<Widget> widgetList = [];
    double screenWidth = MediaQuery.of(context).size.width;
    fields = jsonDecode(jsonData)['fields'];
    widgetList.add(SizedBox(height: 30));
    if (answerJson.length == 0) {
      answerJson = fields;
    }

    fields.forEach((ele) {
      Map element = ele;
      Map<String, dynamic> field = Map<String, dynamic>.from(element);

      IconData? iconData =
          (element['field_icon'] != null && element['field_icon'].isNotEmpty)
              ? iconMapping[element['field_icon']]
              : null;
      if (element['field_type'] == 'text' ||
          element['field_type'] == 'multi-line text' ||
          element['field_type'] == 'phone' && element['name'] != 'mobile' ||
          element['field_type'] == 'number' ||
          element['field_type'] == 'email') {
        widgetList.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 0,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: screenWidth * 0.9,
                child: TextFormField(
                  validator: (value) {
                    if (element["name"] == "phone") {
                      if (value == null || value.isEmpty) {
                        return 'Mandatory Field';
                      } else if (value.trim().length != 10) {
                        return "Enter valid Phone Number";
                      }
                      return null;
                    }

                    if (element["name"] == "email" ||
                        element["field_type"] == 'email') {
                      if (element["mandatory"] == true &&
                          (value == null || value.toString().trim().isEmpty)) {
                        return 'Please enter email address';
                      }
                      if (value != null &&
                          value.toString().trim().isNotEmpty &&
                          !RegExp(
                            r"^[a-zA-Z0-9 ._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                          ).hasMatch(value)) {
                        return 'Please enter valid email address';
                      }
                      return null;
                    }
                    if (element["mandatory"] == true) {
                      if (value == null || value.toString().trim().isEmpty) {
                        return 'Please enter ${element['label']}';
                      }
                    }

                    return null; // If no validation errors
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(iconData, color: Colors.blue, size: 22),
                    label: RichText(
                      text: TextSpan(
                        text: element['label'],
                        style: theme.typography.bodyText1.override(
                          color: theme.primaryText,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          if (element["mandatory"])
                            TextSpan(
                              text: ' *',
                              style: theme.typography.bodyText1.override(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    errorStyle: theme.typography.bodyText3.override(
                      color: Colors.red,
                      fontSize: 10,
                    ),
                  ),
                  controller: controllers[element['name']],

                  cursorColor: Colors.deepPurple,
                  keyboardType:
                      element['field_type'] == 'email'
                          ? TextInputType.emailAddress
                          : element['field_type'] == 'phone'
                          ? TextInputType.phone
                          : element['field_type'] == 'number'
                          ? TextInputType.number
                          : element['field_type'] == 'multi-line text'
                          ? TextInputType.multiline
                          : TextInputType.text,
                  inputFormatters:
                      element['field_type'] == 'phone' ||
                              element['field_type'] == 'number'
                          ? [FilteringTextInputFormatter.digitsOnly]
                          : element['name'] == 'company_name' ||
                              element['name'] == 'name'
                          ? [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z. ]'),
                            ),
                          ]
                          : element['field_type'] == 'text'
                          ? [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9 @&/,._-]'),
                            ),
                          ]
                          : null,
                  style: theme.typography.bodyText2.override(
                    color: theme.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLength: element['field_type'] == 'phone' ? 10 : null,
                  maxLines: element['field_type'] == 'multi-line text' ? 5 : 1,
                  onChanged: (String data) {
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
      } else if (element['name'] == 'mobile') {
        widgetList.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 0,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: screenWidth * 0.9,
                child: TextFormField(
                  readOnly: true,
                  controller: controllers[element['name']],
                  validator:
                      element["field_type"] == 'phone'
                          ? (value) {
                            if (element["mandatory"] == true &&
                                (value == null ||
                                    value.toString().trim().isEmpty)) {
                              return 'Please enter phone number';
                            }
                            if (value != null &&
                                value.toString().trim().isNotEmpty &&
                                value.toString().trim().length != 10) {
                              return 'Please enter valid 10 digit number';
                            }
                            return null;
                          }
                          : null,
                  decoration: InputDecoration(
                    prefixIcon: Icon(iconData, color: Colors.blue, size: 22),
                    label: RichText(
                      text: TextSpan(
                        text: element['label'],
                        style: theme.typography.bodyText1.override(
                          color: theme.primaryText,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          if (element["mandatory"])
                            TextSpan(
                              text: ' *',
                              style: theme.typography.bodyText1.override(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: theme.typography.bodyText3.override(
                      color: Colors.red,
                      fontSize: 10,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    counterText: '',
                  ),

                  cursorColor: Colors.deepPurple,
                  keyboardType: TextInputType.phone,
                  style: theme.typography.bodyText2.override(
                    color: theme.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),

                  maxLength: 10,
                  onChanged: (String data) {
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
      } else if (element['field_type'] == "select") {
        bool hide = false;
        if (element.keys.contains("appearance")) {
          hide = true;
          Map appearance = element['appearance'];
          List data = [];

          appearance.keys.forEach((element) {
            data.addAll(
              answerJson.where((item) => item['name'] == element).toList(),
            );
          });

          if (appearance.length == data.length) {
            if (data.length > 0) {
              try {
                data.forEach((ele) {
                  if (ele['field_value'].toString().contains(
                    appearance[ele['name']].toString(),
                  )) {
                    hide = false;
                  } else {
                    hide = true;
                    throw 'STOP';
                  }
                });
              } catch (e) {
                print("CATCHED - " + e.toString());
              }
            }
          }
        }

        if (!hide) {
          List<dynamic> options = element['field_options'];
          widgetList.add(
            /*Material(
            elevation: 8,
            shadowColor: Colors.deepPurple.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),*/
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Material(
                        elevation: 0,
                        shadowColor: Colors.deepPurple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: DropdownButtonFormField(
                            validator:
                                element['mandatory']
                                    ? (value) {
                                      if (value == null || value.isBlank!) {
                                        return 'Mandatory Field';
                                      }
                                      return null;
                                    }
                                    : null,
                            isExpanded: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                iconData,
                                color: Colors.deepPurple.shade100,
                                size: 22,
                              ),
                              label: RichText(
                                text: TextSpan(
                                  text: element['label'],
                                  style: theme.typography.bodyText1.override(
                                    color: theme.primaryText,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: [
                                    if (element["mandatory"])
                                      TextSpan(
                                        text: ' *',
                                        style: theme.typography.bodyText1
                                            .override(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                  ],
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              errorStyle: theme.typography.bodyText3.override(
                                color: Colors.red,
                                fontSize: 10,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.blue.shade300,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 1.0,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                ),
                              ),
                              counterText: '',
                            ),
                            style: theme.typography.bodyText1.override(
                              color: theme.primaryText,
                              fontWeight: FontWeight.w400,
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
                                      style: theme.typography.bodyText2
                                          .override(color: theme.secondaryText),
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
                ],
              ),
            ),
            //   )
          );
        }
      } else if (field['field_type'] == 'location') {
        widgetList.add(
          DynamicLocationForm(
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
      }
      widgetList.add(SizedBox(height: 10));
    });
    widgetList.add(SizedBox(height: 30));
    widgetList.add(
      Container(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              label: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.2),
                child: Text(
                  'Update',
                  style: theme.typography.bodyText2.override(
                    color: Colors.white,
                  ),
                ),
              ),
              icon:
                  _iconLoading
                      ? SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.black,
                          ),
                        ),
                      )
                      : const Icon(Icons.verified, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6366F1),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed:
                  _iconLoading
                      ? null
                      : () async {
                        setState(() {
                          _iconLoading = true;
                        });

                        if (_formKey.currentState!.validate()) {
                          print("mandiatorrr");
                          print(
                            "================Submitfactory================",
                          );
                          print(answerJson);

                          List data =
                              answerJson
                                  .where(
                                    (element) => element["mandatory"] == true,
                                  )
                                  .toList();

                          bool isBasicData = true;

                          if (data.isNotEmpty) {
                            List validFields =
                                data.where((element) {
                                  String fieldValue =
                                      element['field_value']
                                          ?.toString()
                                          .trim() ??
                                      '';
                                  bool hasFieldValue = fieldValue.isNotEmpty;

                                  bool isValidPhone =
                                      element['field_type'] == 'phone' &&
                                      fieldValue.length == 10;
                                  bool isValidEmail =
                                      element['field_type'] == 'email' &&
                                      RegExp(
                                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                                      ).hasMatch(fieldValue);

                                  return hasFieldValue &&
                                      (element['field_type'] != 'phone' ||
                                          isValidPhone) &&
                                      (element['field_type'] != 'email' ||
                                          isValidEmail);
                                }).toList();

                            // If all mandatory fields are valid, isBasicData will remain true
                            if (data.length != validFields.length) {
                              isBasicData = false;
                            }
                          }

                          print("test 1 pass");
                          print(isBasicData);

                          if (isBasicData) {
                            for (var item in answerJson) {
                              if (item.containsKey('field_value') &&
                                  item.containsKey('name')) {
                                print(
                                  'Name: ${item['name']}, Field Value: ${item['field_value']}',
                                );
                                if (item['name'] == 'name') {
                                  name = item['field_value'].toString().trim();
                                } else if (item['name'] == 'email') {
                                  email = item['field_value'].toString().trim();
                                } else if (item['name'] == 'company_name') {
                                  company_name =
                                      item['field_value'].toString().trim();
                                } else if (item['name'] == 'engineer_type') {
                                  enginner =
                                      item['field_value'].toString().trim();
                                }
                              }
                            }

                            // print('Extracted Name: $name');
                            // print('Extracted Email: $email');
                            // print('Extracted address: $company_name');
                            // print('Extracted address: $enginner');
                            // print('Extracted address: ${mobiles.text}');

                            // print('Extracted address: $Addaddress');
                            //print('Extracted fcm: $fcm_token');
                            String result = Addaddress.join(', ');
                            // print('Extracted address: $result');

                            Bloc bloc = new Bloc();
                            // Map res = await bloc.saveEnggDetails(
                            //   name,
                            //   company_name,
                            //   email,
                            //   mobiles.text,
                            //   fcm_token,
                            //   enginner,
                            // );

                            // if (res["body"] != null &&
                            //     res["body"]["status"] == "Successful") {
                            Fluttertoast.showToast(
                              msg: "Success",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.deepPurple,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('name', name);
                            prefs.setString('email', email);
                            prefs.setString(
                              'mobile_number',
                              mobiles.text.trim(),
                            );

                            setState(() {
                              _iconLoading = false;
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DonationDashboard(),
                              ),
                            );
                            // } else {
                            //   setState(() {
                            //     _iconLoading = false;
                            //   });
                            //   Fluttertoast.showToast(
                            //     msg: res["msg"],
                            //     toastLength: Toast.LENGTH_SHORT,
                            //     gravity: ToastGravity.BOTTOM,
                            //     timeInSecForIosWeb: 1,
                            //     backgroundColor: Colors.deepPurple,
                            //     textColor: Colors.white,
                            //     fontSize: 16.0,
                            //   );
                            // }
                          } else {
                            setState(() {
                              _iconLoading = false;
                            });
                            _showToast("Kindly fill all the fields correctly");
                          }
                        } else {
                          setState(() {
                            _iconLoading = false;
                          });
                          _showToast("Kindly fill all the fields");
                        }
                      },
            ),
          ],
        ),
      ),
    );

    return widgetList;
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.deepPurple,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
