import 'package:akshaya_pathara/Global/location_class_textfield.dart';
import 'package:akshaya_pathara/Model/test.dart';
import 'package:akshaya_pathara/Pages/dashboard.dart';
import 'package:akshaya_pathara/Pages/donation_campaign.dart';
import 'package:akshaya_pathara/Pages/edit_profile.dart';
import 'package:akshaya_pathara/Pages/login_page.dart';
import 'package:akshaya_pathara/Pages/online_donation_branch/recent_donation.dart';
import 'package:akshaya_pathara/Pages/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'Pages/donation_campaign/campaign_list.dart';
import 'Pages/india_map/indian map.dart';
import 'Pages/my_account.dart';
import 'Pages/online_donation_form.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 Handling background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
} //firebase

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState(); //testing New Commit Updated Code
}

class _MyAppState extends State<MyApp> {
  //class MyApp extends StatelessWidget {
  // const MyApp({super.key});
  @override
  void initState() {
    super.initState();

    // 🔹 Get device token
    FirebaseMessaging.instance.getToken().then((token) {
      print("✅ Device FCM Token: $token");
    });
    // 🔹 Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground message received: ${message.notification?.title}");
    });
    // 🔹 When app opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📲 Notification clicked: ${message.notification?.title}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: OtpRequestScreen(),
      routes: {
        '/online_donation': (context) => DonationScreen(),
        '/my_account': (context) => Signupscreen(),
        '/dashboard': (context) => DonationDashboard(),
        '/state_wise_overview': (context) => statewisedonationoverview(),
        '/donation_campaign': (context) => Donation_Campaign(),
        //  '/dashboard2': (context) => DonationDashboard(),
        '/recent_donation': (context) => recent_donation_history(),
        '/donation_campaign_list':
            (context) => FundraisingCampaignsPage(), //FundraisingCampaignsPage
      },
    );
  }
}
