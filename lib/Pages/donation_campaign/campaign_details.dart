import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:akshaya_pathara/Global/bloc.dart';
import 'package:akshaya_pathara/Global/terms_conditions.dart';
import 'package:akshaya_pathara/Global/toast.dart';
import 'package:akshaya_pathara/Pages/my_account.dart';
import 'package:akshaya_pathara/Pages/online_donation_branch/alert_box_donation.dart';
import 'package:akshaya_pathara/Pages/online_donation_form.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Campaign_details extends StatefulWidget {
  final int currentStepIndex;
  final VoidCallback? onNextStep;

  const Campaign_details({
    required this.currentStepIndex,
    this.onNextStep,
    super.key,
  });
  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<Campaign_details> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    quotation();
    parseJsonAndInitializeControllers();
    // TODO: implement initState
    super.initState();
  }

  List fields = [];
  int? selectedDonationType = 0;
  int? selectedMonth;
  late String jsonData;
  List answerJson = [];
  Map<String, TextEditingController> dateControllers = {};
  double? selectedAmount;
  List<Map<String, dynamic>> indianCitizenshipDetails = [];
  bool showAmountError = false;

  bool _isSubmitting = false;
  bool showCertificateFields = false;
  bool checkBoxValue = false;
  List<String> donationOptions = ['Donate Once', 'Donate Monthly'];
  List<int> monthOptions = List.generate(12, (index) => index + 1); // 1 to 12
  final TextEditingController customAmountController = TextEditingController();
  List<Map<String, String>> imagelist = [];
  final List<double> predefinedAmounts = [
    4500,
    9000,
    13500,
    18000,
    24000,
    30000,
    37500,
    45000,
    60000,
    75000,
    90000,
    105000,
    150000,
    201000,
  ];
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
  /*  void parseJsonAndInitializeControllers() {
    fields.addAll(
      List<Map<String, dynamic>>.from(jsonDecode(jsonData)['fields']),
    );
    for (var field in fields) {
      controllers[field['name']] = TextEditingController();
    }
  }*/
  Map<String, String> Prefilllist = {
    "full_name": "Prakash",
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
          "field_icon": "",
          "field_type": "text",
          "field_value": "",
          "id": "1",
          "label": "Full Name",
          "mandatory": true,
          "name": "full_name",
          "category":"basic"
        },
   {
          "field_options": [],
          "field_icon": "person",
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
          "field_options": {},
          "field_icon": "",
          "field_type": "phone",
          "field_value": "",
          "id": "4",
          "label": "Mobile Number",
          "mandatory": false,     
          "name": "mobile",
          "category":"basic"
        },
   {
      "field_options": ["Mid Day Meal","Homeless Mothers","Anganwadi Programs","Maha Kumbh Mela"],
      "field_icon": "",
      "field_type": "select",
      "field_value": "",
      "id": "1",
      "label": "Select Campaign",
      "mandatory": true,
      "name": "campaign_type",
      "category": "campaign"
    },
     {
      "field_options": [],
      "field_icon": "",
      "field_type": "name",
      "field_value": "",
      "id": "2",
      "label": "Campaign Name",
      "mandatory": true,
      "name": "campaign_name",
      "category": "campaign"
    },
     {
      "field_options": {},
      "field_icon": "",
      "field_type": "number",
      "field_value": "",
      "id": "4",
      "label": "How much do you wish to raise",
      "mandatory": true,
      "name": "raise_amount",
      "category": "campaign"
    },
    {
      "field_options": {},
      "field_icon": "",
      "field_type": "date",
      "field_value": "",
      "id": "3",
      "label": "Start Date",
      "mandatory": true,
      "name": "start_date",
      "category": "campaign"
    },
     {
      "field_options": {},
      "field_icon": "",
      "field_type": "date",
      "field_value": "",
      "id": "5",
      "label": "End Date",
      "mandatory": true,
      "name": "end_date",
      "category": "campaign"
    },
    
    {
      "field_options": {},
      "field_icon": "",
      "field_type": "multi-line",
      "field_value": "",
      "id": "6",
      "label": "Description",
      "mandatory": true,
      "name": "description",
      "category": "campaign"
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

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Column(
      children: [
        if (widget.currentStepIndex == 2)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 60),
                SizedBox(height: 12),
                Text("Thank You", style: theme.title1.copyWith(fontSize: 22)),
                SizedBox(height: 8),
                Text(
                  "Success!",
                  style: theme.title3.copyWith(color: Colors.green),
                ),
                SizedBox(height: 16),
                Text(
                  "Thanks for creating an online campaign to feed hungry children. Your campaign is pending approval subject to a review by the admin. You will be intimated about the activation via mail.",
                  style: theme.bodyText2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          Form(key: _formKey, child: Column(children: getWidgets())),
      ],
    );
  }

  getWidgets() {
    final theme = AppTheme.of(context);

    List<Widget> widgetList = [];
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    fields = jsonDecode(jsonData)['fields'];

    widgetList.add(SizedBox(height: 10));

    if (answerJson.isEmpty) {
      answerJson = fields;
    }

    for (var ele in fields) {
      Map<String, dynamic> element = Map<String, dynamic>.from(ele);
      if (widget.currentStepIndex == 0 && element['category'] != 'basic') {
        continue;
      } else if (widget.currentStepIndex == 1 &&
          element['category'] != 'campaign') {
        continue;
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
      if (element['name'] == 'start_date') {
        widgetList.add(
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(8),
            child: Text(
              "You have options to select only maximum 3 month. If you want to select more than 3 months, after creating the campaign you can send a request to admin.",
              style: theme.typography.bodyText3.override(),
            ),
          ),
        );
      }
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
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: screenWidth * 0.9,
                child: TextFormField(
                  controller: controllers[element['name']],

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
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    if (fieldType == 'phone' || fieldType == 'number')
                      FilteringTextInputFormatter.digitsOnly,
                    if (fieldType == 'text' || fieldType == 'multi-line')
                      FilteringTextInputFormatter.allow(
                        RegExp(
                          r'''[a-zA-Z0-9 \s!@#\$%\^&\*\(\)_\+\-=\[\]\{\};:'",.<>\/\?\\|`~]''',
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
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
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
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
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

                        // print("pickdate");
                        // print(datashower.text);
                        // print(element);
                      }
                    },
                  ),
                ),
              ),
            ),
          );
        }
      }
    }
    widgetList.add(
      widget.currentStepIndex == 1
          ? Column(children: [PhotoSelectorWidget(imagelist: imagelist)])
          : const SizedBox(),
    );

    widgetList.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 20.0),
        child: SizedBox(
          width: screenWidth * 0.45,
          // height: screenHeight * 0.058,
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
                          if (!_formKey.currentState!.validate()) {
                            /* SnackbarHelper.show(
                              context,
                              'Please',
                              bgcolor: Colors.orange.shade700,
                            );
                            return;*/
                          }

                          bool totaldata = false;

                          List data =
                              answerJson.where((element) {
                                final isMandatory =
                                    element["mandatory"] == true;
                                final isCorrectCategory =
                                    widget.currentStepIndex == 0
                                        ? element["category"] == "basic"
                                        : widget.currentStepIndex == 1
                                        ? element["category"] == "campaign"
                                        : false;
                                final hasNoAppearance =
                                    !element.containsKey("appearance");
                                return isMandatory &&
                                    isCorrectCategory &&
                                    hasNoAppearance;
                              }).toList();

                          if (data.isNotEmpty) {
                            List reqfields =
                                data.where((element) {
                                  bool hasFieldValue =
                                      element['field_value'] != null &&
                                      ((element['field_value'] is String &&
                                              element['field_value']
                                                  .toString()
                                                  .trim()
                                                  .isNotEmpty) ||
                                          (element['field_value'] is List &&
                                              element['field_value']
                                                  .isNotEmpty) ||
                                          (element['field_value'] is Map &&
                                              element['field_value']
                                                  .isNotEmpty));

                                  bool isValidPhone =
                                      element['field_type'] == 'phone' &&
                                      element['field_value']
                                              .toString()
                                              .length ==
                                          10;

                                  bool isValidEmail =
                                      element['field_type'] == 'email' &&
                                      RegExp(
                                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                                      ).hasMatch(
                                        element['field_value'].toString(),
                                      );

                                  return hasFieldValue &&
                                      (element['field_type'] != 'phone' ||
                                          isValidPhone) &&
                                      (element['field_type'] != 'email' ||
                                          isValidEmail);
                                }).toList();

                            totaldata = data.length == reqfields.length;
                            print("totaldatatotaldata");
                            print(totaldata);
                            print(data.length);
                            print(reqfields.length);
                          }
                          print(
                            "================submitmachine================",
                          );
                          for (var item in answerJson) {
                            print(
                              "tempMandatory: ${item["mandatory"]}, Name: ${item["name"]}, Field Value: ${item["field_value"]},",
                            );
                          }
                          if (widget.currentStepIndex == 1 &&
                              imagelist.isEmpty) {
                            SnackbarHelper.show(
                              context,
                              'Please upload or capture a image',
                              bgcolor: Colors.orange.shade700,
                            );
                            return;
                          }

                          if (totaldata) {
                            widget.onNextStep?.call();
                          } else {
                            SnackbarHelper.show(
                              context,
                              'Please fill all the required fields.',
                              bgcolor: Colors.orange.shade700,
                            );
                          }
                        } else {
                          SnackbarHelper.show(
                            context,
                            'Please check the internet connection.',
                            bgcolor: Colors.orange.shade700,
                          );
                        }
                      } catch (e) {
                        SnackbarHelper.show(
                          context,
                          'Unexpected error occurred.',
                          bgcolor: Colors.red,
                        );
                      } finally {
                        if (mounted) setState(() => _isSubmitting = false);
                      }
                    },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: SizedBox(
              height: 24,
              child:
                  _isSubmitting
                      ? LoadingAnimationWidget.hexagonDots(
                        color: Colors.white,
                        size: 20,
                      )
                      : Text(
                        widget.currentStepIndex == 0
                            ? 'Save and Continue'
                            : widget.currentStepIndex == 1
                            ? 'Submit for Approval'
                            : 'Done',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),
        ),
      ),
    );

    return widgetList;
  }

  void addAnswerJsonToCitizenshipDetails(
    List<Map<String, dynamic>> answerJson,
  ) {
    if (indianCitizenshipDetails.isEmpty) return;

    Map<String, dynamic> details = {};

    for (var item in answerJson) {
      if (item is Map<String, dynamic>) {
        final key = item['name'];
        final value = item['field_value'];
        if (key != null && value != null) {
          details[key] = value;
        }
      }
    }
  }
}

