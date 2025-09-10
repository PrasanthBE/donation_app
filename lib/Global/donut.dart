import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedDonutChart extends StatefulWidget {
  final List<Map<String, dynamic>> donationTypes;
  final double size;

  const AnimatedDonutChart({
    Key? key,
    required this.donationTypes,
    this.size = 220,
  }) : super(key: key);

  @override
  _AnimatedDonutChartState createState() => _AnimatedDonutChartState();
}

class _AnimatedDonutChartState extends State<AnimatedDonutChart>
    with TickerProviderStateMixin {
  late AnimationController _segmentController;
  late AnimationController _tapController;

  late Animation<double> _segmentAnimation;
  late Animation<double> _tapAnimation;

  int _currentSegment = -1;
  int _selectedSegment = -1;
  bool _isSegmentAnimating = false;

  @override
  void initState() {
    super.initState();
    _segmentController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _segmentAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _segmentController, curve: Curves.easeOut),
    );

    _tapController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _tapAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      // Increased enlargement
      CurvedAnimation(parent: _tapController, curve: Curves.elasticOut),
    );

    _startSegmentAnimations();
  }

  void _startSegmentAnimations() async {
    setState(() {
      _isSegmentAnimating = true;
    });

    for (int i = 0; i < widget.donationTypes.length; i++) {
      setState(() {
        _currentSegment = i;
      });
      _segmentController.reset();
      await _segmentController.forward();
    }

    setState(() {
      _isSegmentAnimating = false;
      _currentSegment = -1;
    });
  }

  void _onTapSegment(int segmentIndex) {
    if (_isSegmentAnimating) return;

    setState(() {
      if (_selectedSegment == segmentIndex) {
        _selectedSegment = -1;
        _tapController.reverse();
      } else {
        _selectedSegment = segmentIndex;
        _tapController.forward();
      }
    });
  }

  void _onTapCenter() {
    if (_selectedSegment != -1) {
      setState(() {
        _selectedSegment = -1;
      });
      _tapController.reverse();
    }
  }

  int _getSegmentFromAngle(double angle) {
    // Normalize angle to 0-2π range
    angle = (angle + 2 * math.pi) % (2 * math.pi);

    // Convert chart angle to standard angle (chart starts at top, goes clockwise)
    double chartAngle = (angle + math.pi / 2) % (2 * math.pi);

    double accumulatedPercentage = 0;
    for (int i = 0; i < widget.donationTypes.length; i++) {
      double segmentPercentage = widget.donationTypes[i]['percentage'] / 100.0;
      double segmentStartAngle = accumulatedPercentage * 2 * math.pi;
      double segmentEndAngle =
          (accumulatedPercentage + segmentPercentage) * 2 * math.pi;

      if (chartAngle >= segmentStartAngle && chartAngle < segmentEndAngle) {
        return i;
      }

      accumulatedPercentage += segmentPercentage;
    }

    return -1; // No segment found
  }

  @override
  void dispose() {
    _segmentController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: Listenable.merge([_segmentController, _tapController]),
            builder: (context, child) {
              return GestureDetector(
                onTapUp: (details) {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  Offset localPosition = renderBox.globalToLocal(
                    details.globalPosition,
                  );

                  final center = Offset(widget.size / 2, widget.size / 2);
                  final dx = localPosition.dx - center.dx;
                  final dy = localPosition.dy - center.dy;
                  final distance = math.sqrt(dx * dx + dy * dy);

                  final baseStroke = widget.size * 0.15;
                  final radius = widget.size * 0.4;
                  final innerRadius = radius - baseStroke / 2;
                  final outerRadius = radius + baseStroke / 2;

                  if (distance < innerRadius) {
                    // Tap in center
                    _onTapCenter();
                  } else if (distance >= innerRadius &&
                      distance <= outerRadius) {
                    // Tap in donut ring - calculate which segment
                    final angle = math.atan2(dy, dx);
                    int segmentIndex = _getSegmentFromAngle(angle);

                    if (segmentIndex != -1) {
                      _onTapSegment(segmentIndex);
                    }
                  }
                },
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: DonutChartPainter(
                    donationTypes: widget.donationTypes,
                    segmentProgress: _segmentAnimation.value,
                    tapScale: _tapAnimation.value,
                    isSegmentAnimating: _isSegmentAnimating,
                    currentSegment: _currentSegment,
                    selectedSegment: _selectedSegment,
                  ),
                ),
              );
            },
          ),
        ),
        //  SizedBox(height: 20),
        // Legend when no segment is selected
        // if (_selectedSegment == -1 && !_isSegmentAnimating)
        Container(
          // padding: EdgeInsets.all(16),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(12),
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.grey.withOpacity(0.2),
          //       blurRadius: 8,
          //       offset: Offset(0, 2),
          //     ),
          //   ],
          // ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  widget.donationTypes.map((data) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: data['color'],
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${data['type']}: ${data['percentage']}%',
                            style: theme.typography.bodyText3.override(),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> donationTypes;
  final double segmentProgress;
  final double tapScale;
  final bool isSegmentAnimating;
  final int currentSegment;
  final int selectedSegment;

  DonutChartPainter({
    required this.donationTypes,
    required this.segmentProgress,
    required this.tapScale,
    required this.isSegmentAnimating,
    required this.currentSegment,
    required this.selectedSegment,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    final baseStroke = size.width * 0.15;

    double totalPercentage = 0;

    for (int i = 0; i < donationTypes.length; i++) {
      final data = donationTypes[i];
      final percentage = data['percentage'] / 100.0;
      final color = data['color'] as Color;

      final startAngle = totalPercentage * 2 * math.pi - math.pi / 2;
      final sweepAngle = percentage * 2 * math.pi;

      double currentStroke = baseStroke;
      double currentRadius = radius;

      // Apply scaling for selected segment
      if (selectedSegment == i) {
        currentStroke *= tapScale;
        currentRadius *= 1.05; // Slight radius increase for better effect
      }

      final paint =
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = currentStroke
            ..strokeCap = StrokeCap.round;

      final rect = Rect.fromCircle(center: center, radius: currentRadius);

      // Draw segments based on animation state
      if (i < currentSegment || (!isSegmentAnimating && currentSegment == -1)) {
        // Completed segment or all segments when not animating
        canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      } else if (i == currentSegment && isSegmentAnimating) {
        // Currently animating segment
        final partialSweep = sweepAngle * segmentProgress;
        canvas.drawArc(rect, startAngle, partialSweep, false, paint);
      }

      // Draw tooltip for selected segment
      if (selectedSegment == i && !isSegmentAnimating) {
        _drawTooltip(
          canvas,
          center,
          currentRadius,
          startAngle,
          sweepAngle,
          data,
          size,
        );
      }

      totalPercentage += percentage;
    }
  }

  void _drawTooltip(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngle,
    double sweepAngle,
    Map<String, dynamic> data,
    Size size,
  ) {
    final midAngle = startAngle + sweepAngle / 2;
    final tooltipRadius =
        radius + size.width * 0.12; // Position outside the donut

    final tooltipCenter = Offset(
      center.dx + tooltipRadius * math.cos(midAngle),
      center.dy + tooltipRadius * math.sin(midAngle),
    );

    // Create text painter for tooltip content
    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${data['type']}\n',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size.width * 0.045,
            ),
          ),
          TextSpan(
            text: '${data['percentage']}%',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: size.width * 0.04,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    // Calculate tooltip background size
    final tooltipWidth = textPainter.width + 22;
    final tooltipHeight = textPainter.height + 16;

    // Position tooltip to avoid going outside canvas
    double tooltipX = tooltipCenter.dx - tooltipWidth / 2;
    double tooltipY = tooltipCenter.dy - tooltipHeight / 2;

    // Boundary checks
    if (tooltipX < 0) tooltipX = 5;
    if (tooltipX + tooltipWidth > size.width)
      tooltipX = size.width - tooltipWidth - 5;
    if (tooltipY < 0) tooltipY = 5;
    if (tooltipY + tooltipHeight > size.height)
      tooltipY = size.height - tooltipHeight - 5;

    final tooltipRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(tooltipX, tooltipY, tooltipWidth, tooltipHeight),
      Radius.circular(12),
    );

    // Draw tooltip background with segment color
    final tooltipPaint =
        Paint()
          ..color = (data['color'] as Color).withOpacity(0.9)
          ..style = PaintingStyle.fill;

    canvas.drawRRect(tooltipRect, tooltipPaint);

    // Draw tooltip border
    final borderPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    canvas.drawRRect(tooltipRect, borderPaint);

    // Draw tooltip shadow
    final shadowPaint =
        Paint()
          ..color = Colors.black.withOpacity(0.2)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(tooltipX + 2, tooltipY + 2, tooltipWidth, tooltipHeight),
        Radius.circular(12),
      ),
      shadowPaint,
    );

    // Draw connecting line from segment to tooltip
    final linePaint =
        Paint()
          ..color = (data['color'] as Color).withOpacity(0.6)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final segmentEdge = Offset(
      center.dx + radius * math.cos(midAngle),
      center.dy + radius * math.sin(midAngle),
    );

    final tooltipEdge = Offset(
      tooltipX + tooltipWidth / 2,
      tooltipY + tooltipHeight / 2,
    );
    canvas.drawLine(segmentEdge, tooltipEdge, linePaint);

    // Draw text on tooltip
    textPainter.paint(canvas, Offset(tooltipX + 10, tooltipY + 8));

    // Draw small indicator dot at connection point
    final dotPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    canvas.drawCircle(segmentEdge, 3, dotPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Example usage widget
class DonutChartDemo extends StatelessWidget {
  final List<Map<String, dynamic>> donationTypes = [
    {'type': 'Children', 'percentage': 33, 'color': Colors.blue[800]},
    {'type': 'Old Age', 'percentage': 12, 'color': Colors.lightBlue[300]},
    {'type': 'Orphanage', 'percentage': 55, 'color': Colors.blue[100]},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Fixed Animated Donut Chart'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Donation Distribution',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 30),
                AnimatedDonutChart(donationTypes: donationTypes, size: 280),
                SizedBox(height: 20),
                Text(
                  'Tap segments to highlight • Tap center to reset',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
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
