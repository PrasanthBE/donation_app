import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:akshaya_pathara/Global/drawer.dart';
import 'package:akshaya_pathara/Global/exit_helper.dart';
import 'package:akshaya_pathara/Model/campaign_list_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class FundraisingCampaignsPage extends StatefulWidget {
  FundraisingCampaignsPage({Key? key}) : super(key: key);

  @override
  _FundraisingCampaignsPageState createState() =>
      _FundraisingCampaignsPageState();
}

class _FundraisingCampaignsPageState extends State<FundraisingCampaignsPage> {
  bool isLoading = false;
  bool apiCalled = false;
  bool hide = false;

  List<CampaignModel> campaigns = [];
  List<CampaignModel> searchcampaigns = [];
  Set<String> processedOppIds = {};

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    get_donation_history();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _runFilter(String enteredKeyword) {
    List<CampaignModel> results = [];

    if (enteredKeyword.isEmpty) {
      setState(() {
        searchcampaigns = List.from(campaigns);
      });
    } else {
      final keywordLower = enteredKeyword.toLowerCase();

      bool matchesSearch(CampaignModel campaign) {
        return campaign.campaignName.toLowerCase().contains(keywordLower) ||
            campaign.campaignFor.toLowerCase().contains(keywordLower) ||
            campaign.description.toLowerCase().contains(keywordLower) ||
            campaign.description.toLowerCase().contains(keywordLower);
      }

      results = campaigns.where(matchesSearch).toList();

      setState(() {
        searchcampaigns = results;
      });
    }
  }

  Future<void> get_donation_history() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    processedOppIds.clear();
    campaigns = [];
    searchcampaigns = [];

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Static data - replace with your API call
        List<Map<String, dynamic>> jdata = [
          {
            "registerId": "REG001",
            "imageUrl": 'assets/charity_images/charaity1.jpg',
            "campaignFor": 'Mid Day Meal',
            "campaignName": 'AS Wedding',
            "raisedAmount": 0,
            "goalAmount": 100000.0,
            "description": 'Help provide nutritious meals to school children.',
            "startDate": '01-06-2024',
            "endDate": '30-06-2024',
            "created_date": '20-07-2024',
          },
          {
            "registerId": "REG002",
            "imageUrl": 'assets/charity_images/charity4.jpeg',
            "campaignFor": 'Old Age Support',
            "campaignName": 'Joy of Giving',
            "raisedAmount": 5000.0,
            "goalAmount": 500000.0,
            "description": 'Support elderly citizens with food and medicine.',
            "startDate": '01-07-2024',
            "endDate": '31-07-2024',
            "created_date": '20-07-2024',
          },
          {
            "registerId": "REG003",
            "imageUrl": 'assets/charity_images/charity2.jpg',
            "campaignFor": 'Girl Child Education',
            "campaignName": 'Educate Her',
            "raisedAmount": 80000.0,
            "goalAmount": 150000.0,
            "description": 'Sponsor education for underprivileged girls.',
            "startDate": '10-06-2024',
            "endDate": '10-07-2024',
            "created_date": '20-07-2024',
          },
          {
            "registerId": "REG004",
            "imageUrl": 'assets/charity_images/charity7.jpeg',
            "campaignFor": 'Disaster Relief',
            "campaignName": 'Flood Help',
            "raisedAmount": 190000.0,
            "goalAmount": 300000.0,
            "description": 'Provide shelter and supplies for flood victims.',
            "startDate": '05-06-2024',
            "endDate": '05-07-2024',
            "created_date": '20-07-2024',
          },
          {
            "registerId": "REG005",
            "imageUrl": 'assets/charity_images/charity5.jpeg',
            "campaignFor": 'Children Growth',
            "campaignName": 'Children Education',
            "raisedAmount": 120000.0,
            "goalAmount": 200000.0,
            "description": 'Support rescue and care of child.',
            "startDate": '15-06-2024',
            "endDate": '15-07-2024',
            "created_date": '20-07-2024',
          },
          {
            "registerId": "REG006",
            "imageUrl": 'assets/charity_images/charity6.jpeg',
            "campaignFor": 'Homeless Mothers',
            "campaignName": 'Home for Her',
            "raisedAmount": 60000.0,
            "goalAmount": 120000.0,
            "description": 'Provide safe housing for homeless mothers.',
            "startDate": '20-06-2024',
            "endDate": '20-07-2024',
            "created_date": '20-07-2024',
          },
        ];

        // Sort by created_date
        jdata.sort((a, b) {
          try {
            DateTime dateA = DateFormat("dd-MM-yyyy").parse(a['created_date']);
            DateTime dateB = DateFormat("dd-MM-yyyy").parse(b['created_date']);
            return dateB.compareTo(dateA);
          } catch (e) {
            return 0;
          }
        });

