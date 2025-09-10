import 'dart:convert';

import 'dart:io';
import 'dart:math';

import 'package:akshaya_pathara/Global/drawer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/*import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';*/
import 'package:ionicons/ionicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:path/path.dart' show join;
import 'package:http/http.dart' as http;

import '../Global/apptheme.dart';
import '../Global/location_class_textfield.dart';
import '../Global/location_class_textfield_new.dart' show DynamicLocationForm;

//import 'location_class_textfield.dart';

class my_account extends StatefulWidget {
  @override
  State<my_account> createState() {
    // TODO: implement createState
    return CardExample();
  }
}

class CardExample extends State<my_account> {
  @override
  CardExample();

  final _formKey = GlobalKey<FormState>();
  bool isOnline = false;
  String factory_location = '';
  bool gotLocation = false;
  String gpsLocation = '';
  String gpsAddress = '';
  String locationbuttonText = 'Get Location'.tr;
  Map<String, TextEditingController> yearControllers = {};

  /*  String state = '';
  String city = '';
  String address = '';*/
  TextEditingController address1Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  Map<String, TextEditingController> addressControllers = {
    'address_line_1': TextEditingController(),
    'address_line_2': TextEditingController(),
    'street': TextEditingController(),
    'city': TextEditingController(),
    'district': TextEditingController(),
    'state': TextEditingController(),
    'postal_code': TextEditingController(),
  };

  bool _iconLoading = false;
  List<dynamic> checkboxAns = [];
  List<dynamic> jsoncheckboxAns = [];
  List answerJson = [];
  final Map<String, String> singleSelectedStringTags = {};
  Map<String, dynamic>? singleselectedtagObject;
  final List<Map<String, dynamic>> selectedTags = [];
  final Map<String, List<String>> MultiSelectedStringTagsMap = {};
  List tempvalueList = [];

