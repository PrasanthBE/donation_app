import 'dart:convert';

import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:akshaya_pathara/Global/drawer.dart';
import 'package:akshaya_pathara/Global/global.dart' as global;
import 'package:akshaya_pathara/Global/stepper.dart';
import 'package:akshaya_pathara/Pages/my_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/gestures.dart';

import 'online_donation_branch/alert_box_donation.dart';
import 'online_donation_branch/indian_citizen.dart';
import 'online_donation_branch/not _residing_India.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  int selectedCitizenship = 0; // Default selected is Indian Citizen
  bool isLoading = false;

  final List<String> citizenshipOptions = [
    'Indian Citizen',
    'Indian Citizen (Not residing in India – NRE, NRI, NRO)',
  ];

  int currentStepIndex = 0;
  String? paymentUrl;

  void goToNextStep({String? url}) {
    if (currentStepIndex < 2) {
      setState(() {
        paymentUrl = url;
        currentStepIndex++;
      });
    }
  }

  void setLoadingState(bool loading) {
    if (mounted) {
      setState(() {
        isLoading = loading;
        global.isloadingindian_citizen = loading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return WillPopScope(
      onWillPop: () async {
        if (currentStepIndex > 0) {
          setState(() {
            currentStepIndex = currentStepIndex - 1;
          });
          return false;
        } else {
          bool exit = await _showExitConfirmationDialog(context);
          return exit;
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,

              title: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.1),
                child: Text('Donation', style: theme.title3),
              ),
              // leading: IconButton(
              //   icon: Icon(Icons.arrow_back, color: Colors.black, size: 24),
              //   onPressed: () => Navigator.pop(context),
              // ),
              leading: Builder(
                builder:
                    (context) => IconButton(
                      icon: Icon(Icons.menu, color: Colors.black87),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
              ),
            ),
            drawer: AppDrawer(currentPage: 'online_donation'),

            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// Stepper
                    Center(
                      child: ArrowStepper(
                        currentIndex: currentStepIndex,
                        // onStepTapped: (index) {
                        //   setState(() {
                        //     currentStepIndex = index;
                        //   });
                        // },
                        steps: [
                          StepData(
                            title: 'STEP 1',
                            subtitle: 'Select Donation Amount',
                            isActive: currentStepIndex == 0,
                            color: Colors.lightBlue.shade100,
                          ),
                          // StepData(
                          //   title: 'STEP 2',
                          //   subtitle: 'Select Payment Method',
                          //   isActive: currentStepIndex == 1,
                          //   color: Colors.lightBlue.shade100,
                          // ),
                          StepData(
                            title: 'STEP 2',
                            subtitle: 'Complete Payment',
                            isActive: currentStepIndex == 2,
                            color: Colors.lightBlue.shade100,
                          ),
                        ],
                      ),
                    ),

                    /// Citizenship selection
                    if (currentStepIndex == 0)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 0, 10),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select your citizenship',
                              style: theme.typography.bodyText1.override(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 10),
                            Wrap(
                              spacing: 0,
                              runSpacing: 0,
                              children: List.generate(
                                citizenshipOptions.length,
                                (index) {
                                  return SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.2,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedCitizenship = index;
                                        });
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Radio<int>(
                                            value: index,
                                            groupValue: selectedCitizenship,
                                            onChanged: (val) {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                    setState(() {
                                                      selectedCitizenship =
                                                          val!;
                                                    });
                                                  });
                                            },
                                            activeColor: Colors.blue,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                          Expanded(
                                            child: Text(
                                              citizenshipOptions[index],
                                              style:
                                                  theme.typography.bodyText2
                                                      .override(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 10),

                            /// Conditional content
                            //  if (selectedCitizenship == 0)
                            Builder(
                              builder:
                                  (context) => indian_citizen(
                                    citizenship_type:
                                        citizenshipOptions[selectedCitizenship],
                                    onNextStep: (url) => goToNextStep(url: url),
                                    onLoadingStateChanged: setLoadingState,
                                  ),
                            ),
                            /*if (selectedCitizenship == 1)
                              Builder(
                                builder:
                                    (context) => DonationCalculator(
                                      citizenship_type: citizenshipOptions[1],
                                      onNextStep:
                                          ({passedData}) =>
                                              goToNextStep(passedData: passedData),
                                    ),
                              ),*/
                          ],
                        ),
                      ),
                    // if (currentStepIndex == 1 && alertdata != null)
                    //   DonationConfirmationPage(
                    //     alertdata: alertdata!,
                    //     onNextStep: (url) => goToNextStep(url: url),
                    //   ),
                    if (currentStepIndex == 1 && paymentUrl != null)
                      Container(
                        height: MediaQuery.of(context).size.height * 0.80,
                        child: InAppWebView(
                          initialUrlRequest: URLRequest(
                            url: WebUri(paymentUrl!),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (global.isloadingindian_citizen)
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(
                  0.5,
                ), // semi-transparent background
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/gif/loader_blue.gif',
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.width * 0.25,
                      ),
                      // SizedBox(height: 10),
                      // Text(
                      //   'Redirecting to payment to complete your donation...',
                      //   textAlign: TextAlign.center,
                      //   style: theme.typography.bodyText1.override(fontSize: 14),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Future<bool> _showExitConfirmationDialog(BuildContext context) async {
  final theme = AppTheme.of(context);

  return await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(
                'Exit App?',
                style: theme.bodyText1,
                textAlign: TextAlign.center,
              ),
              content: Text(
                'Are you sure you want to close the app?',
                style: theme.bodyText2,
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Cancel',
                    style: theme.typography.bodyText2.override(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text(
                    'Exit',
                    style: theme.typography.bodyText2.override(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    SystemNavigator.pop(); // ✅ Closes the app
                  },
                ),
              ],
            ),
      ) ??
      false; // return false if user dismisses the dialog
}
