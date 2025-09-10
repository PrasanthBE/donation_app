import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:akshaya_pathara/Global/drawer.dart';
import 'package:akshaya_pathara/Global/exit_helper.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/ap.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/as.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/br.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/ch.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/ct.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/dd.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/dl.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/dn.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/ga.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/gj.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/hp.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/hr.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/jh.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/jk.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/ka.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/kl.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/mh.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/ml.dart'
    show MLClipper;
import 'package:akshaya_pathara/Pages/india_map/state-clippers/mn.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/mp.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/mz.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/nl.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/or.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/ori.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/pb.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/py.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/pyi.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/pyii.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/rj.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/sk.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/tg.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/tn.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/tn_i.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/tr.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/up.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/ut.dart';
import 'package:akshaya_pathara/Pages/india_map/state-clippers/wb.dart';
import 'package:akshaya_pathara/Pages/india_map/state-decorator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class statewisedonationoverview extends StatefulWidget {
  @override
  _statewisedonationoverview createState() => _statewisedonationoverview();
}

class _statewisedonationoverview extends State<statewisedonationoverview> {
  String? selectedState;
  int? selectedCount;
  // State counts data
  final Map<String, int> stateCounts = {
    'Jammu and Kashmir': 14580,
    'Himachal Pradesh': 2061,
    'Uttarakhand': 55000,
    'Punjab': 3664,
    'Chandigarh': 229,
    'Haryana': 1145,
    'Delhi': 2748,
    'Uttar Pradesh': 5954,
    'Rajasthan': 2242,
    'Madhya Pradesh': 4580,
    'Gujarat': 3206,
    'Daman & Diu': 45,
    'Maharashtra': 6412,
    'Goa': 1374,
    'Karnataka': 3893,
    'Telangana': 4351,
    'Andhra Pradesh': 5040,
    'Kerala': 6869,
    'Tamil Nadu': 11450,
    'Tamil Nadu Islands': 229,
    'Chhattisgarh': 916,
    'Odisha': 0,
    'Odisha Islands': 137,
    'Jharkhand': 2520,
    'Bihar': 0,
    'West Bengal': 3022,
    'Sikkim': 0,
    'Assam': 549,
    'Meghalaya': 91,
    'Nagaland': 137,
    'Manipur': 183,
    'Mizoram': 0,
    'Tripura': 229,
    'Dadra Nagar Haveli': 686,
    'Puducherry': 91,
    'Puducherry Islands': 45,
    'Puducherry Islands 2': 45,
  };

  final Map<String, String> stateMapping = {
    'JKClipper': 'Jammu and Kashmir',
    'HPClipper': 'Himachal Pradesh',
    'UTclipper': 'Uttarakhand',
    'PBClipper': 'Punjab',
    'CHClipper': 'Chandigarh',
    'HRClipper': 'Haryana',
    'DLClipper': 'Delhi',
    'UPClipper': 'Uttar Pradesh',
    'RJClipper': 'Rajasthan',
    'MPClipper': 'Madhya Pradesh',
    'GJClipper': 'Gujarat',
    'DDClipper': 'Daman & Diu',
    'MHClipper': 'Maharashtra',
    'GAClipper': 'Goa',
    'KAClipper': 'Karnataka',
    'TGClipper': 'Telangana',
    'APClipper': 'Andhra Pradesh',
    'KLClipper': 'Kerala',
    'TNClipper': 'Tamil Nadu',
    'TNIClipper': 'Tamil Nadu Islands',
    'CTClipper': 'Chhattisgarh',
    'ORClipper': 'Odisha',
    'ORIClipper': 'Odisha Islands',
    'JHClipper': 'Jharkhand',
    'BRClipper': 'Bihar',
    'WBClipper': 'West Bengal',
    'SKClipper': 'Sikkim',
    'ASClipper': 'Assam',
    'MLClipper': 'Meghalaya',
    'NLClipper': 'Nagaland',
    'MNClipper': 'Manipur',
    'MZClipper': 'Mizoram',
    'TRClipper': 'Tripura',
    'DNClipper': 'Dadra Nagar Haveli',
    'PYClipper': 'Puducherry',
    'PYIClipper': 'Puducherry Islands',
    'PYIIClipper': 'Puducherry Islands 2',
  };

