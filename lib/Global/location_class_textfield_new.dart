import 'dart:convert';
import 'dart:io';
//import 'package:OrigaSuperAPP/pages/Bloc.dart';
//import 'package:OrigaSuperAPP/pages/service/FullFetchForm.dart';
import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:akshaya_pathara/Global/bloc.dart';
import 'package:akshaya_pathara/Pages/my_account.dart' show DecorationUtils;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DynamicLocationForm extends StatefulWidget {
  final List<Map<String, dynamic>> locationFields;
  final List<Map<String, dynamic>> answerJson;
  final Function(List<Map<String, dynamic>>) onAnswersChanged;

  const DynamicLocationForm({
    Key? key,
    required this.locationFields,
    required this.answerJson,
    required this.onAnswersChanged,
  }) : super(key: key);

  @override
  DynamicLocationFormState createState() => DynamicLocationFormState();
}

class DynamicLocationFormState extends State<DynamicLocationForm> {
  // Maps to store controllers and states for each location field
  Map<String, Map<String, TextEditingController>> fieldControllers = {};
  Map<String, int> fieldLocationModes =
      {}; // 0: Enter Address, 1: Fetch Location
  Map<String, bool> fieldFetchingStates = {};

  // Static data
  List<String> states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Delhi',
    'Jammu and Kashmir',
    'Ladakh',
    'Puducherry',
    'Chandigarh',
    'Andaman and Nicobar Islands',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Lakshadweep',
  ];

  Map<String, List<String>> stateDistricts = {};
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    for (var field in widget.locationFields) {
      String fieldName = field['name'];

      // Initialize controllers for each field
      fieldControllers[fieldName] = {
        'address': TextEditingController(),
        'city': TextEditingController(),
        'pincode': TextEditingController(),
        'district': TextEditingController(),
        'state': TextEditingController(),
        'latitude': TextEditingController(),
        'longitude': TextEditingController(),
      };

      // Initialize states
      fieldLocationModes[fieldName] = 0; // Default to "Enter Address"
      fieldFetchingStates[fieldName] = false;
      stateDistricts[fieldName] = [];

      // Pre-populate from existing answers
      _populateExistingData(fieldName);
    }
  }

  void _populateExistingData(String fieldName) {
    var existingAnswer = widget.answerJson.firstWhere(
      (item) => item['name'] == fieldName,
      orElse: () => {},
    );

    if (existingAnswer.isNotEmpty) {
      fieldControllers[fieldName]!['address']!.text =
          existingAnswer['address']?.toString() ?? '';
      fieldControllers[fieldName]!['city']!.text =
          existingAnswer['city']?.toString() ?? '';
      fieldControllers[fieldName]!['pincode']!.text =
          existingAnswer['pincode']?.toString() ?? '';
      fieldControllers[fieldName]!['district']!.text =
          existingAnswer['district']?.toString() ?? '';
      fieldControllers[fieldName]!['state']!.text =
          existingAnswer['state']?.toString() ?? '';
      fieldControllers[fieldName]!['latitude']!.text =
          existingAnswer['latitude']?.toString() ?? '';
      fieldControllers[fieldName]!['longitude']!.text =
          existingAnswer['longitude']?.toString() ?? '';
    }
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isOnline = connectivityResult != ConnectivityResult.none;
    });
  }

  void removeAnswer(String fieldName) {
    final removedItems =
        widget.answerJson
            .where((item) => item['name'] == fieldName)
            .toList(); // Store matching items before removal

    widget.answerJson.removeWhere((item) => item['name'] == fieldName);

    print("Removed items:");
    print(removedItems);

    print("Updated widget.answerJson:");
    print(widget.answerJson);

    print("Removed field name:");
    print(fieldName);

    if (fieldControllers.containsKey(fieldName)) {
      var controllers = fieldControllers[fieldName]!;
      controllers.forEach((key, controller) {
        controller.clear();
      });
    }
    fieldLocationModes[fieldName] = 0;
    fieldFetchingStates[fieldName] = false;
    stateDistricts[fieldName] = [];

    // Notify parent about the change
    widget.onAnswersChanged(widget.answerJson);

    // Update UI
    setState(() {});

    print("Removed answer for field: $fieldName");
  }

  void addAddressField() {
    // Check if already exists
    bool alreadyExists = widget.answerJson.any(
      (item) => item['name'] == 'address',
    );
    if (!alreadyExists) {
      // Add a blank address field
      widget.answerJson.add({
        "field_type": "location",
        "field_value": "",
        "address": "",
        "city": "",
        "pincode": "",
        "district": "",
        "state": "",
        "latitude": "",
        "longitude": "",
        "id": 6,
        "label": "Address",
        "mandatory": true,
        "name": "address",
        "category": "certificate",
      });
    }
  }

  void _updateAnswerJson(String fieldName, String key, String value) {
    // Remove existing entry
    widget.answerJson.removeWhere((item) => item['name'] == fieldName);

    // Get field template
    /*  var fieldTemplate = widget.locationFields.firstWhere(
      (field) => field['name'] == fieldName,
      orElse: () => {},
    );*/
    var fieldTemplate = widget.locationFields.firstWhere(
      (field) => field['name'] == fieldName,
      orElse: () => <String, dynamic>{}, // explicitly typed
    );

    if (fieldTemplate.isNotEmpty) {
      // Create new answer entry
      Map<String, dynamic> newAnswer = Map<String, dynamic>.from(fieldTemplate);

      // Update with current controller values
      var controllers = fieldControllers[fieldName]!;
      newAnswer['address'] = controllers['address']!.text.trim();
      newAnswer['city'] = controllers['city']!.text.trim();
      newAnswer['pincode'] = controllers['pincode']!.text.trim();
      newAnswer['district'] = controllers['district']!.text.trim();
      newAnswer['state'] = controllers['state']!.text.trim();
      newAnswer['latitude'] = controllers['latitude']!.text.trim();
      newAnswer['longitude'] = controllers['longitude']!.text.trim();

      // Set field_value based on mode
      if (fieldLocationModes[fieldName] == 1) {
        // Fetch Location mode - use coordinates
        if (newAnswer['latitude'].isNotEmpty &&
            newAnswer['longitude'].isNotEmpty) {
          newAnswer['field_value'] =
              "${newAnswer['latitude']},${newAnswer['longitude']}";
        }
      } else {
        // Enter Address mode - use address string
        List<String> addressParts = [];
        if (newAnswer['address'].isNotEmpty) {
          addressParts.add(newAnswer['address']);
        }
        if (newAnswer['city'].isNotEmpty) {
          addressParts.add(newAnswer['city']);
        }
        if (newAnswer['district'].isNotEmpty) {
          addressParts.add(newAnswer['district']);
        }
        if (newAnswer['state'].isNotEmpty) {
          addressParts.add(newAnswer['state']);
        }
        if (newAnswer['pincode'].isNotEmpty) {
          addressParts.add(newAnswer['pincode']);
        }

        if (addressParts.isNotEmpty) {
          newAnswer['field_value'] = addressParts.join(', ');
        }
      }

      widget.answerJson.add(newAnswer);
      widget.onAnswersChanged(widget.answerJson);
    }
  }

  Future<void> _fetchLocation(String fieldName) async {
    setState(() {
      fieldFetchingStates[fieldName] = true;
    });

    try {
      // Check location services
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showToast("Enable location services");
        setState(() {
          fieldLocationModes[fieldName] = 0;
        });
        return;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showToast("Location permissions are denied");
          setState(() {
            fieldLocationModes[fieldName] = 0;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showToast("Location permissions are permanently denied");
        setState(() {
          fieldLocationModes[fieldName] = 0;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update controllers
      var controllers = fieldControllers[fieldName]!;
      controllers['latitude']!.text = position.latitude.toString();
      controllers['longitude']!.text = position.longitude.toString();

      // Reverse geocoding
      await _reverseGeocode(fieldName, position.latitude, position.longitude);
    } catch (e) {
      _showToast("Failed to fetch location, try again");
      print("error");
      print(e.toString());
      setState(() {
        fieldLocationModes[fieldName] = 0;
      });
    } finally {
      setState(() {
        fieldFetchingStates[fieldName] = false;
      });
    }
  }

  Future<void> _reverseGeocode(String fieldName, double lat, double lng) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyA2ZK11cqCfWcp47t3JdPqJBKjSLX6PBLg',
        ),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List results = jsonData['results'];

        if (results.isNotEmpty) {
          Map firstResult = results[0];
          List components = firstResult['address_components'];

          String streetNumber = '';
          String route = '';
          String subLocality = '';
          String locality = '';
          String district = '';
          String state = '';
          String postalCode = '';

          // Parse address components
          for (var comp in components) {
            List types = comp['types'];
            String value = comp['long_name'];

            if (types.contains('street_number')) streetNumber = value;
            if (types.contains('route')) route = value;
            if (types.contains('sublocality') ||
                types.contains('sublocality_level_1'))
              subLocality = value;
            if (types.contains('locality')) locality = value;
            if (types.contains('administrative_area_level_2')) district = value;
            if (types.contains('administrative_area_level_1')) state = value;
            if (types.contains('postal_code')) postalCode = value;
          }

          // Update controllers
          var controllers = fieldControllers[fieldName]!;

          String addressLine1 = streetNumber.trim();
          if (route.isNotEmpty && !addressLine1.contains(route)) {
            addressLine1 = '$addressLine1 $route'.trim();
          }

          String addressLine2 = '';
          if (subLocality.isNotEmpty && !addressLine1.contains(subLocality)) {
            addressLine2 = subLocality;
          }

          controllers['address']!.text =
              '$addressLine1${addressLine2.isNotEmpty ? ', $addressLine2' : ''}';
          controllers['city']!.text = locality;
          controllers['pincode']!.text = postalCode;

          controllers['state']!.text = state;
          await _getDistricts("", state);
          controllers['district']!.text =
              district.isEmpty ? locality : district;

          // Update answer JSON
          _updateAnswerJson(fieldName, 'address', controllers['address']!.text);

          _showToast("Location fetched successfully");
        } else {
          _showToast("No address found for location");
          setState(() {
            fieldLocationModes[fieldName] = 0;
            fieldFetchingStates[fieldName] = false;
          });
        }
      } else {
        _showToast("Failed to fetch address");
        setState(() {
          fieldLocationModes[fieldName] = 0;
          fieldFetchingStates[fieldName] = false;
        });
      }
    } catch (e) {
      _showToast("Failed to fetch address");
      setState(() {
        fieldLocationModes[fieldName] = 0;
        fieldFetchingStates[fieldName] = false;
      });
    }
  }

  Future<void> _getDistricts(String fieldName, String stateName) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print("No internet connection");
      return;
    }

    try {
      Bloc bloc = Bloc();
      Map res = await bloc.fetchUnifiedLeadsDistricts(stateName);
      // print("API Response:");
      // print(res);

      List jdata = res['district_list'];
      stateDistricts[fieldName] = [];
      jdata.forEach((element) {
        if (element["district_name"] != null &&
            element["district_name"].toString().trim().isNotEmpty) {
          setState(() {
            stateDistricts[fieldName]!.add(element["district_name"].toString());
          });
        }
      });

      // print("Updated stateDistricts[$fieldName]: ${stateDistricts[fieldName]}");
      setState(() {});
    } catch (e) {
      print("Error fetching districts: $e");
    }
  }

  void _showToast(
    String message, {
    Color backgroundColor = Colors.blue,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildLocationModeSelector(String fieldName, String label) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 8.0,
        runSpacing: 4.0,
        children:
            [
              {'label': 'Enter Address'.tr, 'index': 0},
              {'label': 'Fetch Location'.tr, 'index': 1},
            ].map((Map<String, dynamic> option) {
              bool isSelected =
                  fieldLocationModes[fieldName] == (option['index'] as int);

              return InkWell(
                onTap: () async {
                  setState(() {
                    fieldLocationModes[fieldName] = option['index'] as int;

                    if (option['index'] == 1) {
                      _fetchLocation(fieldName);
                    } /* else {
                      fieldFetchingStates[fieldName] = false;
                      // Clear latitude and longitude when switching to manual entry
                      var controllers = fieldControllers[fieldName]!;
                      controllers['latitude']!.clear();
                      controllers['longitude']!.clear();

                      // Update answer JSON to reflect the current state
                      _updateAnswerJson(fieldName, 'mode_change', '');
                    }*/ else {
                      fieldFetchingStates[fieldName] = false;
                      // Clear controllers when switching to manual entry
                      var controllers = fieldControllers[fieldName]!;
                      controllers.forEach((key, controller) {
                        if (key != 'latitude' && key != 'longitude') {
                          controller.clear();
                        }
                      });
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey, width: 1.5),
                    gradient:
                        isSelected
                            ? LinearGradient(
                              colors: [Colors.black, Colors.black45],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                            : null,
                    color: isSelected ? null : Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        Icon(Icons.location_on, color: Colors.white, size: 18),
                      if (isSelected) SizedBox(width: 6),
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
    );
  }

  Widget _buildLocationForm(Map<String, dynamic> field) {
    String fieldName = field['name'];
    String label = field['label'] ?? 'Location';
    bool isMandatory = field['mandatory'] ?? false;
    bool isFetching = fieldFetchingStates[fieldName] ?? false;
    var controllers = fieldControllers[fieldName]!;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Field Label
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(width: 20),
              Expanded(child: _buildLocationModeSelector(fieldName, label)),
            ],
          ),

          SizedBox(height: 20),

          // Loading or Form
          if (isFetching)
            //Center(child: CircularProgressIndicator())
            Container(
              height: MediaQuery.of(context).size.height * 0.1,

              child: LoadingAnimationWidget.hexagonDots(
                color: Colors.black,
                size: 20,
              ),
            )
          else
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Address Line
                  _buildTextField(
                    controller: controllers['address']!,
                    label: 'Address Line',
                    isMandatory: isMandatory,
                    onChanged:
                        (value) =>
                            _updateAnswerJson(fieldName, 'address', value),
                  ),

                  SizedBox(height: 12),

                  // City
                  _buildTextField(
                    controller: controllers['city']!,
                    label: 'City / Area'.tr,
                    isMandatory: isMandatory,
                    onChanged:
                        (value) => _updateAnswerJson(fieldName, 'city', value),
                  ),

                  SizedBox(height: 12),

                  // Pincode
                  _buildTextField(
                    controller: controllers['pincode']!,
                    label: 'Pincode'.tr,
                    isMandatory: isMandatory,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    onChanged:
                        (value) =>
                            _updateAnswerJson(fieldName, 'pincode', value),
                  ),

                  SizedBox(height: 12),

                  // State and District Row
                  Row(
                    children: [
                      // State
                      Expanded(
                        child: _buildStateDropdown(fieldName, isMandatory),
                      ),

                      SizedBox(width: 12),

                      // District
                      Expanded(
                        child:
                            fieldLocationModes[fieldName] ==
                                    1 // 1 = Fetch Location
                                ? _buildTextField(
                                  controller: controllers['district']!,
                                  label: 'District'.tr,
                                  isMandatory: isMandatory,
                                  onChanged:
                                      (value) => _updateAnswerJson(
                                        fieldName,
                                        'district',
                                        value,
                                      ),
                                )
                                : _buildDistrictDropdown(
                                  fieldName,
                                  isMandatory,
                                ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isMandatory,
    required Function(String) onChanged,
    int? maxLength,
    TextInputType? keyboardType,
  }) {
    final theme = AppTheme.of(context);

    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        maxLength: maxLength,
        keyboardType: keyboardType ?? TextInputType.text,
        validator:
            isMandatory
                ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mandatory Field';
                  }
                  return null;
                }
                : null,
        decoration: DecorationUtils.commonInputDecoration(
          context: context,
          iconData: null,
          labelText: label,
          mandatory: isMandatory,
        ),
        style: theme.typography.bodyText2.override(
          color: theme.secondaryText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStateDropdown(String fieldName, bool isMandatory) {
    var controllers = fieldControllers[fieldName]!;
    final theme = AppTheme.of(context);

    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value:
            states.contains(controllers['state']!.text)
                ? controllers['state']!.text
                : null,
        onChanged: (String? newValue) async {
          if (newValue != null) {
            setState(() {
              controllers['state']!.text = newValue;
              _checkConnectivity();
            });
            _updateAnswerJson(fieldName, 'state', newValue);
            await _getDistricts(fieldName, newValue);
          }
        },
        items:
            states.map<DropdownMenuItem<String>>((String state) {
              return DropdownMenuItem<String>(
                value: state,
                child: Text(
                  state,
                  overflow: TextOverflow.ellipsis,
                  style: theme.typography.bodyText2.override(
                    color: theme.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
        decoration: DecorationUtils.commonInputDecoration(
          context: context,
          iconData: null,
          labelText: 'State'.tr,
          mandatory: isMandatory,
        ),
        validator:
            isMandatory
                ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mandatory Field';
                  }
                  return null;
                }
                : null,
      ),
    );
  }

  Widget _buildDistrictDropdown(String fieldName, bool isMandatory) {
    var controllers = fieldControllers[fieldName]!;
    var districts = stateDistricts[fieldName] ?? [];
    final theme = AppTheme.of(context);

    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value:
            districts.contains(controllers['district']!.text)
                ? controllers['district']!.text
                : null,
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              controllers['district']!.text = newValue;
            });
            _updateAnswerJson(fieldName, 'district', newValue);
          }
        },
        items:
            districts.map<DropdownMenuItem<String>>((String district) {
              return DropdownMenuItem<String>(
                value: district,
                child: Text(
                  district,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
        decoration: DecorationUtils.commonInputDecoration(
          context: context,
          iconData: null,
          labelText: 'District'.tr,
          mandatory: isMandatory,
        ),
        style: theme.typography.bodyText2.override(
          color: theme.secondaryText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        validator:
            isMandatory
                ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mandatory Field';
                  }
                  return null;
                }
                : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          widget.locationFields
              .where((field) => field['field_type'] == 'location')
              .map((field) => _buildLocationForm(field))
              .toList(),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var fieldControllers in fieldControllers.values) {
      for (var controller in fieldControllers.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }
}

class LocationFormPage extends StatefulWidget {
  @override
  _LocationFormPageState createState() => _LocationFormPageState();
}

class _LocationFormPageState extends State<LocationFormPage> {
  List<Map<String, dynamic>> locationFields = [
    {
      "field_options": [],
      "field_icon": "",
      "field_type": "location",
      "field_value": {},
      "address": "",
      "city": "",
      "pincode": "",
      "district": "",
      "state": "",
      "latitude": "",
      "longitude": "",
      "id": "6",
      "label": "Geolocation",
      "mandatory": true,
      "name": "geolocation",
      "category": "basic",
    },
    {
      "field_options": [],
      "field_icon": "",
      "field_type": "location",
      "field_value": {},
      "address": "",
      "city": "",
      "pincode": "",
      "district": "",
      "state": "",
      "latitude": "",
      "longitude": "",
      "id": "7",
      "label": "Company Location",
      "mandatory": true,
      "name": "companylocation",
      "category": "basic",
    },
  ];

  List<Map<String, dynamic>> answerJson = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Location Form'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DynamicLocationForm(
              locationFields: locationFields,
              answerJson: answerJson,
              onAnswersChanged: (updatedAnswers) {
                setState(() {
                  answerJson = updatedAnswers;
                });
                print('Updated Answers: ${jsonEncode(answerJson)}');
              },
            ),

            // Display current answers (for debugging)
            if (answerJson.isNotEmpty)
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Answers:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    ...answerJson.map<Widget>((element) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              element.entries.map<Widget>((entry) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    '${entry.key}: ${entry.value}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                );
                              }).toList(),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
