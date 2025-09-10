import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:akshaya_pathara/Global/bloc.dart';
import 'package:akshaya_pathara/Global/toast.dart';
import 'package:akshaya_pathara/Pages/dashboard.dart';
import 'package:akshaya_pathara/Pages/online_donation_form.dart';
import 'package:akshaya_pathara/Pages/signup.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Global/apptheme.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpRequestScreen extends StatefulWidget {
  @override
  _OtpRequestScreenState createState() => _OtpRequestScreenState();
}

class _OtpRequestScreenState extends State<OtpRequestScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool phoneapicall = false;
  String? maskedPhoneNumber;
  bool checkBoxValue = false;
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Image section
                  SizedBox(
                    height: 350,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/loginimage/mobile_number.png',
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) => Icon(
                            Icons.image_not_supported,
                            size: 80,
                            color: Colors.grey,
                          ),
                    ),
                  ),

                  //const SizedBox(height: 10),

                  // Title
                  Text(
                    'OTP Verification',
                    style: theme.typography.title1.override(),
                  ),

                  const SizedBox(height: 20),

                  // Description
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: theme.typography.bodyText2.override(
                        color: Colors.grey,
                      ),
                      children: [
                        const TextSpan(text: 'We will send you a '),
                        TextSpan(
                          text: ' One Time Password ',
                          style: theme.typography.bodyText2.override(
                            color: Colors.black,
                          ),
                        ),
                        const TextSpan(text: ' on\nthis mobile number'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Phone Number Input
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      labelStyle: theme.typography.bodyText2.override(
                        color: Color(0xFF6061F7),
                        fontSize: 15,
                      ),
                      hintText: 'Enter your mobile number',
                      hintStyle: theme.typography.bodyText3.override(
                        color: Colors.grey,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blue.shade300,
                          width: 1.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFF6061F7),
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF6061F7)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF6061F7)),
                      ),
                      errorStyle: theme.typography.bodyText3.override(
                        color: Colors.red,
                        fontSize: 10,
                      ),
                    ),
                    style: theme.typography.bodyText1.override(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter mobile number';
                      }
                      if (value.length != 10) {
                        return 'Mobile number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          checkBoxValue = !checkBoxValue;
                        });
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Transform.scale(
                              scale: 0.80,
                              child: Checkbox(
                                value: checkBoxValue,
                                activeColor: Colors.green,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    checkBoxValue = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "The entered mobile number is registered with WhatsApp.",
                                style: theme.typography.bodyText3.override(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  // Get OTP Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: phoneapicall ? null : _navigateToOtpScreen,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6061F7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Center(
                        child:
                            phoneapicall
                                ? LoadingAnimationWidget.hexagonDots(
                                  color: Colors.white,
                                  size: 25,
                                )
                                : Text(
                                  'GET OTP',
                                  style: theme.typography.title3.override(
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToOtpScreen() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // // await prefs.setString('username', userName);
    // await prefs.setString('mobile_number', "9952271804");
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => DashboardScreen()),
    // );
    if (_formKey.currentState!.validate()) {
      setState(() {
        phoneapicall = true;
      });
      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        SnackbarHelper.show(
          context,
          "Check the internet connection",
          bgcolor: Color(0xFF6061F7),
        );
        setState(() {
          phoneapicall = false;
        });
        return;
      }

      try {
        Bloc bloc = Bloc();
        //Map res = await bloc.loginRequest(_phoneController.text);
        if (!mounted) return;
        // if (res["body"] != null && res["body"]["status"] == "Successful") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => OtpVerificationScreen(
                  phoneNumber: _phoneController.text,
                  maskedPhoneNumber: maskPhoneNumber(
                    _phoneController.text.trim(),
                  ),
                ),
          ),
        );
        setState(() {
          phoneapicall = false;
        });
        // } else {
        //   SnackbarHelper.show(
        //     context,
        //     "Login failed. Please try again.",
        //     bgcolor: Color(0xFF6061F7),
        //   );
        //   setState(() {
        //     phoneapicall = false;
        //   });
        // }
      } catch (e) {
        if (mounted)
          SnackbarHelper.show(
            context,
            " Please try again Later.Server Busy",
            bgcolor: Color(0xFF6061F7),
          );
        setState(() {
          phoneapicall = false;
        });
      }
    }
  }

  String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length > 2) {
      String lastTwoDigits = phoneNumber.substring(phoneNumber.length - 2);
      return '+91' + '*' * (phoneNumber.length - 2) + lastTwoDigits;
    }
    return phoneNumber;
  }
}

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String maskedPhoneNumber;

  const OtpVerificationScreen({
    required this.phoneNumber,
    required this.maskedPhoneNumber,
    Key? key,
  }) : super(key: key);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  bool otpapicall = false;
  bool _isResending = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 350,
                        width: double.infinity,
                        child: Image.asset(
                          'assets/loginimage/mobile_otp.png',
                          fit: BoxFit.contain,
                          errorBuilder:
                              (context, error, stackTrace) => Icon(
                                Icons.image_not_supported,
                                size: 80,
                                color: Colors.grey,
                              ),
                        ),
                      ),

                      // Title
                      Text(
                        'OTP Verification',
                        style: theme.typography.title1.override(),
                      ),

                      SizedBox(height: 15),

                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: theme.typography.bodyText2.override(
                            color: Colors.grey,
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  ' To confirm your mobile number,  enter the \n OTP sent to ',
                            ),
                            TextSpan(
                              text: '${widget.maskedPhoneNumber} ',
                              style: theme.typography.bodyText2.override(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      // OTP Input Fields
                      SizedBox(
                        height: screenHeight * 0.12,
                        width: screenWidth * 0.7,
                        child: PinCodeTextField(
                          autoDisposeControllers: false,
                          controller: _otpController,
                          appContext: context,
                          keyboardType: TextInputType.number,
                          length: 4,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(8),
                            fieldHeight: 50,
                            fieldWidth: 50,
                            activeColor: Color(0xFF6061F7),
                            inactiveColor: Colors.grey,
                            selectedColor: Colors.blue,
                            activeBorderWidth: 1.5,
                            inactiveBorderWidth: 1.0,
                            selectedBorderWidth: 1.0,
                            fieldOuterPadding: EdgeInsets.symmetric(
                              horizontal: 6,
                            ),
                          ),
                          textStyle: theme.bodyText1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                              otpapicall
                                  ? null
                                  : () async {
                                    _verifyOtp(context, _otpController.text);
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6366F1),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child:
                              otpapicall
                                  ? LoadingAnimationWidget.hexagonDots(
                                    color: Colors.white,
                                    size: 25,
                                  )
                                  : Text(
                                    'VERIFY & PROCEED',
                                    style: theme.typography.title3.override(
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // Resend OTP link - Fixed at bottom
              Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive the OTP? ",
                      style: theme.typography.bodyText2.override(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      // onTap: () {
                      //   // Handle resend OTP
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content: Text('OTP Resent'),
                      //       backgroundColor: Color(0xFF6366F1),
                      //     ),
                      //   );
                      // },
                      onTap:
                          _isResending
                              ? null
                              : () async {
                                setState(() {
                                  _otpController.clear();
                                  _isResending = true;
                                });

                                var connectivityResult =
                                    await Connectivity().checkConnectivity();
                                if (connectivityResult ==
                                    ConnectivityResult.none) {
                                  if (!mounted) return;
                                  SnackbarHelper.show(
                                    context,
                                    "No internet connection. Please check your network.",
                                  );
                                  setState(() {
                                    _isResending = false;
                                  });
                                  return;
                                }
                                Bloc bloc = Bloc();
                                Map res = await bloc.loginRequest(
                                  widget.phoneNumber,
                                );
                                if (res["body"] != null &&
                                    res["body"]["status"] == "Successful") {
                                  if (!mounted) return;
                                  await Future.delayed(Duration(seconds: 5));
                                  SnackbarHelper.show(context, "OTP Resent");
                                  if (mounted) {
                                    setState(() {
                                      _isResending = false;
                                    });
                                  }
                                }
                              },
                      child: Text(
                        'Resend',
                        style: theme.typography.bodyText2.override(
                          color: Color(0xFF6366F1),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyOtp(BuildContext context, String otp) async {
    if (_otpController.text.trim().length != 4) {
      if (!mounted) return;
      SnackbarHelper.show(context, "Please enter a valid 4-digit OTP.");
      return;
    }
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (!mounted) return;
      SnackbarHelper.show(
        context,
        "No internet connection. Please check your network.",
      );
      return;
    }
    setState(() {
      otpapicall = true;
    });
    try {
      Bloc bloc = Bloc();
      /* Map verifyres = await bloc.verifyOTPRequest(
        widget.phoneNumber,
        int.parse(_otpController.text),
        "",
        //fcmtoken.toString(),
      );*/
      // if (verifyres["body"] != null &&
      //     verifyres["body"]["status"] == "Successful") {
      /*SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedName = prefs.getString('name');
      String? savedPhoneNumber = prefs.getString('mobile_number');
      bool hasName = savedName != null && savedName.trim().isNotEmpty;
      bool isSamePhoneNumber =
          savedPhoneNumber != null &&
          savedPhoneNumber.trim() == widget.phoneNumber.trim();
      if (hasName && isSamePhoneNumber) {
     */
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('mobile_number', widget.phoneNumber);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DonationScreen()),
      );
      setState(() {
        otpapicall = false;
      });
      SnackbarHelper.show(context, "Success");
      /*} else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Signupscreen(mobile_number: widget.phoneNumber),
          ),
        ).then((_) {
          _otpController.clear();
        });

        setState(() {
          otpapicall = false;
        });
      }*/
      // } else {
      //   SnackbarHelper.show(context, "Invalid OTP");
      //   setState(() {
      //     otpapicall = false;
      //   });
      // }
    } catch (e) {
      SnackbarHelper.show(context, " Please try again Later.Server Busy");
      setState(() {
        otpapicall = false;
      });
    }
  }
}
