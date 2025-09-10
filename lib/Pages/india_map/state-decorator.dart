// import 'package:flutter/material.dart';
//
// class StateDecorator extends StatefulWidget {
//   const StateDecorator({
//     // Key key,
//     required double xShift,
//     required double yShift,
//     required stateClipper,
//   }) : xShift = xShift,
//        yShift = yShift,
//        stateClipper = stateClipper;
//   // super(key: key);
//
//   final double xShift;
//   final double yShift;
//   final CustomClipper<Path> stateClipper;
//
//   @override
//   _StateDecoratorState createState() => _StateDecoratorState();
// }
//
// class _StateDecoratorState extends State<StateDecorator> {
//   var color = Colors.tealAccent.shade100;
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     final double _xScaling = size.width / 411;
//     final double _yScaling = size.height / 823;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           color = Colors.black54;
//         });
//       },
//       child: Transform.translate(
//         offset: Offset(_xScaling * widget.xShift, _yScaling * widget.yShift),
//         child: ClipPath(
//           child: Container(
//             height: size.height,
//             width: size.width,
//             color: color,
//           ),
//           clipper: widget.stateClipper,
//         ),
//       ),
//     );
//   }
// }
/*import 'package:flutter/material.dart';

class StateDecorator extends StatefulWidget {
  const StateDecorator({
    Key? key,
    required this.xShift,
    required this.yShift,
    required this.stateClipper,
  }) : super(key: key);

  final double xShift;
  final double yShift;
  final CustomClipper<Path> stateClipper;

  @override
  _StateDecoratorState createState() => _StateDecoratorState();
}

class _StateDecoratorState extends State<StateDecorator> {
  Color color = Colors.tealAccent.shade100;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    // Use only 60% of screen height
    double mapHeight = screenSize.height * 0.8;
    double mapWidth = screenSize.width;

    final double baseWidth = 411;
    final double baseHeight = 823;
    final double xScale = mapWidth / baseWidth;
    final double yScale = mapHeight / baseHeight;

    return Positioned(
      left: widget.xShift * xScale,
      top: widget.yShift * yScale,
      child: GestureDetector(
        onTap: () {
          setState(() {
            color = Colors.black54;
          });
        },
        child: ClipPath(
          clipper: widget.stateClipper,
          child: Container(
            height: mapHeight,
            width: mapWidth,
            color: color.withOpacity(0.85),
          ),
        ),
      ),
    );
  }
// }*/
// import 'package:flutter/material.dart';
//
// class StateDecorator extends StatelessWidget {
//   const StateDecorator({
//     Key? key,
//     /* required this.xShift,
//     required this.yShift,
//     required this.stateClipper,
//     required this.stateName,
//     required this.count,
//     required this.isSelected,
//     required this.onTap,*/
//     required this.xShift,
//     required this.yShift,
//     required this.stateClipper,
//     this.stateName = '',
//     this.count = 0,
//     this.isSelected = false,
//     required this.onTap,
//   }) : super(key: key);
//
//   final double xShift;
//   final double yShift;
//   final CustomClipper<Path> stateClipper;
//   final String stateName;
//   final int count;
//   final bool isSelected;
//   final Function(String, int) onTap;
//
//   Color getStateColor() {
//     if (isSelected) return Colors.lightBlue;
//     if (count > 200) return Colors.deepPurple;
//     if (count > 100) return Colors.green;
//     if (count > 50) return Colors.orange;
//     if (count > 0) return Colors.red;
//     return Colors.grey;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//
//     // Use 70% of screen height for map
//     double mapHeight = screenSize.height * 0.7;
//     double mapWidth = screenSize.width;
//
//     final double baseWidth = 411;
//     final double baseHeight = 823;
//     final double xScale = mapWidth / baseWidth;
//     final double yScale = mapHeight / baseHeight;
//
//     return Positioned(
//       left: xShift * xScale,
//       top: yShift * yScale,
//       child: GestureDetector(
//         onTap: () => onTap(stateName, count),
//         child: ClipPath(
//           clipper: stateClipper,
//           child: Container(
//             height: mapHeight,
//             width: mapWidth,
//             color: getStateColor().withOpacity(0.85),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class StateDecorator extends StatelessWidget {
//   const StateDecorator({
//     Key? key,
//     required this.xShift,
//     required this.yShift,
//     required this.stateClipper,
//     this.stateName = '',
//     this.count = 0,
//     this.isSelected = false,
//     this.onTap,
//   }) : super(key: key);
//
//   final double xShift;
//   final double yShift;
//   final CustomClipper<Path> stateClipper;
//   final String stateName;
//   final int count;
//   final bool isSelected;
//   final Function(String, int)? onTap;
//   //Color(0xFFFFCC00)
//   Color getStateColor() {
//     if (isSelected) return Color(0xFFFFCC00);
//     if (count > 5000) return Color(0xFF2979ff);
//     if (count > 1000) return Color(0xFF8DD8FF);
//     if (count > 500) return Color(0xFFC6E7FF);
//     if (count > 1 && count < 500) return Colors.greenAccent;
//     if (count < 1) return Colors.grey.shade100;
//     return Colors.grey.shade100;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//
//     double mapHeight = screenSize.height * 0.9;
//     double mapWidth = MediaQuery.of(context).size.width;
//
//     final double baseWidth = 411;
//     final double baseHeight = 823;
//     final double xScale = mapWidth / baseWidth;
//     final double yScale = mapHeight / baseHeight;
//
//     // new
//     double tooltipLeft = (xShift * xScale) + 15;
//     double tooltipTop = (yShift * yScale) - 40;
//     if (tooltipLeft + 200 > screenSize.width) {
//       tooltipLeft = (xShift * xScale) - 210;
//     }
//     if (tooltipTop < 0) {
//       tooltipTop = (yShift * yScale) + 40;
//     }
//     return Container(
//       child: Stack(
//         children: [
//           Positioned(
//             left: xShift * xScale,
//             top: yShift * yScale,
//             child: GestureDetector(
//               onTap: () {
//                 if (onTap != null) {
//                   onTap!(stateName, count);
//                 }
//               },
//               child: /* ClipPath(
//                   clipper: stateClipper,
//                   child: Container(
//                     height: mapHeight,
//                     width: mapWidth,
//                     color: getStateColor().withOpacity(0.85),
//                   ),
//                 ),*/ AnimatedScale(
//                 scale: isSelected ? 1.01 : 1.0,
//                 duration: Duration(milliseconds: 300),
//                 child: ClipPath(
//                   clipper: stateClipper,
//                   child: Container(
//                     height: mapHeight,
//                     width: mapWidth,
//                     color: getStateColor().withOpacity(0.85),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           if (isSelected)
//             // Positioned(
//             //   left: tooltipLeft,
//             //   top: tooltipTop,
//             //   child: TooltipBubbless(
//             //     text: '$stateName \u{20B9}$count donated amount',
//             //   ),
//             // ),
//             Positioned(
//               left: tooltipLeft,
//               top: tooltipTop,
//               child: EnhancedTooltip(
//                 text: '$stateName ₹$count donated amount',
//                 stateColor: getStateColor(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