  // String selectedState = '';
  // String selectedDistrict = '';
  List<String> districts = [];
  // Map<String, dynamic> lineitemData = {};
  late String jsonData;
  late String jsonString;
  bool apiCalled = false;
  bool _isFetchingLocation = false;
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
    "Odisha",
    "Puducherry",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Tripura",
    "Uttarakhand",
    "Uttar Pradesh",
    "West Bengal",
    "Telangana",
  ];
  Map<String, TextEditingController> controllers = {};

  /* String latitude = "";
  String longitude = "";*/

  @override
  void initState() {
    quotation();

    super.initState(); //hai
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
  void quotation() {
    jsonData = '''  {
  "fields": [
  {
      "field_options": [],
      "field_icon": "",
      "field_type": "name",
      "field_value": "",
      "id": "1",
      "label": "Full Name",
      "mandatory": true,
      "name": "full_name",
      "category": "basic"
    },
     {
      "field_options": [],
      "field_icon": "",
      "field_type": "email",
      "field_value": "",
      "id": "2",
      "label": "Email ID",
      "mandatory": true,
      "name": "email",
      "category": "basic"
    },
   {
      "field_options": {},
      "field_icon": "",
      "field_type": "phone",
      "field_value": "",
      "id": "3",
      "label": "Password",
      "mandatory": true,
      "name": "password",
      "category": "basic"
    },
     {
      "field_options": {},
      "field_icon": "",
      "field_type": "phone",
      "field_value": "",
      "id": "4",
      "label": "Confirm Password",
      "mandatory": true,
      "name": "confirm_password",
      "category": "basic"
    },
    {
      "field_options": {},
      "field_icon": "",
      "field_type": "phone",
      "field_value": "",
      "id": "5",
      "label": "Mobile",
      "mandatory": true,
      "name": "mobile",
      "category": "basic"
    },
    {
      "field_options": {},
      "field_icon": "",
      "field_type": "numbercard",
      "field_value": "",
      "id": "6",
      "label": "PAN Card No",
      "mandatory": true,
      "name": "pan_card",
      "category": "basic"
    },
   {
      "field_options": [],
      "field_icon": "",
      "field_type": "text",
      "field_value": "",
      "id": "7",
      "label": "Address",
      "mandatory": true,
      "name": "address",
      "category": "basic"
    },
     {
      "field_options": [],
      "field_icon": "",
      "field_type": "phone",
      "field_value": "",
      "id": "8",
      "label": "Pincode",
      "mandatory": true,
      "name": "pincode",
      "category": "basic"
    },
     {
      "field_options": [
      "Afghanistan",
      "Albania",
      "Algeria",
      "Andorra",
      "Angola",
      "Argentina",
      "Armenia",
      "Australia",
      "Austria",
      "Azerbaijan",
      "Bahamas",
      "Bahrain",
      "Bangladesh",
      "Barbados",
      "Belarus",
      "Belgium",
      "Belize",
      "Benin",
      "Bhutan",
      "Bolivia",
      "Bosnia and Herzegovina",
      "Botswana",
      "Brazil",
      "Brunei",
      "Bulgaria",
      "Burkina Faso",
      "Burundi",
      "Cambodia",
      "Cameroon",
      "Canada",
      "Chad",
      "Chile",
      "China",
      "Colombia",
      "Comoros",
      "Congo (Brazzaville)",
      "Costa Rica",
      "Croatia",
      "Cuba",
      "Cyprus",
      "Czech Republic",
      "Denmark",
      "Djibouti",
      "Dominica",
      "Dominican Republic",
      "Ecuador",
      "Egypt",
      "El Salvador",
      "Equatorial Guinea",
      "Eritrea",
      "Estonia",
      "Eswatini",
      "Ethiopia",
      "Fiji",
      "Finland",
      "France",
      "Gabon",
      "Gambia",
      "Georgia",
      "Germany",
      "Ghana",
      "Greece",
      "Grenada",
      "Guatemala",
      "Guinea",
      "Guyana",
      "Haiti",
      "Honduras",
      "Hungary",
      "Iceland",
      "India",
      "Indonesia",
      "Iran",
      "Iraq",
      "Ireland",
      "Israel",
      "Italy",
      "Ivory Coast",
      "Jamaica",
      "Japan",
      "Jordan",
      "Kazakhstan",
      "Kenya",
      "Kiribati",
      "Kuwait",
      "Kyrgyzstan",
      "Laos",
      "Latvia",
      "Lebanon",
      "Lesotho",
      "Liberia",
      "Libya",
      "Liechtenstein",
      "Lithuania",
      "Luxembourg",
      "Madagascar",
      "Malawi",
      "Malaysia",
      "Maldives",
      "Mali",
      "Malta",
      "Mauritania",
      "Mauritius",
      "Mexico",
      "Moldova",
      "Monaco",
      "Mongolia",
      "Montenegro",
      "Morocco",
      "Mozambique",
      "Myanmar (Burma)",
      "Namibia",
      "Nepal",
      "Netherlands",
      "New Zealand",
      "Nicaragua",
      "Niger",
      "Nigeria",
      "North Korea",
      "North Macedonia",
      "Norway",
      "Oman",
      "Pakistan",
      "Palestine",
      "Panama",
      "Papua New Guinea",
      "Paraguay",
      "Peru",
      "Philippines",
      "Poland",
      "Portugal",
      "Qatar",
      "Romania",
      "Russia",
      "Rwanda",
      "Saint Kitts and Nevis",
      "Saint Lucia",
      "Saint Vincent and the Grenadines",
      "Samoa",
      "San Marino",
      "Saudi Arabia",
      "Senegal",
      "Serbia",
      "Seychelles",
      "Sierra Leone",
      "Singapore",
      "Slovakia",
      "Slovenia",
      "Solomon Islands",
      "Somalia",
      "South Africa",
      "South Korea",
      "South Sudan",
      "Spain",
      "Sri Lanka",
      "Sudan",
      "Suriname",
      "Sweden",
      "Switzerland",
      "Syria",
      "Taiwan",
      "Tajikistan",
      "Tanzania",
      "Thailand",
      "Timor-Leste",
      "Togo",
      "Tonga",
      "Trinidad and Tobago",
      "Tunisia",
      "Turkey",
      "Turkmenistan",
      "Tuvalu",
      "Uganda",
      "Ukraine",
      "United Arab Emirates",
      "United Kingdom",
      "United States",
      "Uruguay",
      "Uzbekistan",
      "Vanuatu",
      "Vatican City",
      "Venezuela",
      "Vietnam",
      "Yemen",
      "Zambia",
      "Zimbabwe"
      ],
      "field_icon": "",
      "field_type": "select",
      "field_value": "",
      "id": "9",
      "label": "Country",
      "mandatory": true,
      "name": "country",
      "category": "basic"
    },
    {
      "field_options": [
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
    "Odisha",
    "Puducherry",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Tripura",
    "Uttarakhand",
    "Uttar Pradesh",
    "West Bengal",
    "Telangana"
      ],
      "field_icon": "",
      "field_type": "select",
      "field_value": "",
      "id": "9",
      "label": "State",
      "mandatory": true,
      "name": "state",
      "category": "basic"
    },
    {
      "field_options": [],
      "field_icon": "",
      "field_type": "name",
      "field_value": "",
      "id": "9",
      "label": "City",
      "mandatory": true,
      "name": "city",
      "category": "basic"
    }
       
  ]
}

      ''';
  }

  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.1),
          child: Text('My Profile', style: theme.title1),
        ),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.black, size: 24),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
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
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.01),
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
    List<Widget> widgetList = [];
    double screenWidth = MediaQuery.of(context).size.width;
    List fields = jsonDecode(jsonData)['fields'];

    widgetList.add(SizedBox(height: 10));
    if (answerJson.length == 0) {
      answerJson = fields;
    }

    fields.forEach((ele) {
      // Map element = ele;
      Map<String, dynamic> element = Map<String, dynamic>.from(ele);
      Map<String, dynamic> field = Map<String, dynamic>.from(element);

      final theme = AppTheme.of(context);
      IconData? iconData =
          (element['field_icon'] != null && element['field_icon'].isNotEmpty)
              ? iconMapping[element['field_icon']]
              : null;
      if (element['field_type'] == 'text' ||
          element['field_type'] == 'name' ||
          element['field_type'] == 'multi-line' ||
          element['field_type'] == 'phone' ||
          element['field_type'] == 'number' ||
          element['field_type'] == 'numbercard' ||
          element['field_type'] == 'email') {
        bool hide = FormUtils.shouldHideElement(
          element,
          answerJson.map((e) => Map<String, dynamic>.from(e)).toList(),
        );
        if (!hide) {
          widgetList.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: screenWidth * 0.9,
                  child: TextFormField(
                    validator: (value) {
                      if (element["field_type"] == 'phone') {
                        if (value == null || value.toString().trim().isEmpty) {
                          return 'Mandatory Field';
                        } else if (!RegExp(
                          r'^[0-9]+$',
                        ).hasMatch(value.toString().trim())) {
                          return "Enter only digits";
                        } else if (value.toString().trim().length != 10) {
                          return "Enter valid Phone Number";
                        }
                        return null;
                      }

                      if (element["name"] == "email" ||
                          element["field_type"] == 'email') {
                        if (element["mandatory"] == true &&
                            (value == null ||
                                value.toString().trim().isEmpty)) {
                          return 'Please enter email address';
                        }
                        if (value != null &&
                            value.toString().trim().isNotEmpty &&
                            !RegExp(
                              r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                            ).hasMatch(value)) {
                          return 'Please enter valid email address';
                        }
                        return null;
                      }

                      if (element["mandatory"] == true) {
                        if (value == null || value.toString().trim().isEmpty) {
                          return 'Mandatory Field';
                        }
                      }

                      return null;
                    },
                    inputFormatters: [
                      if (element['field_type'] == 'name')
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                      else if (element['field_type'] == 'phone' ||
                          element['field_type'] == 'number')
                        FilteringTextInputFormatter.digitsOnly
                      else if (element['field_type'] == 'text' ||
                          element['field_type'] == 'multi-line')
                        FilteringTextInputFormatter.allow(
                          RegExp(
                            r'''[a-zA-Z0-9\s!@#\$%\^&\*\(\)_\+\-=\[\]\{\};:'",.<>\/\?\\|`~]''',
                          ),
                        )
                      else if (element['field_type'] == 'numbercard')
                        UppercaseAlphanumericFormatter(),
                    ],
                    decoration: DecorationUtils.commonInputDecoration(
                      context: context,
                      iconData: iconData,
                      labelText: element['label'],
                      mandatory: element["mandatory"],
                    ),
                    initialValue: element['field_value'],
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
                    style: theme.typography.bodyText2.override(
                      color: theme.secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLength: element['field_type'] == 'phone' ? 10 : null,
                    maxLines: element['field_type'] == 'multi-line' ? 2 : 1,
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
      } /*else if (element['field_type'] == 'locations') {
        widgetList.add(
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    {
                      'label': 'Enter Address'.tr,
                      'index': 0,
                    },
                    {
                      'label': 'Fetch Location'.tr,
                      'index': 1,
                    },
                  ].map((Map<String, dynamic> option) {
                    bool isSelected =
                        global.locindex == (option['index'] as int);

                    return InkWell(
                      onTap: () async {
                        setState(() {
                          global.locindex = option['index'] as int;
                          print("Global index: ${global.locindex}");

                          if (option['index'] == 1) {
                            _fetchLocation(
                                answerJson, element.cast<String, dynamic>());
                          } else {
                            setState(() {
                              _isFetchingLocation = false;
                              address1Controller.clear();
                              cityController.clear();
                              districtController.clear();
                              stateController.clear();
                              pincodeController.clear();
                            });
                          }
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey, width: 1.5),
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: [
                                    Colors.deepPurple.shade600,
                                    Colors.purpleAccent.shade100
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null, // Apply gradient only if selected
                          color: isSelected
                              ? null
                              : Colors
                                  .white, // White background when unselected
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected) // Add icon only when selected
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 18,
                              ),
                            if (isSelected)
                              SizedBox(
                                  width:
                                      6), // Add spacing only if icon is present
                            Text(
                              option['label'].toString(),
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
        widgetList.add(
          SizedBox(
            height: 20,
          ),
        );

        widgetList.add(
          _isFetchingLocation
              ? Center(
                  child: Image.asset(
                    'assets/buffer-loading.gif',
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                )
              : global.locindex == 0 || global.locindex == 1
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Material(
                              elevation: 3,
                              borderRadius: BorderRadius.circular(12),
                              child: TextFormField(
                                controller: address1Controller,
                                onChanged: (value) {
                                  setState(() {
                                    final match = answerJson.firstWhere(
                                      (item) => item['name'] == element['name'],
                                      orElse: () => {},
                                    );
                                    if (match.isNotEmpty) {
                                      match['address_line_1'] = value.trim();
                                    } else {
                                      element['address_line_1'] = value.trim();
                                      answerJson.add(
                                          Map<String, dynamic>.from(element));
                                    }
                                  });
                                },
                                validator: element['mandatory']
                                    ? (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Mandatory Field';
                                        }
                                        return null;
                                      }
                                    : null,
                                decoration:
                                    DecorationUtils.commonInputDecoration(
                                  context: context,
                                  iconData: iconData,
                                  labelText: 'Address Line',
                                  mandatory: element["mandatory"],
                                ),
                                maxLines: 1,
                                keyboardType: TextInputType.multiline,
                                style: theme.typography.bodyText2.override(
                                  color: theme.secondaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Material(
                              elevation: 3,
                              borderRadius: BorderRadius.circular(12),
                              child: TextFormField(
                                controller: cityController,
                                onChanged: (value) {
                                  setState(() {
                                    final match = answerJson.firstWhere(
                                      (item) => item['name'] == element['name'],
                                      orElse: () => {},
                                    );
                                    if (match.isNotEmpty) {
                                      match['city'] = value.trim();
                                    } else {
                                      element['city'] = value.trim();
                                      answerJson.add(
                                          Map<String, dynamic>.from(element));
                                    }
                                  });
                                },
                                validator: element['mandatory']
                                    ? (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Mandatory Field';
                                        }
                                        return null;
                                      }
                                    : null,
                                decoration:
                                    DecorationUtils.commonInputDecoration(
                                  context: context,
                                  iconData: iconData,
                                  labelText: 'City / Area'.tr,
                                  mandatory: element["mandatory"],
                                ),
                                maxLines: 1,
                                keyboardType: TextInputType.multiline,
                                style: theme.typography.bodyText2.override(
                                  color: theme.secondaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Material(
                              elevation: 3,
                              borderRadius: BorderRadius.circular(12),
                              child: TextFormField(
                                controller: pincodeController,
                                onChanged: (value) {
                                  setState(() {
                                    final match = answerJson.firstWhere(
                                      (item) => item['name'] == element['name'],
                                      orElse: () => {},
                                    );
                                    if (match.isNotEmpty) {
                                      match['pin_code'] = value.trim();
                                    } else {
                                      element['pin_code'] = value.trim();
                                      answerJson.add(
                                          Map<String, dynamic>.from(element));
                                    }
                                  });
                                },
                                */ /* onChanged: (String? newValue) async {
                                  fetchLocationFromAddress(
                                      element.cast<String, dynamic>());
                                },*/ /*
                                validator: element['mandatory']
                                    ? (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Mandatory Field';
                                        }
                                        return null;
                                      }
                                    : null,
                                decoration:
                                    DecorationUtils.commonInputDecoration(
                                  context: context,
                                  iconData: iconData,
                                  labelText: 'Pincode'.tr,
                                  mandatory: element["mandatory"],
                                ),
                                maxLength: 6,
                                keyboardType: TextInputType.multiline,
                                style: theme.typography.bodyText2.override(
                                  color: theme.secondaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Material(
                              // elevation: 8,
                              // borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Row(
                                      children: [
                                        // State Dropdown
                                        Expanded(
                                          child: Material(
                                            elevation: 3,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxWidth:
                                                    (constraints.maxWidth - 5) /
                                                        2,
                                              ),
                                              child: DropdownButtonFormField<
                                                  String>(
                                                isExpanded: true,
                                                value: states.contains(
                                                        stateController.text)
                                                    ? stateController.text
                                                    : null,
                                                onChanged:
                                                    (String? newValue) async {
                                                  setState(() {
                                                    stateController.text =
                                                        newValue!;
                                                    final match =
                                                        answerJson.firstWhere(
                                                      (item) =>
                                                          item['name'] ==
                                                          element['name'],
                                                      orElse: () => {},
                                                    );
                                                    if (match.isNotEmpty) {
                                                      match['state'] =
                                                          newValue.trim();
                                                    } else {
                                                      element['state'] =
                                                          newValue.trim();
                                                      answerJson.add(Map<String,
                                                              dynamic>.from(
                                                          element));
                                                    }
                                                  });
                                                  var connectivityResult =
                                                      await Connectivity()
                                                          .checkConnectivity();
                                                  if (connectivityResult !=
                                                      ConnectivityResult.none) {
                                                    setState(() {
                                                      isOnline = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      isOnline = false;
                                                    });
                                                  }
                                                  setState(() {
                                                    getUnifiedLeadDistricts(
                                                        stateController.text);
                                                  });
                                                },
                                                items: states.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String state) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: state,
                                                    child: Text(
                                                      state,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: theme
                                                          .typography.bodyText2
                                                          .override(
                                                        color:
                                                            theme.secondaryText,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                decoration: DecorationUtils
                                                    .commonInputDecoration(
                                                  context: context,
                                                  iconData: iconData,
                                                  labelText: 'State'.tr,
                                                  mandatory:
                                                      element["mandatory"],
                                                ),
                                                style: theme
                                                    .typography.bodyText2
                                                    .override(
                                                  color: theme.secondaryText,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 7),
                                        isOnline
                                            ? Expanded(
                                                child: Material(
                                                  elevation: 3,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                      maxWidth: (constraints
                                                                  .maxWidth -
                                                              5) /
                                                          2,
                                                    ),
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      isExpanded:
                                                          true, // Prevents text overflow

                                                      value: districts.contains(
                                                              districtController
                                                                  .text)
                                                          ? districtController
                                                              .text
                                                          : null,

                                                      onChanged: (String?
                                                          newValue) async {
                                                        setState(() {
                                                          districtController
                                                              .text = newValue!;
                                                          final match =
                                                              answerJson
                                                                  .firstWhere(
                                                            (item) =>
                                                                item['name'] ==
                                                                element['name'],
                                                            orElse: () => {},
                                                          );
                                                          if (match
                                                              .isNotEmpty) {
                                                            match['district'] =
                                                                newValue.trim();
                                                          } else {
                                                            element['district'] =
                                                                newValue.trim();
                                                            answerJson.add(Map<
                                                                    String,
                                                                    dynamic>.from(
                                                                element));
                                                          }

                                                          */ /*fetchLocationFromAddress(
                                                              element.cast<
                                                                  String,
                                                                  dynamic>());*/ /*
                                                        });
                                                      },

                                                      items: districts.map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String district) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: district,
                                                          child: Text(
                                                            district,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      decoration: DecorationUtils
                                                          .commonInputDecoration(
                                                        context: context,
                                                        iconData: iconData,
                                                        labelText:
                                                            'District'.tr,
                                                        mandatory: element[
                                                            "mandatory"],
                                                      ),

                                                      style: theme
                                                          .typography.bodyText2
                                                          .override(
                                                        color:
                                                            theme.secondaryText,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Expanded(
                                                child: Material(
                                                  elevation: 3,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                      maxWidth: (constraints
                                                                  .maxWidth -
                                                              5) /
                                                          2,
                                                    ),
                                                    child: TextFormField(
                                                      controller:
                                                          districtController,
                                                      onChanged: (String?
                                                          newValue) async {
                                                        setState(() {
                                                          districtController
                                                              .text = newValue!;
                                                          final match =
                                                              answerJson
                                                                  .firstWhere(
                                                            (item) =>
                                                                item['name'] ==
                                                                element['name'],
                                                            orElse: () => {},
                                                          );
                                                          if (match
                                                              .isNotEmpty) {
                                                            match['district'] =
                                                                newValue.trim();
                                                          } else {
                                                            element['district'] =
                                                                newValue.trim();
                                                            answerJson.add(Map<
                                                                    String,
                                                                    dynamic>.from(
                                                                element));
                                                          }
                                                          // fetchLocationFromAddress(
                                                          //     element.cast<
                                                          //         String,
                                                          //         dynamic>());
                                                        });
                                                      },
                                                      decoration: DecorationUtils
                                                          .commonInputDecoration(
                                                        context: context,
                                                        iconData: iconData,
                                                        labelText:
                                                            'District'.tr,
                                                        mandatory: element[
                                                            "mandatory"],
                                                      ),
                                                      style: theme
                                                          .typography.bodyText2
                                                          .override(
                                                        color:
                                                            theme.secondaryText,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ]),
                    )
                  : new Container(),
        );
      } */ else if (element['field_type'] == "select") {
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
              padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                                      if (value == null || value.isBlank!) {
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
      } else if (element['field_type'] == 'date_year') {
        bool hide = FormUtils.shouldHideElement(
          element,
          answerJson.map((e) => Map<String, dynamic>.from(e)).toList(),
        );
        if (!hide) {
          if (!yearControllers.containsKey(element['name'])) {
            yearControllers[element['name']] = TextEditingController();
          }

          TextEditingController yearController =
              yearControllers[element['name']]!;

          // Initialize the controller with the current value if available
          if (element['field_value'] != null &&
              element['field_value'].isNotEmpty) {
            yearController.text = element['field_value'].toString().trim();
          }

          widgetList.add(
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Material(
                elevation: 10,
                shadowColor: Colors.grey.withOpacity(0.2),
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
                    controller: yearController,
                    decoration: DecorationUtils.commonInputDecoration(
                      context: context,
                      iconData: iconData,
                      labelText: element['label'],
                      mandatory: element["mandatory"],
                    ),
                    readOnly: true,
                    style: theme.typography.bodyText2.override(
                      color: theme.secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
                    onTap:
                        () => YearPickerDialog.show(
                          context,
                          yearController,
                          element,
                          theme,
                          answerJson,
                        ),
                  ),
                ),
              ),
            ),
          );
        }
      } else if (element['field_type'] == 'single_select_tag_string') {
        final List<String> fieldOptions = List<String>.from(
          element['field_options'],
        );
        widgetList.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: element['label'],
                    style: theme.typography.bodyText1.override(
                      color: theme.primaryText,
                      fontWeight: FontWeight.w600,
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
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children:
                          fieldOptions.map((tag) {
                            final isSelected =
                                singleSelectedStringTags[element['name']] ==
                                tag;

                            return FilterChip(
                              label: Text(tag),
                              backgroundColor: Colors.white,
                              selectedColor: Colors.purple.shade50,
                              selected: isSelected,
                              labelStyle: theme.typography.bodyText2.override(
                                color: theme.secondaryText,
                                fontWeight: FontWeight.w500,
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color:
                                      isSelected ? Colors.black45 : Colors.grey,
                                  //  width: isSelected ? 2.0 : 1.0,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onSelected: (isSelected) {
                                setState(() {
                                  if (isSelected) {
                                    singleSelectedStringTags[element['name']] =
                                        tag; // Store per field
                                  } else {
                                    singleSelectedStringTags.remove(
                                      element['name'],
                                    ); // Deselect
                                  }
                                  answerJson.removeWhere(
                                    (item) => item['name'] == element['name'],
                                  );
                                  element['field_value'] =
                                      singleSelectedStringTags[element['name']] ??
                                      "";
                                  answerJson.add(element);
                                });
                              },
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (element['field_type'] == 'single_select_tag_object') {
        final List<Map<String, dynamic>> fieldOptions =
            List<Map<String, dynamic>>.from(element['field_options']);

        widgetList.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text: element['label'],
                      style: theme.typography.bodyText1.override(
                        color: theme.primaryText,
                        fontWeight: FontWeight.w600,
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
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8.0, // Horizontal spacing
                      runSpacing: 4.0, // Vertical spacing
                      children:
                          fieldOptions
                              .map(
                                (tag) => ChoiceChip(
                                  label: Text(tag['value']),
                                  labelStyle: theme.typography.bodyText2
                                      .override(
                                        color: theme.secondaryText,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  selected:
                                      singleselectedtagObject != null &&
                                      singleselectedtagObject!['id'] ==
                                          tag['id'],
                                  onSelected: (isSelected) {
                                    setState(() {
                                      if (isSelected) {
                                        singleselectedtagObject = tag;
                                      } else {
                                        singleselectedtagObject = null;
                                      }
                                      answerJson.removeWhere(
                                        (item) =>
                                            item['name'] == element['name'],
                                      );
                                      element['field_value'] =
                                          singleselectedtagObject;
                                      answerJson.add(element);
                                    });
                                  },
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (element['field_type'] == 'multi_select_tag_object') {
        final List<Map<String, dynamic>> fieldOptions =
            List<Map<String, dynamic>>.from(element['field_options']);

        widgetList.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                RichText(
                  text: TextSpan(
                    text: element['label'],
                    style: theme.typography.bodyText1.override(
                      color: theme.primaryText,
                      fontWeight: FontWeight.w600,
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
                //),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 8.0, // Horizontal spacing
                      runSpacing: 4.0, // Vertical spacing
                      children:
                          fieldOptions.map((tag) {
                            return FilterChip(
                              label: Text(tag['value']),
                              labelStyle: theme.typography.bodyText2.override(
                                color: theme.secondaryText,
                                fontWeight: FontWeight.w500,
                              ),
                              backgroundColor: Colors.white,
                              selectedColor: Colors.purple.shade50,
                              selected: selectedTags.any(
                                (selectedTag) => selectedTag['id'] == tag['id'],
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color:
                                      selectedTags.any(
                                            (selectedTag) =>
                                                selectedTag['id'] == tag['id'],
                                          )
                                          ? Colors.black45
                                          : Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Rounded corners
                              ),
                              onSelected: (isSelected) {
                                setState(() {
                                  if (isSelected) {
                                    selectedTags.add(tag);
                                  } else {
                                    // Remove the tag from the selectedTags list
                                    selectedTags.removeWhere(
                                      (selectedTag) =>
                                          selectedTag['id'] == tag['id'],
                                    );
                                  }
                                  answerJson.removeWhere(
                                    (item) => item['name'] == element['name'],
                                  );
                                  element['field_value'] = selectedTags;
                                  answerJson.add(element);
                                });
                              },
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (element['field_type'] == 'multi_select_tag_string') {
        final List<String> fieldOptions = List<String>.from(
          element['field_options'],
        );
        final String fieldName = element['name'];

        // Initialize if not already
        MultiSelectedStringTagsMap.putIfAbsent(fieldName, () => []);

        widgetList.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: element['label'],
                    style: theme.typography.bodyText1.override(
                      color: theme.primaryText,
                      fontWeight: FontWeight.w600,
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
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children:
                          fieldOptions.map((tag) {
                            final selectedTags =
                                MultiSelectedStringTagsMap[fieldName]!;
                            return FilterChip(
                              label: Text(tag),
                              labelStyle: theme.typography.bodyText2.override(
                                color: theme.secondaryText,
                                fontWeight: FontWeight.w500,
                              ),
                              backgroundColor: Colors.white,
                              selectedColor: Colors.purple.shade50,
                              selected: selectedTags.contains(tag),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color:
                                      selectedTags.contains(tag)
                                          ? Colors.black45
                                          : Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onSelected: (isSelected) {
                                setState(() {
                                  if (isSelected) {
                                    selectedTags.add(tag);
                                  } else {
                                    selectedTags.remove(tag);
                                  }
                                  answerJson.removeWhere(
                                    (item) => item['name'] == fieldName,
                                  );
                                  element['field_value'] = selectedTags;
                                  answerJson.add(Map.from(element));
                                });
                              },
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (element['field_type'] == "multi_selects") {
        List checkListItems = element['field_options'];
        final theme = AppTheme.of(context);

        widgetList.add(SizedBox(height: 20));
        widgetList.add(
          Row(
            children: [
              // Icon(Icons.note_alt_outlined, color: Colors.grey[600]),
              // SizedBox(
              //   width: 10,
              // ),
              Padding(
                padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
                child: RichText(
                  text: TextSpan(
                    text: element['label'],
                    style: theme.typography.bodyText1.override(
                      color: theme.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      element["mandatory"]
                          ? TextSpan(
                            text: ' *',
                            style: theme.typography.bodyText1.override(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                          : TextSpan(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
        widgetList.add(
          FormField<List>(
            initialValue: tempvalueList,
            validator:
                element['mandatory']
                    ? (initialValue) {
                      if (initialValue == null || initialValue.isEmpty) {
                        return 'Mandatory Field';
                      }
                      return null;
                    }
                    : null,
            builder: (FormFieldState<List> state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.start,
                    direction: Axis.horizontal,
                    children: getCheckBoxes(
                      element,
                      checkListItems,
                      element["options_type"],
                      theme,
                      state,
                    ),
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        state.errorText ?? '',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      }
      widgetList.add(SizedBox(height: 10));
    });
    widgetList.add(
      Container(
        padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              label: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.2),
                child: Text(
                  'profile update',
                  style: TextStyle(color: Colors.white, fontSize: 11),
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
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 10,
              ),
              onPressed:
                  _iconLoading
                      ? null
                      : () async {
                        setState(() {
                          _iconLoading = true;
                        });
                        bool isBasicData = true;
                        if (_formKey.currentState!.validate()) {}

                        List data =
                            answerJson
                                .where(
                                  (element) => element["mandatory"] == true,
                                )
                                .toList();

                        print("enter ========================2");

                        for (var item in answerJson) {
                          if (item.containsKey('field_value') &&
                              item.containsKey('name')) {
                            print(
                              'madiatory field Name: ${item['name']}, Field Value: ${item['field_value']}',
                            );
                          }
                        }
                        for (var item in answerJson) {
                          if (item.containsKey('name') &&
                                  item['name'] == 'geolocation' ||
                              item['name'] == 'company_location') {
                            print('Full Geolocation Element: $item');
                          }
                        }

                        if (data.isNotEmpty) {
                          List validFields =
                              data.where((element) {
                                String fieldValue =
                                    element['field_value']?.toString().trim() ??
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
                                bool isValidLocation =
                                    element['field_type'] == 'location' &&
                                    hasFieldValue;
                                if (element['field_type'] == 'location' &&
                                    !isValidLocation) {
                                  Fluttertoast.showToast(
                                    msg:
                                        "Please provide a valid address to retrieve the geolocation online, or click 'Fetch Location' to submit in offline.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.deepPurple,
                                    textColor: Colors.white,
                                  );
                                  return false;
                                }

                                return hasFieldValue &&
                                    (element['field_type'] != 'phone' ||
                                        isValidPhone) &&
                                    (element['field_type'] != 'email' ||
                                        isValidEmail);
                              }).toList();

                          if (data.length != validFields.length) {
                            isBasicData = false;
                          }
                          print("Mandatory Fields:");
                          print(data.length);
                          data.forEach(
                            (e) => print("${e['name']} : ${e['field_value']}"),
                          );

                          print(
                            "gap----------------------------------------------",
                          );

                          print("Valid Fields:");
                          print(validFields.length);

                          validFields.forEach(
                            (e) => print("${e['name']} : ${e['field_value']}"),
                          );
                        }

                        print("test 1 pass $isBasicData");

                        if (isBasicData) {
                        } else {
                          setState(() {
                            _iconLoading = false;
                          });
                          _showToast("Kindly fill all the fields correctly");
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

  getCheckBoxes(
    data,
    checkListItems,
    options_type,
    AppTheme theme,
    FormFieldState<List> state,
  ) {
    List<Widget> checkList = [];
    List tempList =
        answerJson.where((item) => item['name'] == data['name']).toList();
    List tempvalueList = [];

    if (tempList.isNotEmpty &&
        tempList[0]['field_value'] != null &&
        tempList[0]['field_value'].toString().trim().isNotEmpty) {
      tempvalueList = tempList[0]['field_value'] as List;
    }

    checkListItems.forEach((element) {
      checkList.add(
        Theme(
          data: ThemeData(unselectedWidgetColor: Colors.deepPurple),
          child: Checkbox(
            value:
                (options_type == "string"
                    ? tempvalueList.contains(element)
                    : tempvalueList.toString().contains(element.toString())),
            checkColor: Colors.white,
            activeColor: Colors.deepPurple,
            onChanged: (value) {
              setState(() {
                if (options_type == "string") {
                  if (!checkboxAns.contains(element)) {
                    checkboxAns.add(element);
                  } else {
                    checkboxAns.remove(element);
                  }
                  data['field_value'] = checkboxAns;
                  state.didChange(
                    checkboxAns,
                  ); // Correctly call didChange on state
                } else {
                  if (!jsoncheckboxAns.toString().contains(
                    element.toString(),
                  )) {
                    jsoncheckboxAns.add(element);
                  } else {
                    jsoncheckboxAns.removeWhere(
                      (item) => item['id'] == element['id'],
                    );
                  }
                  data['field_value'] = jsoncheckboxAns;
                  state.didChange(
                    jsoncheckboxAns,
                  ); // Correctly call didChange on state
                }
                answerJson.removeWhere((item) => item['name'] == data['name']);
                answerJson.add(data);
              });
            },
          ),
        ),
      );

      checkList.add(
        Container(
          width: MediaQuery.of(context).size.width / 1.2,
          child: Padding(
            padding: EdgeInsets.only(right: 12),
            child: Text(
              options_type == "string" ? element : element["value"],
              style: theme.typography.bodyText2.override(
                color: theme.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
    return checkList;
  }

  Future<void> getUnifiedLeadDistricts(String state) async {
    print("INSIDE getUnifiedLeadsDistricts");
    print("State: ${state}");

    districts = [];
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //Bloc bloc = Bloc();
      // Map res = await bloc.fetchUnifiedLeadsDistricts(state);
      Map res = {};
      if (res.containsKey('district_list') && res['district_list'] is List) {
        List jdata = res['district_list'];

        Set<String> uniqueDistricts = {};
        for (var element in jdata) {
          if (element["district_name"] != null &&
              element["district_name"].trim().isNotEmpty) {
            uniqueDistricts.add(element["district_name"]);
          }
        }

        setState(() {
          districts = uniqueDistricts.toList();
        });
      } else {
        print("district_list is null or not a List");
      }
    } else {
      _showToast("Check your Internet connection");
    }
  }
}

class UppercaseAlphanumericFormatter extends TextInputFormatter {
  final _regExp = RegExp(r'[A-Z0-9]');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final filtered = newValue.text.toUpperCase().replaceAll(
      RegExp(r'[^A-Z0-9]'),
      '',
    );

    // Keep the cursor at the end of the new text
    final newSelection = TextSelection.collapsed(offset: filtered.length);

    return TextEditingValue(text: filtered, selection: newSelection);
  }
}

class DecorationUtils {
  static InputDecoration commonInputDecoration({
    required BuildContext context,
    IconData? iconData,
    required String labelText,
    bool mandatory = false,
    String? HintText,
  }) {
    final theme = AppTheme.of(context);

    return InputDecoration(
      prefixIcon:
          iconData != null
              ? Icon(iconData, color: Colors.deepPurple, size: 18)
              : null,
      label: RichText(
        text: TextSpan(
          text: labelText,
          style: theme.typography.bodyText1.override(
            color: theme.primaryText,
            fontWeight: FontWeight.w400,
          ),
          children: [
            if (mandatory)
              TextSpan(
                text: ' *',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
      hintText: HintText,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade100),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 0.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 0.5),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple),
      ),
      //errorText: errorText,
      errorStyle: theme.typography.bodyText1.override(
        color: Colors.red,
        fontSize: 10,
      ),
      counterText: '',
    );
  }
}

class FormUtils {
  static bool shouldHideElement(
    Map<String, dynamic> element,
    List<Map<String, dynamic>> answerJson,
  ) {
    bool hide = false;

    if (element.containsKey("appearance")) {
      hide = true;
      Map<String, dynamic> appearance = Map<String, dynamic>.from(
        element['appearance'],
      );
      List<Map<String, dynamic>> data = [];

      appearance.keys.forEach((key) {
        data.addAll(answerJson.where((item) => item['name'] == key));
      });

      if (appearance.length == data.length && data.isNotEmpty) {
        try {
          for (var ele in data) {
            if (ele['field_value'].toString().contains(
              appearance[ele['name']].toString(),
            )) {
              hide = false;
            } else {
              hide = true;
              throw 'STOP';
            }
          }
        } catch (e) {
          print("Caught exception: $e");
        }
      }
    }

    return hide;
  }
}

class YearPickerDialog {
  static Future<void> show(
    BuildContext context,
    TextEditingController controller,
    Map element,
    dynamic theme,
    List answerJson,
  ) async {
    DateTime selectedDate = DateTime.now();

    await showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            title: Center(
              child: Text(
                "Select Year",
                style: TextStyle(
                  color: theme.primaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            content: StatefulBuilder(
              builder:
                  (BuildContext context, StateSetter setState) => SizedBox(
                    width: 250,
                    height: 250,
                    child: Theme(
                      data: ThemeData.light().copyWith(
                        textTheme: TextTheme(
                          bodySmall: TextStyle(
                            color: theme.primaryText,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      child: YearPicker(
                        firstDate: DateTime(DateTime.now().year - 200),
                        lastDate: DateTime(DateTime.now().year),
                        initialDate: selectedDate,
                        selectedDate: selectedDate,
                        onChanged: (DateTime dateTime) {
                          setState(() {
                            selectedDate = dateTime;
                          });
                        },
                      ),
                    ),
                  ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: theme.secondaryText,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      String selectedYear = selectedDate.year.toString();
                      controller.text = selectedYear;
                      answerJson.removeWhere(
                        (item) => item['name'] == element['name'],
                      );
                      element['field_value'] = selectedYear;
                      answerJson.add(element);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(
                        color: theme.secondaryText,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }
}
