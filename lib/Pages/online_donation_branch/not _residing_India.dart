import 'dart:convert';

import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:akshaya_pathara/Global/bloc.dart';
import 'package:akshaya_pathara/Global/terms_conditions.dart';
import 'package:akshaya_pathara/Global/toast.dart' show SnackbarHelper;
import 'package:akshaya_pathara/Pages/my_account.dart';
import 'package:akshaya_pathara/Pages/online_donation_branch/alert_box_donation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Currency {
  final String name;
  final String symbol;
  final String code;
  double? exchangeRate;
  double? inrValue;

  Currency({
    required this.name,
    required this.symbol,
    required this.code,
    this.exchangeRate,
    this.inrValue,
  });
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Currency && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}

class DonationCalculator extends StatefulWidget {
  final String citizenship_type;
  final void Function({Map<String, dynamic>? passedData})? onNextStep;

  const DonationCalculator({
    required this.citizenship_type,
    this.onNextStep,
    super.key,
  });
  @override
  _DonationCalculatorState createState() => _DonationCalculatorState();
}

class _DonationCalculatorState extends State<DonationCalculator> {
  final TextEditingController _customAmountController = TextEditingController();
  final FocusNode _customAmountFocusNode = FocusNode();

  bool checkBoxValue = false;
  bool isLoadingExchangeRate = false;
  bool _isSubmitting = false;
  List<Map<String, dynamic>> notResidingIndiaDetails = [];

  bool showAmountError = false;

  List<Currency> currencies = [
    Currency(name: 'Euro', symbol: '€', code: 'EUR'),
    Currency(name: 'US Dollar', symbol: '\$', code: 'USD'),
    Currency(name: 'Japanese Yen', symbol: '¥', code: 'JPY'),
    Currency(name: 'Bulgarian Lev', symbol: 'лв', code: 'BGN'),
    Currency(name: 'Czech Koruna', symbol: 'Kč', code: 'CZK'),
    Currency(name: 'Danish Krone', symbol: 'kr', code: 'DKK'),
    Currency(name: 'British Pound', symbol: '£', code: 'GBP'),
    Currency(name: 'Hungarian Forint', symbol: 'Ft', code: 'HUF'),
    Currency(name: 'Polish Zloty', symbol: 'zł', code: 'PLN'),
    Currency(name: 'Romanian Leu', symbol: 'lei', code: 'RON'),
    Currency(name: 'Swedish Krona', symbol: 'kr', code: 'SEK'),
    Currency(name: 'Swiss Franc', symbol: 'CHF', code: 'CHF'),
    Currency(name: 'Icelandic Króna', symbol: 'kr', code: 'ISK'),
    Currency(name: 'Norwegian Krone', symbol: 'kr', code: 'NOK'),
    Currency(name: 'Croatian Kuna', symbol: 'kn', code: 'HRK'),
    Currency(name: 'Russian Ruble', symbol: '₽', code: 'RUB'),
    Currency(name: 'Turkish Lira', symbol: '₺', code: 'TRY'),
    Currency(name: 'Australian Dollar', symbol: 'A\$', code: 'AUD'),
    Currency(name: 'Brazilian Real', symbol: 'R\$', code: 'BRL'),
    Currency(name: 'Canadian Dollar', symbol: 'C\$', code: 'CAD'),
    Currency(name: 'Chinese Yuan', symbol: '¥', code: 'CNY'),
    Currency(name: 'Hong Kong Dollar', symbol: 'HK\$', code: 'HKD'),
    Currency(name: 'Indonesian Rupiah', symbol: 'Rp', code: 'IDR'),
    Currency(name: 'Israeli New Sheqel', symbol: '₪', code: 'ILS'),
    Currency(name: 'Indian Rupee', symbol: '₹', code: 'INR'),
    Currency(name: 'South Korean Won', symbol: '₩', code: 'KRW'),
    Currency(name: 'Mexican Peso', symbol: '\$', code: 'MXN'),
    Currency(name: 'Malaysian Ringgit', symbol: 'RM', code: 'MYR'),
    Currency(name: 'New Zealand Dollar', symbol: 'NZ\$', code: 'NZD'),
    Currency(name: 'Philippine Peso', symbol: '₱', code: 'PHP'),
    Currency(name: 'Singapore Dollar', symbol: 'S\$', code: 'SGD'),
    Currency(name: 'Thai Baht', symbol: '฿', code: 'THB'),
    Currency(name: 'South African Rand', symbol: 'R', code: 'ZAR'),
  ];

  late Currency selectedCurrency;
  double? selectedAmount;
  bool isCustomAmount = false;
  final _formKey = GlobalKey<FormState>();

