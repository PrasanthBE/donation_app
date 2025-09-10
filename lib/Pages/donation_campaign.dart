import 'dart:convert';
import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:akshaya_pathara/Global/drawer.dart';
import 'package:akshaya_pathara/Global/exit_helper.dart' show ExitHelper;
import 'package:akshaya_pathara/Global/stepper.dart';
import 'package:akshaya_pathara/Pages/donation_campaign/campaign_details.dart';
import 'package:flutter/material.dart';

class Donation_Campaign extends StatefulWidget {
  const Donation_Campaign({super.key});

  @override
  State<Donation_Campaign> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<Donation_Campaign> {
  int currentStepIndex = 0;
  Map<String, dynamic>? alertdata;
  String? paymentUrl;

  void goToNextStep() {
    if (currentStepIndex < 2) {
      setState(() {
        //  alertdata = passedData;
        //  paymentUrl = url;
        currentStepIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    Future<bool> _onWillPop() async {
      return await ExitHelper.showExitConfirmationDialog(context);
    }

    return WillPopScope(
      onWillPop: _onWillPop,

      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.1),
            child: Text('Donation Campaign', style: theme.title3),
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
        drawer: AppDrawer(currentPage: 'donation_campaign'),

        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// Stepper
                Center(
                  child: ArrowStepper(
                    currentIndex: currentStepIndex,
                    steps: [
                      StepData(
                        title: 'STEP 1',
                        subtitle: 'Basic Details',
                        isActive: currentStepIndex == 0,
                        color: Colors.lightBlue.shade100,
                      ),
                      StepData(
                        title: 'STEP 2',
                        subtitle: 'Campaign Details',
                        isActive: currentStepIndex == 1,
                        color: Colors.lightBlue.shade100,
                      ),
                      StepData(
                        title: 'STEP 3',
                        subtitle: 'Submit for approval',
                        isActive: currentStepIndex == 2,
                        color: Colors.lightBlue.shade100,
                      ),
                    ],
                  ),
                ),
                Builder(
                  builder:
                      (context) => Campaign_details(
                        currentStepIndex: currentStepIndex,
                        onNextStep: () => goToNextStep(),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
