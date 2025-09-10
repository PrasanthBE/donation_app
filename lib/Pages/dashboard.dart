import 'dart:async';

import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:akshaya_pathara/Global/donut.dart';
import 'package:akshaya_pathara/Global/drawer.dart';
import 'package:akshaya_pathara/Global/exit_helper.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DonationDashboard extends StatefulWidget {
  @override
  _DonationDashboardState createState() => _DonationDashboardState();
}

class _DonationDashboardState extends State<DonationDashboard> {
  int? _expandedIndex;
  Timer? _collapseTimer;
  final List<Map<String, dynamic>> topCards = [
    {
      'title': 'Total Donation',
      'amount': '1.555 C',
      'subtitle': 'Transactions',
      'count': '125',
      'color': Colors.green,
    },
    {
      'title': 'Last Payment',
      'amount': 'Akshaya Patra',
      'subtitle': 'Mid Day Meal',
      'count': '10,000',
      'color': Colors.blue,
    },
    // {
    //   'title': 'New Donors',
    //   'amount': '4,123800000',
    //   'subtitle': 'New Donors',
    //   'count': '1,422',
    //   'color': Colors.lightBlue,
    // },
  ];
  final List<Map<String, dynamic>> monthlyData = [
    {'month': 'Apr', 'amount': 850000}, // ₹8.5L
    {'month': 'May', 'amount': 1200000}, // ₹12L
    {'month': 'Jun', 'amount': 950000}, // ₹9.5L
    {'month': 'Jul', 'amount': 2400000}, // ₹18L
    {'month': 'Aug', 'amount': 1600000}, // ₹16L
    {'month': 'Sep', 'amount': 700000}, // ₹7L
    {'month': 'Oct', 'amount': 1100000}, // ₹11L
    {'month': 'Nov', 'amount': 950000}, // ₹9.5L
    {'month': 'Dec', 'amount': 1450000}, // ₹14.5L
    {'month': 'Jan', 'amount': 1700000}, // ₹17L
    {'month': 'Feb', 'amount': 750000}, // ₹7.5L
    {'month': 'Mar', 'amount': 900000}, // ₹9L
  ];

  /*final List<Map<String, dynamic>> monthlyData = [
    {'month': 'Jan', 'amount': 800000},
    {'month': 'Feb', 'amount': 750000},
    {'month': 'Mar', 'amount': 600000},
    {'month': 'Apr', 'amount': 850000},
    {'month': 'May', 'amount': 1372000},
    {'month': 'Jun', 'amount': 950000},
    {'month': 'Jul', 'amount': 900000},
    {'month': 'Aug', 'amount': 1000000},
    {'month': 'Sep', 'amount': 950000},
    {'month': 'Oct', 'amount': 1100000},
    {'month': 'Nov', 'amount': 800000},
  ];*/

  final List<Map<String, dynamic>> donationTypes = [
    {
      'type': 'Mid Day Meal',
      'percentage': 23,
      'color': Colors.blue.shade900, // Dark blue
    },
    {
      'type': 'Child Education',
      'percentage': 12,
      'color': Colors.blue.shade700, // Medium dark blue
    },
    {
      'type': 'Homeless Mothers',
      'percentage': 15,
      'color': Colors.blue.shade500, // Base blue
    },
    {
      'type': 'School Infrastructure',
      'percentage': 25,
      'color': Colors.blue.shade300, // Light blue
    },
    {
      'type': 'Women Empowerment',
      'percentage': 25,
      'color': Colors.blue.shade100, // Very light blue
    },
  ];

  int? _touchedIndex;

