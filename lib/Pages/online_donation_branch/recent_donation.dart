import 'dart:async';
import 'dart:convert';
import 'dart:io';
//import 'package:OrigaSuperAPP/pages/lead_history_timeline.dart';

import 'package:akshaya_pathara/Global/FilterLeads.dart';
import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:akshaya_pathara/Global/drawer.dart';
import 'package:akshaya_pathara/Global/exit_helper.dart' show ExitHelper;
import 'package:akshaya_pathara/Model/donation_history_model.dart';
import 'package:akshaya_pathara/Model/test.dart';
import 'package:akshaya_pathara/Model/upcoming_donation_model.dart';
import 'package:akshaya_pathara/Pages/online_donation_form.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    show MdiIcons;
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class recent_donation_history extends StatefulWidget {
  recent_donation_history();

  @override
  State<recent_donation_history> createState() => CardExample();
}

class CardExample extends State<recent_donation_history>
    with RouteAware, TickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  bool hide = false;
  bool apiCalled = false;
  bool isLoading = false;
  Set<int> loadingIndexes = {};
  Map<int, bool> expandedCards = {};

  List<DonationHistoryModel> unllist = [];
  // List<DonationHistoryModel> filteredLeads2 = [];
  // List<DonationHistoryModel> filteredLeads3 = [];
  List<DonationHistoryModel> allLeadssearch = [];
  // List<DonationHistoryModel> filteredLeads2search = [];
  // List<DonationHistoryModel> filteredLeads3search = [];
  List<UpcomingDonationModel> filteredLeads1 = [];
  List<UpcomingDonationModel> filteredLeads1search = [];

  String emptyFilterMessage = '';

  int allLeadsCount = 0;
  int UpcomingleadsCount = 0;

  Set<String> activeFilters = {};
  List<DonationHistoryModel> originalUnllist = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      get_dontion_history();
      get_upcoming_donation();
    });
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onBottomNavigationTapped);
  }

  bool _isApiCallInProgress = false;

  void _onBottomNavigationTapped() {
    setState(() {
      searchController.text = "";
    });

    _runFilter('');
  }

  @override
  void dispose() {
    searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  /*
  void _runFilter(String enteredKeyword) {
    List<DonationHistoryModel> results0 = [];
    List<UpcomingDonationModel> results1 = [];
    // List<DonationHistoryModel> results2 = [];
    // List<DonationHistoryModel> results3 = [];

    if (enteredKeyword.isEmpty) {
      setState(() {
        allLeadssearch = List.from(unllist);
        filteredLeads1search = List.from(filteredLeads1);
        // filteredLeads2search = List.from(filteredLeads2);
        // filteredLeads3search = List.from(filteredLeads3);
      });
    } else {
      final keywordLower = enteredKeyword.toLowerCase();

      bool matchesSearch(DonationHistoryModel Donation) {
        return Donation.charityName.toLowerCase().contains(keywordLower) ||
            Donation.mobileNumber.toLowerCase().contains(keywordLower) ||
            Donation.website.toLowerCase().contains(keywordLower) ||
            Donation.donationType.toLowerCase().contains(keywordLower) ||
            Donation.donatedOn.toLowerCase().contains(keywordLower) ||
            Donation.registrationNo.toLowerCase().contains(keywordLower) ||
            (Donation.contactEmail?.toLowerCase().contains(keywordLower) ??
                false);
      }

      results0 = unllist.where(matchesSearch).toList();
      results1 = filteredLeads1.where(matchesSearch).toList();
      // results2 = filteredLeads2.where(matchesSearch).toList();
      // results3 = filteredLeads3.where(matchesSearch).toList();

      setState(() {
        allLeadssearch = results0;
        filteredLeads1search = results1;
        // filteredLeads2search = results2;
        // filteredLeads3search = results3;
      });
    }
  }
*/
  void _runFilter(String enteredKeyword) {
    List<DonationHistoryModel> results0 = [];
    List<UpcomingDonationModel> results1 = [];

    if (enteredKeyword.isEmpty) {
      setState(() {
        allLeadssearch = List.from(unllist); // for DonationHistoryModel
        filteredLeads1search = List.from(
          filteredLeads1,
        ); // for UpcomingDonationModel
      });
    } else {
      final keywordLower = enteredKeyword.toLowerCase();

      bool matchesDonationHistory(DonationHistoryModel donation) {
        return donation.charityName.toLowerCase().contains(keywordLower) ||
            donation.mobileNumber.toLowerCase().contains(keywordLower) ||
            donation.website.toLowerCase().contains(keywordLower) ||
            donation.donationType.toLowerCase().contains(keywordLower) ||
            donation.donatedOn.toLowerCase().contains(keywordLower) ||
            donation.registrationNo.toLowerCase().contains(keywordLower) ||
            (donation.contactEmail?.toLowerCase().contains(keywordLower) ??
                false);
      }

      bool matchesUpcomingDonation(UpcomingDonationModel donation) {
        return donation.charityName.toLowerCase().contains(keywordLower) ||
            donation.donorName.toLowerCase().contains(keywordLower) ||
            donation.donationType.toLowerCase().contains(keywordLower) ||
            donation.donorId.toLowerCase().contains(keywordLower) ||
            donation.charityEmail.toLowerCase().contains(keywordLower) ||
            donation.charityContact.toLowerCase().contains(keywordLower) ||
            donation.notes.toLowerCase().contains(keywordLower);
      }

      results0 = unllist.where(matchesDonationHistory).toList();
      results1 = filteredLeads1.where(matchesUpcomingDonation).toList();

      setState(() {
        allLeadssearch = results0;
        filteredLeads1search = results1;
      });
    }
  }

  void _applyFilters() {
    final result = FilterUtils.applyFilters(
      originalList: originalUnllist,
      activeFilters: activeFilters,
    );

    setState(() {
      unllist = List.from(result['filteredList']);
      allLeadssearch = List.from(result['filteredList']);
      emptyFilterMessage = result['emptyMessage'];
    });
  }

  Widget _buildAnimatedCardallleads({
    // int index,
    // dynamic item,
    // bool isAllLeadsSearchList,
    required int index,
    required DonationHistoryModel model,
    required bool isAllLeadsSearchList,
  }) {
    String status = '';
    if (model.transcation_status != null) {
      switch (model.transcation_status.toLowerCase()) {
        case 'success':
          status = 'Donated';
          break;
        case 'incomplete':
          status = 'In Progress';
          break;
        case 'failed':
          status = 'Failed';
          break;
        default:
          status = '';
      }
    }
    final theme = AppTheme.of(context);
    // String fullAddress = [
    //   model.address?.trim(),
    //   model.city?.trim(),
    //   model.state?.trim(),
    //   model.pincode?.trim(),
    // ].where((e) => e != null && e.isNotEmpty).join(', ');

    //final displayAddress = fullAddress.isEmpty ? 'NA' : fullAddress;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width:
                                  isAllLeadsSearchList
                                      ? MediaQuery.of(context).size.width * 0.6
                                      : MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                children: [
                                  Material(
                                    elevation: 0,
                                    shape: const CircleBorder(),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.black12,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Image.asset(
                                        'assets/loginimage/helping_hand.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        "${model.charityName.isEmpty ? 'NA' : model.charityName.toUpperCase()}",
                                        style: theme.typography.bodyText1
                                            .override(
                                              color: theme.primaryText,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 5),
                            if (isAllLeadsSearchList)
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.3,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: _getStatusGradient(status),
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _getStatusIcon(status),
                                      SizedBox(width: 4),
                                      Text(
                                        status,
                                        style: theme.typography.bodyText1
                                            .override(
                                              color: theme.secondaryText,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Icon(
                                  Icons.description_outlined,
                                  size: 13,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: SingleChildScrollView(
                                  // scrollDirection: Axis.horizontal,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        " ${model.description?.isEmpty ?? true ? "NA" : model.description} ",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.typography.bodyText2
                                            .override(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.public,
                                    color: Colors.grey,
                                    size: 14,
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: GestureDetector(
                                        onTap: () async {
                                          final url = model.website;
                                          if (url != null && url.isNotEmpty) {
                                            final uri = Uri.parse(
                                              url.startsWith('http')
                                                  ? url
                                                  : 'https://$url',
                                            );
                                            if (await canLaunchUrl(uri)) {
                                              await launchUrl(
                                                uri,
                                                mode:
                                                    LaunchMode
                                                        .externalApplication,
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Could not open the website",
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: Text(
                                          model.website?.isEmpty ?? true
                                              ? "NA"
                                              : model.website!,
                                          style: theme.typography.bodyText2
                                              .override(
                                                color: Colors.grey.shade400,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              flex: 1, // 50% of width
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.currency_rupee,
                                    color: Colors.grey,
                                    size: 14,
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        "${model.amount?.isEmpty ?? true ? "NA" : model.amount}",
                                        style: theme.typography.bodyText2
                                            .override(
                                              color: Colors.grey.shade400,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            ),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    color: Colors.green,
                                    size: 14,
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        model.contactEmail == null ||
                                                model.contactEmail.isEmpty
                                            ? "NA"
                                            : model.contactEmail,
                                        style: theme.typography.bodyText2
                                            .override(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11,
                                            ),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap:
                                    () => _makePhoneCall(
                                      model.mobileNumber,
                                      index,
                                    ),
                                child: Row(
                                  children: [
                                    loadingIndexes.contains(index)
                                        ? Center(
                                          child:
                                              LoadingAnimationWidget.hexagonDots(
                                                color: Colors.green,
                                                size: 16,
                                              ),
                                        )
                                        : Icon(
                                          Icons.phone_android,
                                          size: 15,
                                          color: Colors.green,
                                        ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          " ${model.mobileNumber ?? 'NA'}",
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.typography.bodyText2
                                              .override(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 11,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    size: 15,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        ('${model.donatedOn?.isEmpty ?? true ? "NA" : model.donatedOn}'),
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.typography.bodyText2
                                            .override(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Icon(
                                    MdiIcons.timerSand,
                                    size: 15,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        ('${model.donationType?.isEmpty ?? true ? "NA" : model.donationType}'),
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.typography.bodyText2
                                            .override(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _getStatusGradient(String status) {
    switch (status.toLowerCase()) {
      case 'donated':
        return [Colors.lightGreen.shade100, Colors.green.shade200];
      case 'in progress':
        return [Colors.orange.shade100, Colors.orange.shade200];
      case 'failed':
        return [Colors.red.shade100, Colors.red.shade300];
      default:
        return [Colors.grey.shade300, Colors.grey.shade500];
    }
  }

  Icon _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'donated':
        return Icon(
          Ionicons.checkmark_circle_outline,
          color: Colors.black,
          size: 16,
        );
      case 'in progress':
        return Icon(Ionicons.sync_outline, color: Colors.black, size: 16);
      case 'failed':
        return Icon(
          Ionicons.close_circle_outline,
          color: Colors.black,
          size: 16,
        );
      default:
        return Icon(
          Ionicons.alert_circle_outline,
          color: Colors.grey,
          size: 16,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = AppTheme.of(context);
    Future<bool> _onWillPop() async {
      return await ExitHelper.showExitConfirmationDialog(context);
    }

    return WillPopScope(
      onWillPop: _onWillPop,

      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            /* leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),*/
            leading: Builder(
              builder:
                  (context) => IconButton(
                    icon: Icon(Icons.menu, color: Colors.black87),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
            ),

            title: Text(
              'Donation History',
              style: AppTheme.of(context).title2.override(),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  hide ? Icons.clear : Icons.search,
                  color: Colors.black,
                ),
                onPressed: () => setState(() => hide = !hide),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(Icons.refresh, color: Colors.black),
                  onPressed: refreshData,
                ),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: false,
              indicatorColor: Colors.deepPurple,
              labelColor: Colors.deepPurple,
              labelPadding: EdgeInsets.symmetric(vertical: 0),
              labelStyle: theme.typography.bodyText2.override(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  icon: _buildIconWithCount(
                    icon: MdiIcons.formatListBulleted,
                    count: allLeadsCount,
                    color:
                        _tabController.index == 0
                            ? Colors.deepPurple
                            : Colors.grey,
                  ),
                  text: 'Donation list',
                ),
                Tab(
                  icon: _buildIconWithCount(
                    icon: Ionicons.warning_outline,
                    count: UpcomingleadsCount,
                    color:
                        _tabController.index == 1
                            ? Colors.deepPurple
                            : Colors.grey,
                  ),
                  text: 'Upcoming Donations',
                ),
              ],
            ),
          ),
          drawer: AppDrawer(currentPage: 'recent_donation'),
          floatingActionButton: FloatingActionButton(
            elevation: 18,
            focusColor: Colors.black,
            backgroundColor: Colors.black,
            child: Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => DonationScreen()));
              if (result == null) {
                refreshData();
              }
            },
          ),
          body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildList(
                mainList: unllist,
                searchList: allLeadssearch,
                emptyMessage: "No Donation available.",
                noMatchesMessage: "No matching results",
                isAllLeadsSearchList: true,
              ),
              _buildUpcomingList(
                mainList: filteredLeads1,
                searchList: filteredLeads1search,
                emptyMessage: "No upcoming donations found",
                noMatchesMessage: "No matching results",
              ),
              // _buildList(
              //   mainList: filteredLeads2,
              //   searchList: filteredLeads2search,
              //   emptyMessage: "No Incomplete leads available.",
              //   noMatchesMessage: "No matches found in Incomplete leads.",
              //   isAllLeadsSearchList: false,
              // ),
              // _buildList(
              //   mainList: filteredLeads3,
              //   searchList: filteredLeads3search,
              //   emptyMessage: "No Rejected leads available.",
              //   noMatchesMessage: "No matches found in Rejected leads.",
              //   isAllLeadsSearchList: false,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconWithCount({
    required IconData icon,
    required int? count,
    required Color color,
  }) {
    final theme = AppTheme.of(context);
    final displayCount = (count ?? 0) > 999 ? '999+' : '${count ?? 0}';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          shadowColor: Colors.deepPurple,
          child: Icon(icon, color: color),
        ),
        if (count != null && count >= 0)
          Positioned(
            right: -14,
            top: -12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.shade600,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                displayCount,
                style: theme.typography.bodyText2.override(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 9,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUpcomingList({
    required List<UpcomingDonationModel> mainList,
    required List<UpcomingDonationModel> searchList,
    required String emptyMessage,
    required String noMatchesMessage,
  }) {
    final theme = AppTheme.of(context);

    return Column(
      children: [
        /// Search Bar
        if (hide)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: TextField(
              controller: searchController,
              onChanged: _runFilter,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
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
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.black54),
                ),
                hintText: 'Search...',
                hintStyle: theme.typography.bodyText1.override(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
              style: theme.typography.bodyText1.override(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        /// Main Content Area
        Expanded(
          child:
              isLoading
                  ? Center(
                    child: Image.asset(
                      'assets/gif/buffer-loading.gif',
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                  )
                  : Builder(
                    builder: (context) {
                      if (mainList.isEmpty && apiCalled) {
                        return buildEmptyCard(
                          activeFilters.isNotEmpty
                              ? emptyFilterMessage
                              : emptyMessage,
                          context,
                        );
                      }

                      if (searchList.isEmpty) {
                        return buildEmptyCard(noMatchesMessage, context);
                      }

                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: searchList.length,
                        itemBuilder: (context, index) {
                          final isLast = index == searchList.length - 1;
                          final isExpanded = expandedCards[index] ?? false;

                          return Column(
                            children: [
                              _buildUpcomingDonations(
                                index: index,
                                model: searchList[index],
                                isExpanded: isExpanded,
                                onToggleExpand: (int idx, bool expand) {
                                  setState(() {
                                    expandedCards[idx] = expand;
                                  });
                                },
                              ),
                              if (isLast) const SizedBox(height: 30),
                            ],
                          );
                        },
                      );
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildUpcomingDonations({
    required int index,
    required UpcomingDonationModel model,
    required void Function(int index, bool expand) onToggleExpand,
    required bool isExpanded,
  }) {
    final donationData = model.toMap();
    final totalMonths = donationData["total_months"];
    final monthsRemaining = donationData["months_remaining"];
    final monthsCompleted = totalMonths - monthsRemaining;
    final donationSchedule = List<Map<String, dynamic>>.from(
      donationData["donation_schedule"],
    );
    final progress = monthsCompleted / totalMonths;
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final theme = AppTheme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(Icons.handshake, color: Colors.black),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          //  donationData["donor_name"],
                          donationData["charity_name"],

                          style: theme.typography.bodyText1.override(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          donationData["charity_email"],
                          style: theme.typography.bodyText2.override(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              /// Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Type: ${donationData["donation_type"]}",
                    style: theme.typography.bodyText2,
                  ),
                  Text(
                    "Amount: ${currencyFormat.format(donationData["donation_amount"])}",
                    style: theme.typography.bodyText2,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Completed: $monthsCompleted/$totalMonths months",
                    style: theme.typography.bodyText2.override(
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    "Remaining: $monthsRemaining",
                    style: theme.typography.bodyText2.override(
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade300,
                color: Colors.green,
                minHeight: 8,
              ),
              const SizedBox(height: 14),

              /// Dates
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Last Paid",
                        style: theme.typography.bodyText2.override(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        donationData["last_payment_date"],
                        style: theme.typography.bodyText2.override(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Next Due",
                        style: theme.typography.bodyText2.override(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        donationData["upcoming_due_date"],
                        style: theme.typography.bodyText2.override(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              /// Show more / less
              if (!isExpanded)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () => onToggleExpand(index, true),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Ionicons.chevron_down_outline,
                            size: 18,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Show more',
                            style: theme.typography.bodyText2.override(
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      "Upcoming Schedule",
                      style: theme.typography.bodyText2.override(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: List.generate(donationSchedule.length, (i) {
                        final item = donationSchedule[i];
                        final isLast = i == donationSchedule.length - 1;
                        final status = item['status'];
                        final icon =
                            status == 'debited'
                                ? Icons.check_circle
                                : Icons.cancel;
                        final iconColor =
                            status == 'debited' ? Colors.green : Colors.red;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: Colors.blue,
                                    size: 16,
                                  ),
                                  if (!isLast)
                                    Icon(
                                      Ionicons.arrow_down_outline,
                                      size: 12,
                                      color: Colors.blue.shade300,
                                    ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item['date'],
                                  style: theme.typography.bodyText2.override(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Icon(icon, size: 18, color: iconColor),
                            ],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => onToggleExpand(index, false),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Ionicons.chevron_up_outline,
                                size: 18,
                                color: Colors.deepPurple,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Show less',
                                style: theme.typography.bodyText2.override(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 4),
              Text(
                "Note: ${donationData["notes"]}",
                style: theme.typography.bodyText2.override(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList({
    required List<DonationHistoryModel> mainList,
    required List<DonationHistoryModel> searchList,
    required String emptyMessage,
    required String noMatchesMessage,
    required bool isAllLeadsSearchList,
  }) {
    final theme = AppTheme.of(context);

    return Column(
      children: [
        if (hide)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: TextField(
              controller: searchController,
              onChanged: _runFilter,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
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
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.black54),
                ),
                hintText: 'Search...',
                hintStyle: theme.typography.bodyText1.override(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
              style: theme.typography.bodyText1.override(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Expanded(
          child:
              isLoading
                  ? Center(
                    child: Image.asset(
                      'assets/gif/buffer-loading.gif',
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                  )
                  : Column(
                    children: [
                      if (isAllLeadsSearchList)
                        FilterBar(
                          activeFilters: activeFilters,
                          onFilterChanged: (updatedFilters) {
                            setState(() {
                              activeFilters = updatedFilters;
                              _applyFilters();
                            });
                          },
                          primaryColor: Colors.blueAccent, // Optional
                        ),
                      Expanded(
                        child:
                            (mainList.isEmpty && apiCalled)
                                ? buildEmptyCard(
                                  activeFilters.isNotEmpty
                                      ? emptyFilterMessage
                                      : emptyMessage,
                                  context,
                                )
                                : (searchList.isEmpty
                                    ? buildEmptyCard(noMatchesMessage, context)
                                    : ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      itemCount: searchList.length,
                                      itemBuilder: (context, index) {
                                        final isLast =
                                            index == searchList.length - 1;
                                        return Column(
                                          children: [
                                            _buildAnimatedCardallleads(
                                              index: index,
                                              model: searchList[index],
                                              isAllLeadsSearchList:
                                                  isAllLeadsSearchList,
                                            ),

                                            if (isLast) SizedBox(height: 30),
                                          ],
                                        );
                                      },
                                    )),
                      ),
                    ],
                  ),
        ),
      ],
    );
  }

  void refreshData() {
    setState(() {
      apiCalled = false;
      searchController.clear();
      activeFilters.clear();
    });
    get_dontion_history();
    get_upcoming_donation();
  }

  bool isApiCallInProgress = false;
  Set<String> processedOppIds = {};
  Future<void> get_upcoming_donation() async {
    setState(() {
      isLoading = true;
    });
    processedOppIds.clear();
    filteredLeads1 = [];
    filteredLeads1search = [];
    UpcomingleadsCount = 0;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        List<Map<String, dynamic>> jdata = [
          {
            "donor_id": "D001",
            "donor_name": "Ayannar",
            "charity_name": "Helping Hands Foundation",
            "donation_type": "Monthly",
            "donation_amount": 500,
            "total_months": 5,
            "months_remaining": 4,
            "last_payment_date": "2025-07-01",
            "upcoming_due_date": "2025-08-01",
            "donation_schedule": [
              {"date": "2025-07-01", "status": "debited"},
              {"date": "2025-08-01", "status": "pending"},
              {"date": "2025-09-01", "status": "pending"},
              {"date": "2025-10-01", "status": "pending"},
              {"date": "2025-11-01", "status": "pending"},
            ],
            "charity_contact": "9876543210",
            "charity_email": "support@helpinghands.org",
            "notes": "Auto-debit setup complete",
            "created_date": "18-06-2024 11:45",
          },
          {
            "donor_id": "D002",
            "donor_name": "Sundar",
            "charity_name": "Food for All Trust",
            "donation_type": "Monthly",
            "donation_amount": 1000,
            "total_months": 6,
            "months_remaining": 3,
            "last_payment_date": "2025-06-15",
            "upcoming_due_date": "2025-07-15",
            "donation_schedule": [
              {"date": "2025-05-15", "status": "debited"},
              {"date": "2025-06-15", "status": "debited"},
              {"date": "2025-07-15", "status": "debited"},
              {"date": "2025-08-15", "status": "pending"},
              {"date": "2025-09-15", "status": "pending"},
              {"date": "2025-10-15", "status": "pending"},
            ],
            "charity_contact": "9123456789",
            "charity_email": "donate@foodforall.org",
            "notes": "Monthly recurring debit setup active",
            "created_date": "12-06-2024 09:30",
          },
        ];

        jdata.sort((a, b) {
          try {
            DateTime dateA = DateFormat(
              "dd-MM-yyyy HH:mm",
            ).parse(a['created_date']);
            DateTime dateB = DateFormat(
              "dd-MM-yyyy HH:mm",
            ).parse(b['created_date']);
            return dateB.compareTo(dateA);
          } catch (e) {
            return 0;
          }
        });

        for (var element in jdata) {
          final donNo = element['donor_id'];
          if (processedOppIds.contains(donNo)) continue;

          processedOppIds.add(donNo);
          allLeadsCount++;
          UpcomingDonationModel models = UpcomingDonationModel.fromMap(element);

          UpcomingleadsCount++;
          filteredLeads1.add(models);
          filteredLeads1search.add(models);
        }

        if (mounted) {
          setState(() {
            apiCalled = true;
            isLoading = false;
          });
        }
      }
    } catch (_) {
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

  Future<void> get_dontion_history() async {
    setState(() {
      isLoading = true;
    });

    processedOppIds.clear();
    unllist = [];
    filteredLeads1 = [];
    allLeadssearch = [];
    filteredLeads1search = [];
    originalUnllist = [];

    allLeadsCount = 0;
    UpcomingleadsCount = 0;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // ✅ Static data
        List<Map<String, dynamic>> jdata = [
          {
            'charity_name': 'Hunger Relief Trust',
            'description': 'Feeding underprivileged children across India',
            'registration_no': 'NGO123456',
            'contact_email': 'contact@hungertrust.org',
            'website': 'https://hungertrust.org',
            'donation_type': 'Monthly',
            'amount': '10,000',
            'mobile_number': '9876543210',
            'transcation_status': 'success',
            'donated_on': '20-06-2024 14:30',
          },
          {
            'charity_name': 'Smile India Foundation',
            'description':
                'Provides education and healthcare for children in slums',
            'registration_no': 'NGO654321',
            'contact_email': 'info@smileindia.org',
            'website': 'https://smileindia.org',
            'donation_type': 'One Time',
            'amount': '5,000',
            'mobile_number': '9123456789',
            'transcation_status': 'incomplete',
            'donated_on': '18-06-2024 11:45',
          },
          {
            'charity_name': 'Child Care Network',
            'description':
                'Supports orphanages and shelters for abandoned kids',
            'registration_no': 'NGO112233',
            'contact_email': 'support@childcarenet.org',
            'website': 'https://childcarenet.org',
            'donation_type': 'Yearly',
            'amount': '20,000',
            'mobile_number': '9988776655',
            'transcation_status': 'failed',
            'donated_on': '15-06-2024 09:15',
          },
        ];

        // ✅ Sort by donated_on date
        jdata.sort((a, b) {
          try {
            DateTime dateA = DateFormat(
              "dd-MM-yyyy HH:mm",
            ).parse(a['donated_on']);
            DateTime dateB = DateFormat(
              "dd-MM-yyyy HH:mm",
            ).parse(b['donated_on']);
            return dateB.compareTo(dateA);
          } catch (e) {
            return 0;
          }
        });

        for (var element in jdata) {
          final regNo = element['registration_no'];
          if (processedOppIds.contains(regNo)) continue;

          processedOppIds.add(regNo);
          allLeadsCount++;

          // ✅ Create model from map
          DonationHistoryModel model = DonationHistoryModel.fromMap(element);

          unllist.add(model);
          originalUnllist.add(model);
          allLeadssearch.add(model);

          // if (model.transcation_status == "failed") {
          //   UpcomingleadsCount++;
          //   filteredLeads1.add(model);
          //   filteredLeads1search.add(model);
          // }
        }

        if (mounted) {
          setState(() {
            apiCalled = true;
            isLoading = false;
          });
        }
      }
    } catch (_) {
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

  String parseValue(dynamic value) {
    final val = value?.toString().trim();
    if (val == null ||
        val.isEmpty ||
        val.toLowerCase() == 'null' ||
        val.toLowerCase() == 'na') {
      return "NA";
    }
    return val;
  }

  Future<void> _makePhoneCall(String? phoneNumber, int index) async {
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      setState(() {
        loadingIndexes.add(index);
      });

      await Future.delayed(Duration(seconds: 2));

      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        print('Could not launch $phoneNumber');
      }
      setState(() {
        loadingIndexes.remove(index);
      });
    } else {
      print('Invalid phone number');
    }
  }

  Widget buildEmptyCard(String message, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.warning, color: AppTheme.of(context).grayIcon, size: 50),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ), // Adjust padding as needed
            child: Text(
              message,
              style: AppTheme.of(context).bodyText1,
              textAlign:
                  TextAlign.center, // Center-align text within the Text widget
            ),
          ),
        ],
      ),
    );
  }
}