        for (var element in jdata) {
          final regNo = element['registerId'];
          if (processedOppIds.contains(regNo)) continue;

          processedOppIds.add(regNo);

          // Create model from map - adjust according to your CampaignModel
          CampaignModel model = CampaignModel.fromMap(element);

          campaigns.add(model);
          searchcampaigns.add(model);
        }

        if (mounted) {
          setState(() {
            apiCalled = true;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      Fluttertoast.showToast(
        msg: "Check your Internet connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.deepPurple,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> refreshData() async {
    await get_donation_history();
  }

  Widget _buildEmptyState() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading campaigns...',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    if (searchController.text.isNotEmpty && searchcampaigns.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No campaigns found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try searching with different keywords',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    if (campaigns.isEmpty && !isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.campaign_outlined, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No campaigns available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Check back later for new campaigns',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: refreshData, child: Text('Refresh')),
          ],
        ),
      );
    }

    return SizedBox.shrink();
  }

  double percent = 0.65; // Example: 65%

  Widget _buildCampaignGrid() {
    if (isLoading || campaigns.isEmpty) {
      return Expanded(child: _buildEmptyState());
    }

    if (searchcampaigns.isEmpty && searchController.text.isNotEmpty) {
      return Expanded(child: _buildEmptyState());
    }
    final theme = AppTheme.of(context);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: searchcampaigns.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Adjusted for better mobile view
            childAspectRatio: 0.55,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final campaign = searchcampaigns[index];
            final percent = (campaign.raisedAmount / campaign.goalAmount).clamp(
              0.0,
              1.0,
            );

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Image
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(
                      campaign.imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[600],
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /* Stack(
                              children: [
                                LinearProgressIndicator(
                                  value: percent,
                                  minHeight: 8,
                                  backgroundColor: Colors.grey.shade300,
                                  color: Colors.green,
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      '${(percent * 100).toStringAsFixed(0)}%',
                                      style: theme.typography.bodyText1.override(
                                        fontSize: 6,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),*/
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tooltip above the bar
                                Builder(
                                  builder: (context) {
                                    final barWidth =
                                        MediaQuery.of(context).size.width * 0.4;
                                    final double leftOffset =
                                        (barWidth * percent) - 15;
                                    final double safeLeft =
                                        leftOffset < 0 ? 0 : leftOffset;

                                    return Container(
                                      margin: EdgeInsets.only(left: safeLeft),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${(percent * 100).toStringAsFixed(0)}%',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 4),
                                // Progress bar
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: LinearProgressIndicator(
                                    value: percent,
                                    minHeight: 8,
                                    backgroundColor: Colors.grey.shade300,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 6),
                            Text(
                              'Raised: ₹${NumberFormat('#,##,###').format(campaign.raisedAmount)}',
                              style: theme.typography.bodyText3.override(
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              'Goal: ₹${NumberFormat('#,##,###').format(campaign.goalAmount)}',
                              style: theme.typography.bodyText2.override(
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(height: 4),

                            Row(
                              children: [
                                Icon(
                                  Icons.campaign,
                                  color: Colors.blue,
                                  size: 14,
                                ),
                                SizedBox(
                                  width: 4,
                                ), // spacing between icon and text
                                Text(
                                  campaign.campaignFor,
                                  style: theme.typography.bodyText3.override(
                                    fontSize: 10,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.volunteer_activism,
                                  color: Colors.black,
                                  size: 14,
                                ),
                                SizedBox(
                                  width: 4,
                                ), // spacing between icon and text
                                Expanded(
                                  child: Text(
                                    campaign.campaignName,
                                    style:
                                        theme.typography.bodyText2.override(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              campaign.description,
                              style: theme.typography.bodyText3.override(
                                fontSize: 10,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            SizedBox(
                              height: 30,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  // TODO: Navigate to detail or donation screen
                                  print('Donate to: ${campaign.campaignName}');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                ),
                                child: Text(
                                  'DONATE NOW',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      return await ExitHelper.showExitConfirmationDialog(context);
    }

    return WillPopScope(
      onWillPop: _onWillPop,

      child: Scaffold(
        appBar: AppBar(
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              'Fundraising Campaigns',
              style: AppTheme.of(context).title3.override(),
            ),
          ),
          leading: Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(Icons.menu, color: Colors.black87),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                hide ? Icons.clear : Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  hide = !hide;
                  if (!hide) {
                    searchController.clear();
                    _runFilter('');
                  }
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: Icon(Icons.refresh, color: Colors.black),
                onPressed: refreshData,
              ),
            ),
          ],
        ),
        drawer: AppDrawer(currentPage: 'donation_campaign_list'),
        body: Column(
          children: [
            if (hide)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: _runFilter,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    prefixIcon: Icon(Icons.search, size: 20),
                    suffixIcon:
                        searchController.text.isNotEmpty
                            ? IconButton(
                              onPressed: () {
                                searchController.clear();
                                _runFilter('');
                              },
                              icon: Icon(Icons.clear),
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    hintText: 'Search campaigns...',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            _buildCampaignGrid(),
          ],
        ),
      ),
    );
  }
}