  void _handleTap(int index) {
    // Cancel previous timer if any
    _collapseTimer?.cancel();

    setState(() {
      _expandedIndex = index;
    });

    // Start new timer for collapse after 3 seconds
    _collapseTimer = Timer(Duration(seconds: 3), () {
      setState(() {
        _expandedIndex = null;
      });
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
        backgroundColor: Color(0xFFF5F7FA),
        appBar: AppBar(
          title: Text('Donation Overview', style: theme.title3),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          leading: Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(Icons.menu, color: Colors.black87),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
          ),
        ),
        drawer: AppDrawer(currentPage: 'dashboard'),
        body: SingleChildScrollView(
          // padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.41,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 2, child: _buildTopCards()),
                    SizedBox(width: 16),
                    Expanded(flex: 3, child: _buildDonationTypeChart()),
                  ],
                ),
              ),
              SizedBox(height: 24),
              _buildRaisedByMonthChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopCards() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(topCards.length, (index) {
        return GestureDetector(
          onTap: () => _handleTap(index),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(vertical: 6),
            child: _buildTopCard(
              topCards[index],
              isExpanded: _expandedIndex == index,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTopCard(Map<String, dynamic> card, {bool isExpanded = false}) {
    final theme = AppTheme.of(context);
    final amount = card['amount'];
    final isNumeric = num.tryParse(amount.toString()) != null;
    final formattedAmount = isNumeric ? '₹${amount}' : amount;

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              card['title'],
              style: theme.typography.bodyText1.override(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6),
            Text(
              formattedAmount,
              style: theme.typography.bodyText3.override(color: card['color']),

              overflow:
                  isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              maxLines: isExpanded ? 3 : 1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              card['subtitle'],
              style: theme.typography.bodyText3.override(fontSize: 10),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey[600]),
            SizedBox(height: 2),

            Text(
              card['count'],
              style: theme.typography.bodyText1.override(fontSize: 12),
              overflow:
                  isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              maxLines: isExpanded ? 3 : 1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _collapseTimer?.cancel();
    super.dispose();
  }

  Widget _buildDonationTypeChart() {
    final theme = AppTheme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      child: Container(
        width: 280,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category Wise Donation',
                style: theme.typography.bodyText2.override(),
              ),
              AnimatedDonutChart(donationTypes: donationTypes, size: 190),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRaisedByMonthChart() {
    final theme = AppTheme.of(context);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /*Text(
                '',
                style: theme.typography.bodyText1.override(fontSize: 13),
              ),*/
              Text(
                '2024 to 2025',
                style: theme.typography.bodyText1.override(fontSize: 13),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            height: 280,
            padding: const EdgeInsets.all(12),
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 2500000,
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        final allowed = [
                          0,
                          500000,
                          1000000,
                          1500000,
                          2000000,
                          2500000,
                        ];

                        if (!allowed.contains(value)) return const SizedBox();

                        return Text(
                          '₹${(value / 100000).toStringAsFixed(0)}L',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < monthlyData.length) {
                          return Text(
                            monthlyData[value.toInt()]['month'],
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots:
                        monthlyData.asMap().entries.map((entry) {
                          return FlSpot(
                            entry.key.toDouble(),
                            entry.value['amount'].toDouble(),
                          );
                        }).toList(),
                    isCurved: true,
                    color: Colors.blue[600],
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.blue[600]!,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue[600]!.withOpacity(0.3),
                          Colors.blue[400]!.withOpacity(0.1),
                          Colors.blue[200]!.withOpacity(0.05),
                        ],
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    //tooltipBgColor: Colors.black87,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '₹${(spot.y / 100000).toStringAsFixed(1)}L',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),

          /*
          Container(
            height: 280,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '₹${(value / 1000000).toStringAsFixed(1)}L',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < monthlyData.length) {
                          return Text(
                            monthlyData[value.toInt()]['month'],
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots:
                        monthlyData.asMap().entries.map((entry) {
                          return FlSpot(
                            entry.key.toDouble(),
                            entry.value['amount'].toDouble(),
                          );
                        }).toList(),
                    isCurved: true,
                    color: Colors.blue[600],
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.blue[600]!,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue[600]!.withOpacity(0.3),
                          Colors.blue[400]!.withOpacity(0.1),
                          Colors.blue[200]!.withOpacity(0.05),
                        ],
                      ),
                    ),
                  ),
                ],

                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBorder: BorderSide.none,
                    //  tooltipBgColor: Colors.black87,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '₹${(spot.y / 1000).toStringAsFixed(0)}L',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
*/
        ],
      ),
    );
  }
}