class PhotoSelectorWidget extends StatefulWidget {
  final List<Map<String, String>> imagelist;

  const PhotoSelectorWidget({super.key, required this.imagelist});

  @override
  _PhotoSelectorWidgetState createState() => _PhotoSelectorWidgetState();
}

class _PhotoSelectorWidgetState extends State<PhotoSelectorWidget> {
  File? _selectedImage;
  String? _fileName;
  final ImagePicker _picker = ImagePicker();
  bool _isRequestingPermission = false;

  void _updateImage(File file) {
    setState(() {
      _selectedImage = file;
      _fileName = file.path.split('/').last;
      widget.imagelist.clear();
      widget.imagelist.add({"path": file.path, "name": _fileName!});
    });
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _updateImage(File(image.path));
    }
  }

  Future<void> _captureImageFromCamera() async {
    if (_isRequestingPermission) return;
    _isRequestingPermission = true;

    try {
      PermissionStatus status = await Permission.camera.status;

      if (status.isGranted) {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
        );
        if (image != null) _updateImage(File(image.path));
      } else if (status.isDenied) {
        PermissionStatus newStatus = await Permission.camera.request();
        if (newStatus.isGranted) {
          final XFile? image = await _picker.pickImage(
            source: ImageSource.camera,
          );
          if (image != null) _updateImage(File(image.path));
        } else if (newStatus.isPermanentlyDenied) {
          _showSettingsDialog(context);
        }
      } else if (status.isPermanentlyDenied) {
        _showSettingsDialog(context);
      }
    } catch (e) {
      print("Permission error: $e");
    } finally {
      _isRequestingPermission = false;
    }
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Permission Required'),
            content: Text(
              'Camera permission is required. Please enable it in app settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await openAppSettings();
                },
                child: Text('Open Settings'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double fullWidth = MediaQuery.of(context).size.width * 0.9;
    final theme = AppTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: /*Container(
        width: fullWidth,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Upload your own image or capture a photo",
              style: theme.bodyText1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _pickImageFromGallery,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    textStyle: TextStyle(fontSize: 13),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text("Choose File"),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _captureImageFromCamera,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    textStyle: TextStyle(fontSize: 13),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text("Capture Image"),
                ),
              ],
            ),
            SizedBox(height: 8),
            if (_fileName != null)
              Text(
                _fileName!,
                style: theme.bodyText2,
                overflow: TextOverflow.ellipsis,
              ),
            SizedBox(height: 12),
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 150,
                width: fullWidth,
                fit: BoxFit.contain,
              ),
          ],
        ),
      ),*/ Container(
        width: fullWidth,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child:
            _selectedImage == null
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Upload your own image or capture a photo",
                      style: theme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _pickImageFromGallery,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            textStyle: TextStyle(fontSize: 13),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text("Choose File"),
                        ),
                        SizedBox(width: 5),
                        Text("OR", style: theme.bodyText1),
                        SizedBox(width: 5),

                        ElevatedButton(
                          onPressed: _captureImageFromCamera,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            textStyle: TextStyle(fontSize: 13),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text("Capture Image"),
                        ),
                      ],
                    ),
                  ],
                )
                : Column(
                  children: [
                    Text(
                      "Upload your own image or capture a photo",
                      style: theme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_fileName != null)
                                Center(
                                  child: Text(
                                    _fileName!,
                                    style: theme.bodyText2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              SizedBox(height: 8),
                              Image.file(
                                _selectedImage!,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.fitHeight,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: _pickImageFromGallery,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  textStyle: TextStyle(fontSize: 13),
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text("Choose File"),
                              ),
                              SizedBox(height: 6),
                              Text("OR", style: theme.bodyText1),
                              SizedBox(height: 6),

                              ElevatedButton(
                                onPressed: _captureImageFromCamera,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  textStyle: TextStyle(fontSize: 13),
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text("Capture Image"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }
}