  //'#2979ff', '#8DD8FF', '#C6E7FF'
  void onStateSelected(String stateName, int count) {
    setState(() {
      selectedState = stateName;
      selectedCount = count;
    });
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
        backgroundColor: Colors.blue.shade100,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(Icons.menu, color: Colors.black87),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
          ),
          title: Text('State-wise Donations', style: theme.title3),
        ),
        drawer: AppDrawer(currentPage: 'state_wise_overview'),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: <Widget>[
              StateDecorator(
                xShift: 65,
                yShift: 215,
                stateClipper: JKClipper(),
                stateName: stateMapping['JKClipper']!,
                count: stateCounts[stateMapping['JKClipper']!]!,
                isSelected: selectedState == stateMapping['JKClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 106,
                yShift: 281,
                stateClipper: HPClipper(),
                stateName: stateMapping['HPClipper']!,
                count: stateCounts[stateMapping['HPClipper']!]!,
                isSelected: selectedState == stateMapping['HPClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 133,
                yShift: 311,
                stateClipper: UTclipper(),
                stateName: stateMapping['UTclipper']!,
                count: stateCounts[stateMapping['UTclipper']!]!,
                isSelected: selectedState == stateMapping['UTclipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 82,
                yShift: 292,
                stateClipper: PBClipper(),
                stateName: stateMapping['PBClipper']!,
                count: stateCounts[stateMapping['PBClipper']!]!,
                isSelected: selectedState == stateMapping['PBClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 121,
                yShift: 322,
                stateClipper: CHClipper(),
                stateName: stateMapping['CHClipper']!,
                count: stateCounts[stateMapping['CHClipper']!]!,
                isSelected: selectedState == stateMapping['CHClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 90,
                yShift: 320,
                stateClipper: HRClipper(),
                stateName: stateMapping['HRClipper']!,
                count: stateCounts[stateMapping['HRClipper']!]!,
                isSelected: selectedState == stateMapping['HRClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 123,
                yShift: 353,
                stateClipper: DLClipper(),
                stateName: stateMapping['DLClipper']!,
                count: stateCounts[stateMapping['DLClipper']!]!,
                isSelected: selectedState == stateMapping['DLClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 126,
                yShift: 328,
                stateClipper: UPClipper(),
                stateName: stateMapping['UPClipper']!,
                count: stateCounts[stateMapping['UPClipper']!]!,
                isSelected: selectedState == stateMapping['UPClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 21,
                yShift: 332,
                stateClipper: RJClipper(),
                stateName: stateMapping['RJClipper']!,
                count: stateCounts[stateMapping['RJClipper']!]!,
                isSelected: selectedState == stateMapping['RJClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 84,
                yShift: 385,
                stateClipper: MPClipper(),
                stateName: stateMapping['MPClipper']!,
                count: stateCounts[stateMapping['MPClipper']!]!,
                isSelected: selectedState == stateMapping['MPClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 8,
                yShift: 420,
                stateClipper: GJClipper(),
                stateName: stateMapping['GJClipper']!,
                count: stateCounts[stateMapping['GJClipper']!]!,
                isSelected: selectedState == stateMapping['GJClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 38,
                yShift: 477,
                stateClipper: DDClipper(),
                stateName: stateMapping['DDClipper']!,
                count: stateCounts[stateMapping['DDClipper']!]!,
                isSelected: selectedState == stateMapping['DDClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 65,
                yShift: 461,
                stateClipper: MHClipper(),
                stateName: stateMapping['MHClipper']!,
                count: stateCounts[stateMapping['MHClipper']!]!,
                isSelected: selectedState == stateMapping['MHClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 79,
                yShift: 555,
                stateClipper: GAClipper(),
                stateName: stateMapping['GAClipper']!,
                count: stateCounts[stateMapping['GAClipper']!]!,
                isSelected: selectedState == stateMapping['GAClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 85,
                yShift: 515,
                stateClipper: KAClipper(),
                stateName: stateMapping['KAClipper']!,
                count: stateCounts[stateMapping['KAClipper']!]!,
                isSelected: selectedState == stateMapping['KAClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 129,
                yShift: 493,
                stateClipper: TGClipper(),
                stateName: stateMapping['TGClipper']!,
                count: stateCounts[stateMapping['TGClipper']!]!,
                isSelected: selectedState == stateMapping['TGClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 122,
                yShift: 505,
                stateClipper: APClipper(),
                stateName: stateMapping['APClipper']!,
                count: stateCounts[stateMapping['APClipper']!]!,
                isSelected: selectedState == stateMapping['APClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 96,
                yShift: 599,
                stateClipper: KLClipper(),
                stateName: stateMapping['KLClipper']!,
                count: stateCounts[stateMapping['KLClipper']!]!,
                isSelected: selectedState == stateMapping['KLClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 115,
                yShift: 588,
                stateClipper: TNClipper(),
                stateName: stateMapping['TNClipper']!,
                count: stateCounts[stateMapping['TNClipper']!]!,
                isSelected: selectedState == stateMapping['TNClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 156.3,
                yShift: 649.12,
                stateClipper: TNIClipper(),
                stateName: stateMapping['TNIClipper']!,
                count: stateCounts[stateMapping['TNIClipper']!]!,
                isSelected: selectedState == stateMapping['TNIClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 170,
                yShift: 429,
                stateClipper: CTClipper(),
                stateName: stateMapping['CTClipper']!,
                count: stateCounts[stateMapping['CTClipper']!]!,
                isSelected: selectedState == stateMapping['CTClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 186,
                yShift: 453,
                stateClipper: ORClipper(),
                stateName: stateMapping['ORClipper']!,
                count: stateCounts[stateMapping['ORClipper']!]!,
                isSelected: selectedState == stateMapping['ORClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 260,
                yShift: 480,
                stateClipper: ORIClipper(),
                stateName: stateMapping['ORIClipper']!,
                count: stateCounts[stateMapping['ORIClipper']!]!,
                isSelected: selectedState == stateMapping['ORIClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 213,
                yShift: 410,
                stateClipper: JHClipper(),
                stateName: stateMapping['JHClipper']!,
                count: stateCounts[stateMapping['JHClipper']!]!,
                isSelected: selectedState == stateMapping['JHClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 213,
                yShift: 375,
                stateClipper: BRClipper(),
                stateName: stateMapping['BRClipper']!,
                count: stateCounts[stateMapping['BRClipper']!]!,
                isSelected: selectedState == stateMapping['BRClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 247,
                yShift: 380,
                stateClipper: WBClipper(),
                stateName: stateMapping['WBClipper']!,
                count: stateCounts[stateMapping['WBClipper']!]!,
                isSelected: selectedState == stateMapping['WBClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 278,
                yShift: 365,
                stateClipper: SKClipper(),
                stateName: stateMapping['SKClipper']!,
                count: stateCounts[stateMapping['SKClipper']!]!,
                isSelected: selectedState == stateMapping['SKClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 301,
                yShift: 368,
                stateClipper: ASClipper(),
                stateName: stateMapping['ASClipper']!,
                count: stateCounts[stateMapping['ASClipper']!]!,
                isSelected: selectedState == stateMapping['ASClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 303,
                yShift: 397,
                stateClipper: MLClipper(),
                stateName: stateMapping['MLClipper']!,
                count: stateCounts[stateMapping['MLClipper']!]!,
                isSelected: selectedState == stateMapping['MLClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 351,
                yShift: 383,
                stateClipper: NLClipper(),
                stateName: stateMapping['NLClipper']!,
                count: stateCounts[stateMapping['NLClipper']!]!,
                isSelected: selectedState == stateMapping['NLClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 346,
                yShift: 404,
                stateClipper: MNClipper(),
                stateName: stateMapping['MNClipper']!,
                count: stateCounts[stateMapping['MNClipper']!]!,
                isSelected: selectedState == stateMapping['MNClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 336,
                yShift: 422,
                stateClipper: MZClipper(),
                stateName: stateMapping['MZClipper']!,
                count: stateCounts[stateMapping['MZClipper']!]!,
                isSelected: selectedState == stateMapping['MZClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 321,
                yShift: 422,
                stateClipper: TRClipper(),
                stateName: stateMapping['TRClipper']!,
                count: stateCounts[stateMapping['TRClipper']!]!,
                isSelected: selectedState == stateMapping['TRClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 69,
                yShift: 486,
                stateClipper: DNClipper(),
                stateName: stateMapping['DNClipper']!,
                count: stateCounts[stateMapping['DNClipper']!]!,
                isSelected: selectedState == stateMapping['DNClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 163,
                yShift: 625,
                stateClipper: PYClipper(),
                stateName: stateMapping['PYClipper']!,
                count: stateCounts[stateMapping['PYClipper']!]!,
                isSelected: selectedState == stateMapping['PYClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 162,
                yShift: 610,
                stateClipper: PYIClipper(),
                stateName: stateMapping['PYIClipper']!,
                count: stateCounts[stateMapping['PYIClipper']!]!,
                isSelected: selectedState == stateMapping['PYIClipper']!,
                onTap: onStateSelected,
              ),
              StateDecorator(
                xShift: 197,
                yShift: 540,
                stateClipper: PYIIClipper(),
                stateName: stateMapping['PYIIClipper']!,
                count: stateCounts[stateMapping['PYIIClipper']!]!,
                isSelected: selectedState == stateMapping['PYIIClipper']!,
                onTap: onStateSelected,
              ),
              Positioned(
                top: 30,
                left: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.all(12),
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.circular(8),
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.black26,
                  //       blurRadius: 4,
                  //       offset: Offset(2, 2),
                  //     ),
                  //   ],
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LegendItem(
                            color: Color(0xFF2979ff),
                            text: '\u{20B9}5000+ donations',
                          ),
                          SizedBox(height: 8),
                          LegendItem(
                            color: Color(0xFF8DD8FF),
                            text: '\u{20B9}1000–4999',
                          ),
                          SizedBox(height: 8),

                          LegendItem(
                            color: Color(0xFFC6E7FF),
                            text: '\u{20B9}500–999',
                          ),
                        ],
                      ),

                      // Right Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LegendItem(
                            color: Colors.greenAccent,
                            text: '< \u{20B9}500',
                          ),
                          SizedBox(height: 8),
                          LegendItem(
                            color: Colors.grey.shade100,
                            text: 'No donations',
                          ),
                          LegendItem(
                            color: Color(0xFFFFCC00),
                            text: 'Selected State',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        /*  body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: [
                  // Tooltip at top
                  Container(
                    width: double.infinity,
                    // padding: EdgeInsets.all(16),
                    color: Colors.grey[100],
                    child: Text(
                      selectedState != null
                          ? '$selectedState: $selectedCount donors'
                          : 'Tap on a state to see donor count',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Map container
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Container(
                      color: Colors.white,
                      child: buildIndiaStateMapStack(),
                    ),
                  ),

                  // Legend

                ],
              ),
            ),
          ],
        ),*/
      ),
    );
  }

  Widget buildIndiaStateMapStack() {
    return Stack(
      children: <Widget>[
        StateDecorator(
          xShift: 65,
          yShift: 215,
          stateClipper: JKClipper(),
          stateName: stateMapping['JKClipper']!,
          count: stateCounts[stateMapping['JKClipper']!]!,
          isSelected: selectedState == stateMapping['JKClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 106,
          yShift: 281,
          stateClipper: HPClipper(),
          stateName: stateMapping['HPClipper']!,
          count: stateCounts[stateMapping['HPClipper']!]!,
          isSelected: selectedState == stateMapping['HPClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 133,
          yShift: 311,
          stateClipper: UTclipper(),
          stateName: stateMapping['UTclipper']!,
          count: stateCounts[stateMapping['UTclipper']!]!,
          isSelected: selectedState == stateMapping['UTclipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 82,
          yShift: 292,
          stateClipper: PBClipper(),
          stateName: stateMapping['PBClipper']!,
          count: stateCounts[stateMapping['PBClipper']!]!,
          isSelected: selectedState == stateMapping['PBClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 121,
          yShift: 322,
          stateClipper: CHClipper(),
          stateName: stateMapping['CHClipper']!,
          count: stateCounts[stateMapping['CHClipper']!]!,
          isSelected: selectedState == stateMapping['CHClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 90,
          yShift: 320,
          stateClipper: HRClipper(),
          stateName: stateMapping['HRClipper']!,
          count: stateCounts[stateMapping['HRClipper']!]!,
          isSelected: selectedState == stateMapping['HRClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 123,
          yShift: 353,
          stateClipper: DLClipper(),
          stateName: stateMapping['DLClipper']!,
          count: stateCounts[stateMapping['DLClipper']!]!,
          isSelected: selectedState == stateMapping['DLClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 126,
          yShift: 328,
          stateClipper: UPClipper(),
          stateName: stateMapping['UPClipper']!,
          count: stateCounts[stateMapping['UPClipper']!]!,
          isSelected: selectedState == stateMapping['UPClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 21,
          yShift: 332,
          stateClipper: RJClipper(),
          stateName: stateMapping['RJClipper']!,
          count: stateCounts[stateMapping['RJClipper']!]!,
          isSelected: selectedState == stateMapping['RJClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 84,
          yShift: 385,
          stateClipper: MPClipper(),
          stateName: stateMapping['MPClipper']!,
          count: stateCounts[stateMapping['MPClipper']!]!,
          isSelected: selectedState == stateMapping['MPClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 8,
          yShift: 420,
          stateClipper: GJClipper(),
          stateName: stateMapping['GJClipper']!,
          count: stateCounts[stateMapping['GJClipper']!]!,
          isSelected: selectedState == stateMapping['GJClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 38,
          yShift: 477,
          stateClipper: DDClipper(),
          stateName: stateMapping['DDClipper']!,
          count: stateCounts[stateMapping['DDClipper']!]!,
          isSelected: selectedState == stateMapping['DDClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 65,
          yShift: 461,
          stateClipper: MHClipper(),
          stateName: stateMapping['MHClipper']!,
          count: stateCounts[stateMapping['MHClipper']!]!,
          isSelected: selectedState == stateMapping['MHClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 79,
          yShift: 555,
          stateClipper: GAClipper(),
          stateName: stateMapping['GAClipper']!,
          count: stateCounts[stateMapping['GAClipper']!]!,
          isSelected: selectedState == stateMapping['GAClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 85,
          yShift: 515,
          stateClipper: KAClipper(),
          stateName: stateMapping['KAClipper']!,
          count: stateCounts[stateMapping['KAClipper']!]!,
          isSelected: selectedState == stateMapping['KAClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 129,
          yShift: 493,
          stateClipper: TGClipper(),
          stateName: stateMapping['TGClipper']!,
          count: stateCounts[stateMapping['TGClipper']!]!,
          isSelected: selectedState == stateMapping['TGClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 122,
          yShift: 505,
          stateClipper: APClipper(),
          stateName: stateMapping['APClipper']!,
          count: stateCounts[stateMapping['APClipper']!]!,
          isSelected: selectedState == stateMapping['APClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 96,
          yShift: 599,
          stateClipper: KLClipper(),
          stateName: stateMapping['KLClipper']!,
          count: stateCounts[stateMapping['KLClipper']!]!,
          isSelected: selectedState == stateMapping['KLClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 115,
          yShift: 588,
          stateClipper: TNClipper(),
          stateName: stateMapping['TNClipper']!,
          count: stateCounts[stateMapping['TNClipper']!]!,
          isSelected: selectedState == stateMapping['TNClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 156.3,
          yShift: 649.12,
          stateClipper: TNIClipper(),
          stateName: stateMapping['TNIClipper']!,
          count: stateCounts[stateMapping['TNIClipper']!]!,
          isSelected: selectedState == stateMapping['TNIClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 170,
          yShift: 429,
          stateClipper: CTClipper(),
          stateName: stateMapping['CTClipper']!,
          count: stateCounts[stateMapping['CTClipper']!]!,
          isSelected: selectedState == stateMapping['CTClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 186,
          yShift: 453,
          stateClipper: ORClipper(),
          stateName: stateMapping['ORClipper']!,
          count: stateCounts[stateMapping['ORClipper']!]!,
          isSelected: selectedState == stateMapping['ORClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 260,
          yShift: 480,
          stateClipper: ORIClipper(),
          stateName: stateMapping['ORIClipper']!,
          count: stateCounts[stateMapping['ORIClipper']!]!,
          isSelected: selectedState == stateMapping['ORIClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 213,
          yShift: 410,
          stateClipper: JHClipper(),
          stateName: stateMapping['JHClipper']!,
          count: stateCounts[stateMapping['JHClipper']!]!,
          isSelected: selectedState == stateMapping['JHClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 213,
          yShift: 375,
          stateClipper: BRClipper(),
          stateName: stateMapping['BRClipper']!,
          count: stateCounts[stateMapping['BRClipper']!]!,
          isSelected: selectedState == stateMapping['BRClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 247,
          yShift: 380,
          stateClipper: WBClipper(),
          stateName: stateMapping['WBClipper']!,
          count: stateCounts[stateMapping['WBClipper']!]!,
          isSelected: selectedState == stateMapping['WBClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 278,
          yShift: 365,
          stateClipper: SKClipper(),
          stateName: stateMapping['SKClipper']!,
          count: stateCounts[stateMapping['SKClipper']!]!,
          isSelected: selectedState == stateMapping['SKClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 301,
          yShift: 368,
          stateClipper: ASClipper(),
          stateName: stateMapping['ASClipper']!,
          count: stateCounts[stateMapping['ASClipper']!]!,
          isSelected: selectedState == stateMapping['ASClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 303,
          yShift: 397,
          stateClipper: MLClipper(),
          stateName: stateMapping['MLClipper']!,
          count: stateCounts[stateMapping['MLClipper']!]!,
          isSelected: selectedState == stateMapping['MLClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 351,
          yShift: 383,
          stateClipper: NLClipper(),
          stateName: stateMapping['NLClipper']!,
          count: stateCounts[stateMapping['NLClipper']!]!,
          isSelected: selectedState == stateMapping['NLClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 346,
          yShift: 404,
          stateClipper: MNClipper(),
          stateName: stateMapping['MNClipper']!,
          count: stateCounts[stateMapping['MNClipper']!]!,
          isSelected: selectedState == stateMapping['MNClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 336,
          yShift: 422,
          stateClipper: MZClipper(),
          stateName: stateMapping['MZClipper']!,
          count: stateCounts[stateMapping['MZClipper']!]!,
          isSelected: selectedState == stateMapping['MZClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 321,
          yShift: 422,
          stateClipper: TRClipper(),
          stateName: stateMapping['TRClipper']!,
          count: stateCounts[stateMapping['TRClipper']!]!,
          isSelected: selectedState == stateMapping['TRClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 69,
          yShift: 486,
          stateClipper: DNClipper(),
          stateName: stateMapping['DNClipper']!,
          count: stateCounts[stateMapping['DNClipper']!]!,
          isSelected: selectedState == stateMapping['DNClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 163,
          yShift: 625,
          stateClipper: PYClipper(),
          stateName: stateMapping['PYClipper']!,
          count: stateCounts[stateMapping['PYClipper']!]!,
          isSelected: selectedState == stateMapping['PYClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 162,
          yShift: 610,
          stateClipper: PYIClipper(),
          stateName: stateMapping['PYIClipper']!,
          count: stateCounts[stateMapping['PYIClipper']!]!,
          isSelected: selectedState == stateMapping['PYIClipper']!,
          onTap: onStateSelected,
        ),
        StateDecorator(
          xShift: 197,
          yShift: 540,
          stateClipper: PYIIClipper(),
          stateName: stateMapping['PYIIClipper']!,
          count: stateCounts[stateMapping['PYIIClipper']!]!,
          isSelected: selectedState == stateMapping['PYIIClipper']!,
          onTap: onStateSelected,
        ),
      ],
    );
  }
}
