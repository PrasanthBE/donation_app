// import 'dart:convert';
//
// import 'package:akshaya_pathara/Global/bloc.dart';
// import 'package:akshaya_pathara/Global/payment_page.dart';
// import 'package:akshaya_pathara/Global/toast.dart';
// import 'package:flutter/material.dart';
// import 'package:akshaya_pathara/Global/apptheme.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class DonationConfirmationPage extends StatefulWidget {
//   final Map<String, dynamic> alertdata;
//   final Function(String url) onNextStep;
//
//   const DonationConfirmationPage({
//     Key? key,
//     required this.alertdata,
//     required this.onNextStep,
//   }) : super(key: key);
//
//   @override
//   State<DonationConfirmationPage> createState() =>
//       _DonationConfirmationPageState();
// }
//
// class _DonationConfirmationPageState extends State<DonationConfirmationPage> {
//   Map<String, String> confirmationDetails = {};
//   String? finalAmount;
//   String? roundedAmount;
//   String? savedProgramName;
//   String? mobileNumber;
//   @override
//   void initState() {
//     super.initState();
//     _LoadData();
//   }
//
//   void _LoadData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     setState(() {
//       savedProgramName = prefs.getString('selected_program_name');
//       mobileNumber = prefs.getString('mobile_number');
//     });
//
//     print('Program Name: $savedProgramName');
//     print('Mobile Number: $mobileNumber');
//     _prepareData();
//   }
//
//   void _prepareData() {
//     String fullAmount = widget.alertdata["total_donation_amount"].toString();
//     String numberPart = fullAmount.split('(')[0].trim();
//     roundedAmount = (double.tryParse(numberPart) ?? 0.0).toStringAsFixed(2);
//     String currencyPart =
//         fullAmount.contains('(')
//             ? fullAmount.substring(fullAmount.indexOf('(')).trim()
//             : '';
//     finalAmount = "$roundedAmount $currencyPart";
//
//     confirmationDetails = {};
//
//     void addIfValid(String key, dynamic value) {
//       if (value != null && value.toString().trim().isNotEmpty) {
//         confirmationDetails[key] = value.toString().trim();
//       }
//     }
//
//     addIfValid("Transaction ID", widget.alertdata["donation_ref_id"]);
//     addIfValid("Full Name", widget.alertdata["full_name"]);
//     addIfValid("Email Address", widget.alertdata["email_id"]);
//     addIfValid(
//       "Mobile Number",
//       /*widget.alertdata["mobile"]*/ mobileNumber.toString(),
//     );
//     addIfValid("PAN Number", widget.alertdata["pan_number"]);
//     addIfValid("Donation Amount", "Rs. $finalAmount");
//     addIfValid("Currency Name", widget.alertdata["currency_name"]);
//
//     String donationType = _formatDonationType(
//       widget.alertdata["donation_type"],
//       widget.alertdata["donation_frequency"],
//     );
//     addIfValid("Donation type", donationType);
//
//     String createdDate =
//         widget.alertdata["created_date"]?.toString().split("T").first ?? '';
//     addIfValid("Created Date", createdDate);
//     print("confirmationDetails");
//     confirmationDetails.forEach((key, value) {
//       print('$key: $value');
//     });
//   }
//
//   String _formatDonationType(String? type, String? frequency) {
//     final hasFrequency = (frequency ?? '').trim().isNotEmpty;
//     if ((type ?? '').trim().isEmpty) return '';
//     return hasFrequency ? "$type ($frequency)" : "$type";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = AppTheme.of(context);
//
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
//       child: Column(
//         children: [
//           Text(
//             savedProgramName.toString(),
//             style: theme.typography.bodyText1.override(
//               color: Colors.blue,
//               fontSize: 18,
//             ),
//           ),
//           const SizedBox(height: 12),
//
//           Text(
//             'Please confirm your details',
//             style: theme.typography.bodyText1.override(),
//           ),
//           const SizedBox(height: 12),
//
//           Material(
//             elevation: 10,
//             shadowColor: Colors.blue.shade400,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Table(
//                 columnWidths: const {
//                   0: FlexColumnWidth(2.5),
//                   1: FlexColumnWidth(3.5),
//                 },
//                 border: TableBorder.all(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                 children:
//                     confirmationDetails.entries.map((entry) {
//                       return TableRow(
//                         decoration: const BoxDecoration(color: Colors.white),
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Text(
//                               entry.key,
//                               style: theme.typography.bodyText1.override(),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Text(
//                               entry.value,
//                               style: theme.typography.bodyText1.override(
//                                 color: Colors.green,
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     }).toList(),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Align(
//             alignment: Alignment.center,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 12,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//               ),
//               onPressed: () async {
//                 print("amount: $roundedAmount");
//                 print("mobileNumber: $mobileNumber");
//                 print(
//                   "donation_ref_id: ${widget.alertdata["donation_ref_id"]}",
//                 );
//
//                 Bloc bloc = new Bloc();
//                 try {
//                   // Map responseData =
//                   //     await bloc.CheckPaymentStatusDonation(
//                   //       alertdata["donation_ref_id"],
//                   //     );
//                   Map<String, dynamic> mockResponse = {
//                     "status": "Success",
//                     "msg": "PAYMENT_NOT_INITIATED",
//                   };
//                   Map responseData = mockResponse;
//
//                   if (responseData["status"] == "Success") {
//                     if (responseData["msg"] == "PAYMENT_SUCCESS") {
//                       ToastHelper.show("Payment Completed");
//                     } else if (responseData["msg"] == "PAYMENT_PENDING") {
//                       ToastHelper.show(
//                         "Payment is still In-Process. Kindly wait for sometime.",
//                       );
//                     } else if (responseData["msg"] == "PAYMENT_INITIATED") {
//                       ToastHelper.show(
//                         "Payment is already initiated.Kindly wait for sometime.",
//                       );
//                     } else if (responseData["msg"] == "PAYMENT_NOT_INITIATED" ||
//                         responseData["msg"] == "PAYMENT_DECLINED" ||
//                         responseData["msg"] == "KEY_NOT_CONFIGURED" ||
//                         responseData["msg"] == "PAYMENT_ERROR") /*{
//                     var headers = {
//                       'Content-Type': 'application/json',
//                     };
//                     //String paymentUrl = "https://ompextension.origa.market/graphql/";
//                     String paymentUrl = "http://3.109.71.129:8001/graphql/";
//                     var request = http.Request('POST', Uri.parse(paymentUrl));
//                     request.body =
//                         '''{"query":"mutation { createPayment(inputpayment: {amount:\\"''' +
//                             invoice['payment_cost'].toString() +
//                             '''\\" createdby:\\"Service App\\" paymentmethod:\\"PAGE\\" paymentstatus:\\"PEN\\" }) {payment {merchantTransactionId } message success responseurl responsecode}}","variables":{}}''';
//                     */ /*request.body ='''{"query":"mutation { createPayment(inputpayment: {amount:\\"1.00\\" createdby:\\"Service App\\" paymentmethod:\\"PAGE\\" paymentstatus:\\"PEN\\" }) {payment {merchantTransactionId } message success responseurl responsecode}}","variables":{}}''';*/ /*
//                     request.headers.addAll(headers);
//                     http.StreamedResponse response = await request.send();
//                     print("RESPONSE");
//                     print(response.statusCode);
//                     if (response.statusCode == 200) {
//                       var data =
//                           json.decode(await response.stream.bytesToString());
//                       print(data["data"]["createPayment"]);
//                       print(data["data"]);
//                       String url = data["data"]["createPayment"]["responseurl"];
//                       print("IN APP WEBVIEW");
//
//                       print("---------------URL");
//                       print(url);
//
//                       print("AFTER URL");
//                       if (url != null) {
//                         try {
//                           */ /*   Bloc bloc = new Bloc();
//                           await bloc.savePaymentInfo(
//                               invoice['invoice_no'],
//                               data["data"]["createPayment"]["payment"]
//                                   ["merchantTransactionId"],
//                               url,
//                               data["data"]["createPayment"]["responsecode"]);*/ /*
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => PaymentPageView(url)),
//                           ).then((value) async {
//                             Navigator.pop(context);
//                             */ /*     Bloc bloc = new Bloc();
//                             try {
//                               await bloc.checkPaymentStatus(
//                                   invlist[index].invoice_no);
//                               setState(() {
//                                 invlist = [];
//                               });
//                               await getInvoiceDetails();
//                             } catch (e) {
//                               print('Error while checking payment status: $e');
//                             }*/ /*
//                           });
//                         } catch (e) {
//                           print("EXCEPTION");
//                           print(e);
//                         }
//                       } else {
//                         ToastHelper.show(
//                             "Server Error. Kindly check after sometime.");
//                       }
//                     } else {
//                       print(response.reasonPhrase);
//                     }
//                   }*/ {
//                       final String paymentUrl =
//                           "http://3.111.159.123:9001/graphql/";
//                       final headers = {'Content-Type': 'application/json'};
//
//                       final Map<String, dynamic> requestBody = {
//                         "query": """
//                         mutation CreatePayment(\$inputpayment: PaymentInput!) {
//                           createPayment(inputpayment: \$inputpayment) {
//                             payment {
//                               merchantTransactionId
//                               PaymentID
//                             }
//                             message
//                             success
//                             responseurl
//                           }
//                         }
//                       """,
//                         "variables": {
//                           "inputpayment": {
//                             "amount": roundedAmount,
//                             "createdby":
//                                 widget.alertdata['created_date'].toString(),
//                             "mobileno": mobileNumber.toString(),
//                             "paymentmethod": "PAGE",
//                             "paymentcategory": "service",
//                             //"redirecturl": "https://devextension.origa.market/toolspaymentredirect?id=REF-6962-20240716",
//                             "redirecturl":
//                                 "https://devextension.origa.market/mvdonationpaymentredirect?id=${widget.alertdata["donation_ref_id"]}",
//                             "paymentcategory": "Donation",
//                             "paymentcategoryrecordid":
//                                 widget.alertdata["donation_ref_id"] ?? '',
//                           },
//                         },
//                       };
//
//                       try {
//                         final response = await http.post(
//                           Uri.parse(paymentUrl),
//                           headers: headers,
//                           body: jsonEncode(requestBody),
//                         );
//
//                         if (response.statusCode == 200) {
//                           final data = jsonDecode(response.body);
//                           final paymentData = data["data"]["createPayment"];
//                           print("payment url response  $data ");
//                           if (paymentData["success"] == true) {
//                             String url = paymentData["responseurl"];
//                             print(
//                               data["data"]["createPayment"]["payment"]["merchantTransactionId"],
//                             );
//                             if (url.isNotEmpty) {
//                               var response = await bloc.SavePayInfoDonation(
//                                 widget.alertdata["donation_ref_id"],
//                                 data["data"]["createPayment"]["payment"]["merchantTransactionId"],
//                                 url,
//                                 data["data"]["createPayment"]["responsecode"],
//                               );
//
//                               if (response["status"] == "success") {
//                                 widget.onNextStep(url);
//                                 /* Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => PaymentPageView(url),
//                                 ),
//                               ).then((_) {
//                                 Navigator.pop(context);
//                               });*/
//                               } else {
//                                 ToastHelper.show(
//                                   "Server Error. Kindly check after sometime.",
//                                 );
//                               }
//                             } else {
//                               ToastHelper.show(
//                                 "Server Error. Kindly check after sometime.",
//                               );
//                             }
//                           } else {
//                             ToastHelper.show(
//                               "Payment creation failed: ${paymentData["message"]}",
//                             );
//                           }
//                         } else {
//                           print("Error: ${response.reasonPhrase}");
//                           ToastHelper.show(
//                             "Payment request failed. Try again later.",
//                           );
//                         }
//                       } catch (e) {
//                         print("Exception: $e");
//                         ToastHelper.show("An unexpected error occurred.");
//                       }
//                     } else {
//                       ToastHelper.show(
//                         "Server Error. Kindly check after sometime.",
//                       );
//                     }
//                   } else {
//                     ToastHelper.show("Server Busy. Try After Sometime!!!");
//                   }
//                 } catch (e) {
//                   print("Exception: $e");
//                   ToastHelper.show("Server Busy. Try After Sometime!!!");
//                 }
//               },
//
//               child: Text(
//                 "Donate Now",
//                 style: theme.typography.bodyText1.override(color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
