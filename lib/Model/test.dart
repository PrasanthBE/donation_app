import 'package:flutter/material.dart';
import 'dart:math' as math;

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int selectedBottomIndex = 2; // Statistics tab selected
  String selectedPeriod = 'Last 30 days';

  final List<String> periods = [
    'Last 7 days',
    'Last 30 days',
    'Last 90 days',
    'Last 6 months',
    'Last year',
  ];

  final List<ChartData> chartData = [
    ChartData('Restaurants', 25, const Color(0xFFFF8A65), 1593.58),
    ChartData('Entertainment', 15, const Color(0xFF42A5F5), 956.15),
    ChartData('Groceries', 20, const Color(0xFF66BB6A), 1274.20),
    ChartData('Transport', 18, const Color(0xFFAB47BC), 1146.72),
    ChartData('Others', 22, const Color(0xFFFFA726), 1402.36),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF8E8E93),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Statistic',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Period Selector
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Period:',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF8E8E93),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedPeriod,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1C1C1E),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => _showPeriodSelector(),
                      child: const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF8E8E93),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Chart
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 250,
                        height: 250,
                        child: CustomPaint(
                          painter: DonutChartPainter(chartData),
                        ),
                      ),
                      // Center circle
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF3B30),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF3B30).withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.trending_up,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Category Info
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF8A65).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.restaurant,
                        color: Color(0xFFFF8A65),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Restaurants',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1C1C1E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '25%',
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF8E8E93),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      '\$ 1593.58',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(Icons.home_outlined, 0),
            _buildBottomNavItem(Icons.add_circle_outline, 1),
            _buildBottomNavItem(Icons.bar_chart_outlined, 2),
            _buildBottomNavItem(Icons.settings_outlined, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, int index) {
    final isSelected = selectedBottomIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBottomIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF3B30) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : const Color(0xFF8E8E93),
          size: 24,
        ),
      ),
    );
  }

  void _showPeriodSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Period',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
                const SizedBox(height: 20),
                ...periods.map(
                  (period) => ListTile(
                    title: Text(
                      period,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            period == selectedPeriod
                                ? FontWeight.w600
                                : FontWeight.w400,
                        color:
                            period == selectedPeriod
                                ? const Color(0xFFFF3B30)
                                : const Color(0xFF1C1C1E),
                      ),
                    ),
                    trailing:
                        period == selectedPeriod
                            ? const Icon(Icons.check, color: Color(0xFFFF3B30))
                            : null,
                    onTap: () {
                      setState(() {
                        selectedPeriod = period;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class ChartData {
  final String category;
  final double percentage;
  final Color color;
  final double amount;

  ChartData(this.category, this.percentage, this.color, this.amount);
}

class DonutChartPainter extends CustomPainter {
  final List<ChartData> data;

  DonutChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final innerRadius = radius * 0.6;

    double startAngle = -math.pi / 2;

    for (final item in data) {
      final sweepAngle = (item.percentage / 100) * 2 * math.pi;

      final paint =
          Paint()
            ..color = item.color
            ..style = PaintingStyle.fill;

      // Draw outer arc
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw inner circle to create donut effect
      final innerPaint =
          Paint()
            ..color = const Color(0xFFF8F9FA)
            ..style = PaintingStyle.fill;

      canvas.drawCircle(center, innerRadius, innerPaint);

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
