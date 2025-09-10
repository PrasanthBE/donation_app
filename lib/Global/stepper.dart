import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:flutter/material.dart';

/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Arrow Stepper')),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ArrowStepper(
              steps: [
                StepData(
                  title: 'STEP 1',
                  subtitle: 'Choose Donation Amount',
                  isActive: true,
                  color: Colors.lightBlue.shade300,
                ),
                StepData(
                  title: 'STEP 2',
                  subtitle: 'Select Payment Method',
                  isActive: false,
                  color: Colors.lightBlue.shade100,
                ),
                StepData(
                  title: 'STEP 3',
                  subtitle: 'Donation Submitted',
                  isActive: false,
                  color: Colors.lightBlue.shade50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/

class StepData {
  final String title;
  final String subtitle;
  final bool isActive;
  final Color color;

  StepData({
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.color,
  });

  StepData copyWith({bool? isActive}) {
    return StepData(
      title: this.title,
      subtitle: this.subtitle,
      isActive: isActive ?? this.isActive,
      color: this.color,
    );
  }
}

class ArrowStepper extends StatelessWidget {
  // NEW
  final List<StepData> steps;
  final int currentIndex;
  final double height;
  final ValueChanged<int>? onStepTapped;

  const ArrowStepper({
    Key? key,
    required this.steps,
    required this.currentIndex,
    this.height = 60,
    this.onStepTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalWidth = MediaQuery.of(context).size.width;
    final arrowWidth = height * 0.25;
    final stepWidth =
        (totalWidth + arrowWidth * (steps.length - 1)) / steps.length;

    return Container(
      height: height,
      child: Stack(
        children: List.generate(steps.length, (index) {
          final step = steps[index];
          final bool isActive = index == currentIndex;
          final Color stepColor = isActive ? Colors.blueAccent : step.color;
          final bool shouldEnableTap = currentIndex == 1 && index == 0;

          return Positioned(
            left: index * (stepWidth - arrowWidth),
            width: stepWidth,
            child: GestureDetector(
              // onTap: () => onStepTapped?.call(index),
              onTap: shouldEnableTap ? () => onStepTapped?.call(index) : null,

              child: ArrowStep(
                stepData: StepData(
                  title: step.title,
                  subtitle: step.subtitle,
                  isActive: isActive,
                  color: stepColor,
                ),
                isFirst: index == 0,
                isLast: index == steps.length - 1,
                height: height,
                isActive: isActive,
              ),
            ),
          );
        }),
      ),
    );
  }
}

// class ArrowStepper extends StatefulWidget {
//   final List<StepData> steps;
//   final double height;
//
//   const ArrowStepper({Key? key, required this.steps, this.height = 60})
//     : super(key: key);
//
//   @override
//   _ArrowStepperState createState() => _ArrowStepperState();
// }
//
// class _ArrowStepperState extends State<ArrowStepper> {
//   int activeIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     final totalWidth = MediaQuery.of(context).size.width;
//     final arrowWidth = widget.height * 0.25;
//     final stepWidth =
//         (totalWidth + arrowWidth * (widget.steps.length - 1)) /
//         widget.steps.length;
//
//     return Container(
//       height: widget.height,
//       child: Stack(
//         children: List.generate(widget.steps.length, (index) {
//           final step = widget.steps[index];
//           final bool isActive = index == activeIndex;
//           final Color stepColor = isActive ? Colors.blueAccent : step.color;
//
//           return Positioned(
//             left: index * (stepWidth - arrowWidth),
//             width: stepWidth,
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   activeIndex = index;
//                 });
//               },
//               child: ArrowStep(
//                 stepData: StepData(
//                   title: step.title,
//                   subtitle: step.subtitle,
//                   isActive: isActive,
//                   color: stepColor,
//                 ),
//                 isFirst: index == 0,
//                 isLast: index == widget.steps.length - 1,
//                 height: widget.height,
//                 isActive: isActive,
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

class ArrowStep extends StatelessWidget {
  final StepData stepData;
  final bool isFirst;
  final bool isLast;
  final double height;
  final bool isActive; // ✅ NEW

  const ArrowStep({
    Key? key,
    required this.stepData,
    required this.isFirst,
    required this.isLast,
    required this.height,
    required this.isActive, // ✅ NEW
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = isActive ? Colors.white : Colors.black;
    final theme = AppTheme.of(context);

    return CustomPaint(
      painter: ArrowStepPainter(
        isActive: stepData.isActive,
        isFirst: isFirst,
        isLast: isLast,
        color: stepData.color,
      ),
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: isFirst ? 16 : (isLast ? 16 : 20),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stepData.title,
                  style: theme.typography.bodyText2.override(color: textColor),
                ),
                SizedBox(height: 2),
                Text(
                  stepData.subtitle,
                  textAlign: TextAlign.center,
                  style: theme.typography.bodyText3.override(color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ArrowStepPainter extends CustomPainter {
  final bool isActive;
  final bool isFirst;
  final bool isLast;
  final Color color;

  ArrowStepPainter({
    required this.isActive,
    required this.isFirst,
    required this.isLast,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = Path();
    final arrowWidth = size.height * 0.25;

    if (isFirst) {
      path.moveTo(0, 0);
      path.lineTo(size.width - arrowWidth, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(size.width - arrowWidth, size.height);
      path.lineTo(0, size.height);
      path.close();
    } else if (isLast) {
      path.moveTo(0, 0);
      path.lineTo(arrowWidth, size.height / 2);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
      path.close();
    } else {
      path.moveTo(0, 0);
      path.lineTo(arrowWidth, size.height / 2);
      path.lineTo(0, size.height);
      path.lineTo(size.width - arrowWidth, size.height);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(size.width - arrowWidth, 0);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Alternative implementation with more customization options
class CustomArrowStepper extends StatelessWidget {
  final List<StepData> steps;
  final double height;
  final Color activeColor;
  final Color inactiveColor;
  final TextStyle? activeTextStyle;
  final TextStyle? inactiveTextStyle;

  const CustomArrowStepper({
    Key? key,
    required this.steps,
    this.height = 60,
    this.activeColor = const Color(0xFF4A90A4),
    this.inactiveColor = const Color(0xFF9E9E9E),
    this.activeTextStyle,
    this.inactiveTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Row(
        children: List.generate(steps.length, (index) {
          return Expanded(
            child: CustomArrowStep(
              stepData: steps[index],
              isFirst: index == 0,
              isLast: index == steps.length - 1,
              height: height,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              textStyle:
                  steps[index].isActive
                      ? (activeTextStyle ?? TextStyle(color: Colors.white))
                      : (inactiveTextStyle ?? TextStyle(color: Colors.white)),
            ),
          );
        }),
      ),
    );
  }
}

class CustomArrowStep extends StatelessWidget {
  final StepData stepData;
  final bool isFirst;
  final bool isLast;
  final double height;
  final Color activeColor;
  final Color inactiveColor;
  final TextStyle textStyle;

  const CustomArrowStep({
    Key? key,
    required this.stepData,
    required this.isFirst,
    required this.isLast,
    required this.height,
    required this.activeColor,
    required this.inactiveColor,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CustomArrowStepPainter(
        isActive: stepData.isActive,
        isFirst: isFirst,
        isLast: isLast,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
      ),
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: isFirst ? 16 : 24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                stepData.title,
                style: textStyle.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                stepData.subtitle,
                textAlign: TextAlign.center,
                style: textStyle.copyWith(fontSize: 10, height: 1.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomArrowStepPainter extends CustomPainter {
  final bool isActive;
  final bool isFirst;
  final bool isLast;
  final Color activeColor;
  final Color inactiveColor;

  CustomArrowStepPainter({
    required this.isActive,
    required this.isFirst,
    required this.isLast,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = isActive ? activeColor : inactiveColor
          ..style = PaintingStyle.fill;

    final path = Path();
    final arrowWidth = size.height * 0.3;

    if (isFirst) {
      // First step - rounded start, arrow end
      path.moveTo(8, 0);
      path.lineTo(size.width - arrowWidth, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(size.width - arrowWidth, size.height);
      path.lineTo(8, size.height);
      path.arcToPoint(Offset(0, size.height - 8), radius: Radius.circular(8));
      path.lineTo(0, 8);
      path.arcToPoint(Offset(8, 0), radius: Radius.circular(8));
      path.close();
    } else if (isLast) {
      // Last step - arrow start, rounded end
      path.moveTo(arrowWidth, 0);
      path.lineTo(size.width - 8, 0);
      path.arcToPoint(Offset(size.width, 8), radius: Radius.circular(8));
      path.lineTo(size.width, size.height - 8);
      path.arcToPoint(
        Offset(size.width - 8, size.height),
        radius: Radius.circular(8),
      );
      path.lineTo(arrowWidth, size.height);
      path.lineTo(0, size.height / 2);
      path.close();
    } else {
      // Middle step - arrow start and end
      path.moveTo(arrowWidth, 0);
      path.lineTo(size.width - arrowWidth, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(size.width - arrowWidth, size.height);
      path.lineTo(arrowWidth, size.height);
      path.lineTo(0, size.height / 2);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