  late String jsonData;
  List answerJson = [];
  int? selectedDonationType = 0;
  int? selectedMonth;
  List<String> donationOptions = ['Donate Once', 'Donate Monthly'];
  List<int> monthOptions = List.generate(12, (index) => index + 1); // 1 to 12
  @override
  void initState() {
    super.initState();
    selectedCurrency = currencies.firstWhere(
      (currency) => currency.code == 'INR',
    );
    selectedAmount = getPresetAmounts().first;
    quotation();
    _storeDonationData();
  }

  void _storeDonationData() {
    final donationData = {
      "donation_amount": _getTotalDonationAmount(),
      "currency_value": _getNotResidingCurrency(),
      "currency_name": "${selectedCurrency.name}-${selectedCurrency.code}",
      "citizenship_type": widget.citizenship_type,
      "source": "mobile app",
      "indian_citizenship_details": [],
      "not_residing_india_details": [],
    };

    notResidingIndiaDetails.clear();
    notResidingIndiaDetails.add(donationData);

    print("donationData: $notResidingIndiaDetails");
  }

  double _getTotalDonationAmount() {
    if (selectedCurrency.code == 'INR') {
      return selectedAmount ?? 0.0;
    } else {
      return selectedCurrency.inrValue ?? 0.0;
    }
  }

  String _getNotResidingCurrency() {
    /* if (selectedCurrency.code == 'INR') {
      return "";
    } else {*/
    return "${selectedCurrency.symbol}${selectedAmount?.toStringAsFixed(2) ?? '0.00'}";
    // return selectedAmount?.toStringAsFixed(2) ?? '0.00';

    // }
  }

  Future<void> getExchangeRate(String targetCurrency, double amount) async {
    if (targetCurrency == 'INR') {
      // If INR is selected, no need to call API
      setState(() {
        selectedCurrency.exchangeRate = 1.0;
        selectedCurrency.inrValue = amount;
        _storeDonationData();
      });
      return;
    }

    setState(() {
      isLoadingExchangeRate = true;
    });

    try {
      List<ConnectivityResult> connectivityResult =
          await Connectivity().checkConnectivity();

      if (connectivityResult != ConnectivityResult.none) {
        Bloc bloc = Bloc();
        Map data = await bloc.convertCurrency(
          'INR',
          targetCurrency,
          amount.toString(),
        );
        print("tefyevcjhbfk");
        print(data);
        if (data['status'] == 'success') {
          setState(() {
            // Store the exchange rate (INR per target currency)
            selectedCurrency.exchangeRate =
                data['inr_per_usd']?.toDouble() ??
                data['inr_per_${targetCurrency.toLowerCase()}']?.toDouble() ??
                1.0;
            selectedCurrency.inrValue = data['inr_value']?.toDouble() ?? amount;
            _storeDonationData();
            isLoadingExchangeRate = false;
          });
        } else {
          setState(() {
            isLoadingExchangeRate = false;
          });
        }
      } else {
        SnackbarHelper.show(
          context,
          'Please check the internet connection',
          bgcolor: Colors.orange.shade700,
        );
      }
    } catch (e) {
      print('Error fetching exchange rate: $e');
      setState(() {
        isLoadingExchangeRate = false;
      });
    }
  }