class StateDecorator extends StatelessWidget {
  const StateDecorator({
    Key? key,
    required this.xShift,
    required this.yShift,
    required this.stateClipper,
    this.stateName = '',
    this.count = 0,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  final double xShift;
  final double yShift;
  final CustomClipper<Path> stateClipper;
  final String stateName;
  final int count;
  final bool isSelected;
  final Function(String, int)? onTap;

  Color getStateColor() {
    if (isSelected) return Color(0xFFFFCC00);
    if (count > 5000) return Color(0xFF2979ff);
    if (count > 1000) return Color(0xFF8DD8FF);
    if (count > 500) return Color(0xFFC6E7FF);
    if (count > 1 && count < 500) return Colors.greenAccent;
    if (count < 1) return Colors.grey.shade100;
    return Colors.grey.shade100;
  }

  // Calculate tooltip position around the selected state
  Map<String, dynamic> calculateTooltipPosition(
    Size screenSize,
    double mapWidth,
    double mapHeight,
    double xScale,
    double yScale,
  ) {
    double stateX = xShift * xScale;
    double stateY = yShift * yScale;

    double tooltipWidth = 200;
    double tooltipHeight = 40;
    double offset = 50; // Distance from state to tooltip

    double tooltipLeft;
    double tooltipTop;

    // Try to position tooltip in different directions around the state
    // First preference: Right side of the state
    tooltipLeft = stateX + offset;
    tooltipTop = stateY - tooltipHeight / 2;

    // Check if tooltip goes off screen on the right
    if (tooltipLeft + tooltipWidth > screenSize.width - 10) {
      // Try left side
      tooltipLeft = stateX - tooltipWidth - offset;

      // If still off screen on left, try top
      if (tooltipLeft < 10) {
        tooltipLeft = stateX - tooltipWidth / 2;
        tooltipTop = stateY - tooltipHeight - offset;

        // If off screen on top, try bottom
        if (tooltipTop < 10) {
          tooltipTop = stateY + offset;
        }
      }
    }

    // Final bounds check to ensure tooltip stays within screen
    tooltipLeft = tooltipLeft.clamp(10.0, screenSize.width - tooltipWidth - 10);
    tooltipTop = tooltipTop.clamp(10.0, screenSize.height - tooltipHeight - 10);

    // Determine which side the tooltip ended up on
    bool isRightSide = tooltipLeft > stateX;
    bool isLeftSide = tooltipLeft + tooltipWidth < stateX;
    bool isTopSide = tooltipTop + tooltipHeight < stateY;
    bool isBottomSide = tooltipTop > stateY;

    return {
      'left': tooltipLeft,
      'top': tooltipTop,
      'isLeftEdge': isLeftSide,
      'isRightEdge': isRightSide,
      'isTopEdge': isTopSide,
      'isBottomEdge': isBottomSide,
    };
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    double mapHeight = screenSize.height * 0.9;
    double mapWidth = MediaQuery.of(context).size.width;

    final double baseWidth = 411;
    final double baseHeight = 823;
    final double xScale = mapWidth / baseWidth;
    final double yScale = mapHeight / baseHeight;

    // Calculate tooltip position around the selected state
    Map<String, dynamic> tooltipPosition = calculateTooltipPosition(
      screenSize,
      mapWidth,
      mapHeight,
      xScale,
      yScale,
    );

    return Container(
      child: Stack(
        children: [
          Positioned(
            left: xShift * xScale,
            top: yShift * yScale,
            child: GestureDetector(
              onTap: () {
                if (onTap != null) {
                  onTap!(stateName, count);
                }
              },
              child: AnimatedScale(
                scale: isSelected ? 1.01 : 1.0,
                duration: Duration(milliseconds: 300),
                child: ClipPath(
                  clipper: stateClipper,
                  child: Container(
                    height: mapHeight,
                    width: mapWidth,
                    color: getStateColor().withOpacity(0.85),
                  ),
                ),
              ),
            ),
          ),
          if (isSelected)
            Positioned(
              left: tooltipPosition['left']!,
              top: tooltipPosition['top']!,
              child: EnhancedTooltip(
                text: '$stateName ₹$count donated amount',
                stateColor: getStateColor(),
                isLeftEdge: tooltipPosition['isLeftEdge']!,
                isRightEdge: tooltipPosition['isRightEdge']!,
                isTopEdge: tooltipPosition['isTopEdge']!,
                isBottomEdge: tooltipPosition['isBottomEdge']!,
              ),
            ),
        ],
      ),
    );
  }
}

class EnhancedTooltip extends StatelessWidget {
  final String text;
  final Color stateColor;
  final bool isLeftEdge;
  final bool isRightEdge;
  final bool isTopEdge;
  final bool isBottomEdge;

  const EnhancedTooltip({
    Key? key,
    required this.text,
    required this.stateColor,
    this.isLeftEdge = false,
    this.isRightEdge = false,
    this.isTopEdge = false,
    this.isBottomEdge = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 300),
      child: Material(
        color: Colors.transparent,
        elevation: 12,
        shadowColor: Colors.black.withOpacity(0.5),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add a small indicator dot matching the state color
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: stateColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
              SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.8),
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// class EnhancedTooltip extends StatelessWidget {
//   final String text;
//   final Color stateColor;
//
//   const EnhancedTooltip({
//     Key? key,
//     required this.text,
//     required this.stateColor,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       elevation: 12, // Increased elevation
//       shadowColor: Colors.black.withOpacity(0.5),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           // Always use dark background for maximum contrast
//           color: Colors.black87,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.white, width: 1.5),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.3),
//               blurRadius: 8,
//               offset: Offset(0, 4),
//             ),
//             BoxShadow(
//               color: Colors.white.withOpacity(0.1),
//               blurRadius: 4,
//               offset: Offset(0, -2),
//             ),
//           ],
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             shadows: [
//               Shadow(
//                 color: Colors.black.withOpacity(0.8),
//                 offset: Offset(1, 1),
//                 blurRadius: 2,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class TooltipBubbless extends StatelessWidget {
  final String text;

  const TooltipBubbless({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 8,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({Key? key, required this.color, required this.text})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 8),
          Text(text, style: theme.typography.bodyText2.override()),
        ],
      ),
    );
  }
}