  void quotation() {
    jsonData = '''  {
  "fields": [
  {
      "field_options": [],
      "field_icon": "",
      "field_type": "name",
      "field_value": "",
      "id": "1",
      "label": "First Name",
      "mandatory": true,
      "name": "first_name",
      "category": "basic"
    },
     {
      "field_options": [],
      "field_icon": "",
      "field_type": "name",
      "field_value": "",
      "id": "2",
      "label": "Last Name",
      "mandatory": true,
      "name": "last_name",
      "category": "basic"
    },
     {
      "field_options": [],
      "field_icon": "",
      "field_type": "email",
      "field_value": "",
      "id": "3",
      "label": "Email Address",
      "mandatory": true,
      "name": "email",
      "category": "basic"
    },
    {
      "field_options": {},
      "field_icon": "",
      "field_type": "phone",
      "field_value": "",
      "id": "4",
      "label": "Mobile No",
      "mandatory": true,
      "name": "mobile_no",
      "category": "basic"
    },
   {
      "field_options": {},
      "field_icon": "",
      "field_type": "pincode",
      "field_value": "",
      "id": "4",
      "label": "Post code",
      "mandatory": true,
      "name": "pincode",
      "category": "basic"
    },
    {
      "field_options": [],
      "field_icon": "",
      "field_type": "text",
      "field_value": "",
      "id": "5",
      "label": "Address line 1",
      "mandatory": true,
      "name": "address_line1",
      "category": "basic"
    },
    {
      "field_options": [],
      "field_icon": "",
      "field_type": "text",
      "field_value": "",
      "id": "6",
      "label": "Address line 2",
      "mandatory": false,
      "name": "address_line2",
      "category": "basic"
    },
    {
      "field_options": [],
      "field_icon": "",
      "field_type": "text",
      "field_value": "",
      "id": "7",
      "label": "City",
      "mandatory": true,
      "name": "city",
      "category": "basic"
    }, 
    {
      "field_options": [],
      "field_icon": "",
      "field_type": "text",
      "field_value": "",
      "id": "8",
      "label": "State",
      "mandatory": true,
      "name": "state",
      "category": "basic"
    },  {
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
      "mandatory": false,
      "name": "country",
      "category": "basic"
    }
  ]
}
 
      ''';
  }

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
  List<double> getPresetAmounts() {
    switch (selectedCurrency.code) {
      case 'GBP':
      case 'GIP':
        return [25, 50, 75, 100, 250];
      case 'USD':
        return [33, 67, 100, 134, 336];
      case 'EUR':
        return [30, 60, 90, 120, 300];
      case 'CAD':
        return [40, 80, 120, 160, 400];
      case 'INR':
        return [2924, 5849, 8774, 11699, 29247];
      default:
        return [25, 50, 75, 100, 250];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),

          // Header
          Text(
            'HOW MUCH WOULD YOU LIKE TO DONATE TODAY?',
            style: theme.typography.title3.override(),
          ),
          SizedBox(height: 10),
          Text(
            'Every donation is a deeply valued contribution to Akshaya Patra\'s mission.',
            style: theme.typography.bodyText2.override(),
          ),
          SizedBox(height: 20),
          Text(
            'Select donation type',
            style: theme.typography.bodyText1.override(),
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
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
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

          Container(
            height: 43,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Currency>(
                isExpanded: true,
                value: selectedCurrency,
                items:
                    currencies.map((Currency currency) {
                      return DropdownMenuItem<Currency>(
                        value: currency,
                        child: Text(
                          '${currency.name} (${currency.code})',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                style: theme.typography.bodyText1.override(),

                onChanged: (Currency? newCurrency) {
                  if (newCurrency != null) {
                    setState(() {
                      selectedCurrency = newCurrency;
                      selectedAmount = getPresetAmounts().first;
                      isCustomAmount = false;
                      _customAmountController.clear();
                    });
                    getExchangeRate(newCurrency.code, getPresetAmounts().first);
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              selectedAmount != null
                  ? '${selectedCurrency.symbol}${selectedAmount!.toStringAsFixed(selectedCurrency.code == 'INR' ? 0 : 2)}'
                  : '${selectedCurrency.symbol}0',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),

          SizedBox(height: 15),
          if (selectedCurrency.code != 'INR')
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    isLoadingExchangeRate
                        ? Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8),
                            Text('Loading exchange rate...'),
                          ],
                        )
                        : selectedCurrency.exchangeRate != null
                        ? Text(
                          'The current exchange rate is 1.00 ${selectedCurrency.code} equals ${selectedCurrency.exchangeRate?.toStringAsFixed(2) ?? "--"} INR.',
                        )
                        : Text('Unable to fetch exchange rate'),
              ),
            ),
          if (selectedCurrency.code != 'INR') SizedBox(height: 20),
          if (selectedCurrency.code != 'INR' &&
              selectedAmount != null &&
              selectedCurrency.inrValue != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  'Your ${selectedCurrency.symbol}${selectedAmount!.toStringAsFixed(2)} donation equals ₹${selectedCurrency.inrValue!.toStringAsFixed(2)} INR',
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.8,
              crossAxisSpacing: 50,
              mainAxisSpacing: 10,
            ),
            itemCount: getPresetAmounts().length + 1,
            itemBuilder: (context, index) {
              if (index == getPresetAmounts().length) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isCustomAmount = true;
                      //selectedAmount = null;
                      _customAmountController.clear();
                    });
                    Future.delayed(Duration(milliseconds: 100), () {
                      _customAmountFocusNode.requestFocus();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          isCustomAmount ? Colors.blue.shade50 : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isCustomAmount ? Colors.blue : Colors.grey[300]!,
                        width: 0.8,
                      ),
                    ),
                    child: Center(
                      child:
                          isCustomAmount
                              ? TextField(
                                controller: _customAmountController,
                                focusNode: _customAmountFocusNode,
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}'),
                                  ),
                                ],
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  prefixText: selectedCurrency.symbol,
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                onChanged: (value) {
                                  double? amount = double.tryParse(value);
                                  if (amount != null) {
                                    setState(() {
                                      selectedAmount = amount;
                                    });
                                    getExchangeRate(
                                      selectedCurrency.code,
                                      amount,
                                    );
                                    showAmountError = false;
                                  } /*else {
                                    setState(() {
                                      selectedAmount = null;
                                    });
                                  }*/
                                },
                              )
                              : Text(
                                'CUSTOM AMOUNT',
                                style: theme.typography.bodyText2.override(),
                              ),
                    ),
                  ),
                );
              } else {
                double amount = getPresetAmounts()[index];
                bool isSelected = selectedAmount == amount && !isCustomAmount;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAmount = amount;
                      isCustomAmount = false;
                      _customAmountController.clear();
                      showAmountError = false;
                    });
                    getExchangeRate(selectedCurrency.code, amount);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.shade50 : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                        width: 0.8,
                      ),
                    ),
                    constraints: BoxConstraints(minWidth: 40, minHeight: 28),
                    child: Center(
                      child: Text(
                        '${selectedCurrency.symbol}${amount.toStringAsFixed(0)}',
                        style: theme.typography.bodyText1.override(),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          if (showAmountError)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 4.0),
              child: Text(
                "Select or enter donation amount",
                style: theme.typography.bodyText1.override(
                  color: Colors.red,
                  fontSize: 10,
                ),
              ),
            ),
          SizedBox(height: 20),

          Text(
            " Who's giving today?",
            style: theme.typography.title3.override(),
          ),
          SizedBox(height: 8),
          Text(
            "We’ll never share your personal information with anyone.",
            style: theme.typography.bodyText2.override(),
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: getWidgets(),
            ),
          ),
        ],
      ),
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
      }
    }
    widgetList.add(
      Padding(
        padding: EdgeInsets.all(8.0),
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
                    _isSubmitting = false;
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
                          if (_formKey.currentState!.validate()) {
                            print("Donation submitted ✅");
                          }

                          if (checkBoxValue) {
                            bool totaldata = false;

                            List data =
                                answerJson.where((element) {
                                  final isMandatory =
                                      element["mandatory"] == true;

                                  final hasNoAppearance =
                                      !element.containsKey("appearance");
                                  return isMandatory && hasNoAppearance;
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
                            }

                            bool hasValidAmount = false;

                            if (notResidingIndiaDetails.isNotEmpty) {
                              final amountStr =
                                  notResidingIndiaDetails[0]["donation_amount"]
                                      ?.toString()
                                      .trim() ??
                                  '';
                              print("amountStr: $amountStr");
                              if (amountStr.isNotEmpty) {
                                final amount = double.tryParse(amountStr);
                                hasValidAmount = amount != null && amount > 0;
                              }
                            }

                            showAmountError = !hasValidAmount;
                            addAnswerJsonToCitizenshipDetails(
                              List<Map<String, dynamic>>.from(answerJson),
                            );
                            if (totaldata && hasValidAmount) {
                              print("✅ Submitted Data:");
                              print(notResidingIndiaDetails);
                              Map<String, dynamic> finalPayload =
                                  notResidingIndiaDetails.first;

                              Bloc bloc = Bloc();
                              var response = await bloc.SubmitOnlineDonation(
                                finalPayload,
                              );

                              print("responseindiancitizen $response");

                              if (response["status"] == "success") {
                                widget.onNextStep?.call(
                                  passedData: response["data"],
                                );
                                SnackbarHelper.show(
                                  context,
                                  'Donation submitted successfully.',
                                  bgcolor: Colors.green,
                                );
                              } else {
                                SnackbarHelper.show(
                                  context,
                                  'Server Issue. Please try again later',
                                  bgcolor: Colors.red,
                                );
                              }
                            } else {
                              SnackbarHelper.show(
                                context,
                                'Please fill in all the mandatory fields.',
                                bgcolor: Colors.orange.shade700,
                              );
                            }
                          } else {
                            SnackbarHelper.show(
                              context,
                              'Please read and accept the Terms & Conditions.',
                              bgcolor: Colors.orange.shade700,
                            );
                          }
                        } else {
                          SnackbarHelper.show(
                            context,
                            'Please check the internet connection',
                            bgcolor: Colors.orange.shade700,
                          );
                        }
                      } catch (e) {
                        SnackbarHelper.show(
                          context,
                          'An unexpected error occurred. Please try again later.',
                          bgcolor: Colors.red,
                        );
                      } finally {
                        setState(() => _isSubmitting = false);
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

  void addAnswerJsonToCitizenshipDetails(
    List<Map<String, dynamic>> answerJson,
  ) {
    if (notResidingIndiaDetails.isEmpty) return;

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
    details['donation_type'] =
        selectedDonationType != null
            ? donationOptions[selectedDonationType!]
            : '';

    details['donation_monthcount'] = selectedMonth?.toString() ?? '';
    if (notResidingIndiaDetails[0]["not_residing_india_details"] is List) {
      notResidingIndiaDetails[0]["not_residing_india_details"].clear();
      (notResidingIndiaDetails[0]["not_residing_india_details"] as List).add(
        details,
      );
    }
  }
}
