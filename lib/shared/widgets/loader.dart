import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class Loader extends StatefulWidget {
  final Color? color;
  const Loader({super.key, this.color});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final Cubic firstCurve = Curves.easeInQuart;
  final Cubic secondCurve = Curves.easeOutQuart;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final double size = 36;
    final double strokeWidth = size / 10;
    final Color color = widget.color ?? AppColors.primary;

    return Center(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, _) => Stack(
          children: <Widget>[
            Visibility(
              visible: _animationController.value <= 0.5,
              child: Transform.rotate(
                angle: LoadingAnimationHelper.evalDouble(
                  _animationController,
                  to: 3 * math.pi / 4,
                  end: 0.5,
                  curve: firstCurve,
                ),
                child: Arc.draw(
                    color: color,
                    size: size,
                    strokeWidth: strokeWidth,
                    startAngle: -math.pi / 2,
                    endAngle: LoadingAnimationHelper.evalDouble(
                      _animationController,
                      from: math.pi / (size * size),
                      to: -math.pi / 2,
                      end: 0.5,
                      curve: firstCurve,
                    )),
              ),
            ),
            Visibility(
              visible: _animationController.value >= 0.5,
              child: Transform.rotate(
                angle: LoadingAnimationHelper.evalDouble(
                  _animationController,
                  from: math.pi / 4,
                  to: math.pi,
                  begin: 0.5,
                  curve: secondCurve,
                ),
                child: Arc.draw(
                  color: color,
                  size: size,
                  strokeWidth: strokeWidth,
                  startAngle: -math.pi / 2,
                  endAngle: LoadingAnimationHelper.evalDouble(
                    _animationController,
                    from: math.pi / 2,
                    to: math.pi / (size * size),
                    begin: 0.5,
                    curve: secondCurve,
                  ),
                ),
              ),
            ),

            ///
            ///second one
            ///
            ///
            Visibility(
              visible: _animationController.value <= 0.5,
              child: Transform.rotate(
                angle: LoadingAnimationHelper.evalDouble(
                  _animationController,
                  from: -math.pi,
                  to: -math.pi / 4,
                  end: 0.5,
                  curve: firstCurve,
                ),
                child: Arc.draw(
                  color: color,
                  size: size,
                  strokeWidth: strokeWidth,
                  startAngle: -math.pi / 2,
                  endAngle: LoadingAnimationHelper.evalDouble(
                    _animationController,
                    from: math.pi / (size * size),
                    to: -math.pi / 2,
                    end: 0.5,
                    curve: firstCurve,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _animationController.value >= 0.5,
              child: Transform.rotate(
                angle: LoadingAnimationHelper.evalDouble(
                  _animationController,
                  from: -3 * math.pi / 4,
                  to: 0.0,
                  begin: 0.5,
                  end: 1.0,
                  curve: secondCurve,
                ),
                child: Arc.draw(
                  color: color,
                  size: size,
                  strokeWidth: strokeWidth,
                  startAngle: -math.pi / 2,
                  endAngle: LoadingAnimationHelper.evalDouble(
                    _animationController,
                    from: math.pi / 2,
                    to: math.pi / (size * size),
                    begin: 0.5,
                    curve: secondCurve,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class Arc extends CustomPainter {
  final Color _color;
  final double _strokeWidth;
  final double _sweepAngle;
  final double _startAngle;

  Arc._(
      this._color,
      this._strokeWidth,
      this._startAngle,
      this._sweepAngle,
      );

  static Widget draw({
    required Color color,
    required double size,
    required double strokeWidth,
    required double startAngle,
    required double endAngle,
  }) =>
      SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: Arc._(
            color,
            strokeWidth,
            startAngle,
            endAngle,
          ),
        ),
      );

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.height / 2,
    );

    const bool useCenter = false;
    final Paint paint = Paint()
      ..color = _color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeWidth;

    canvas.drawArc(rect, _startAngle, _sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LoadingAnimationHelper {
  static T eval<T>(
      AnimationController controller,
      Tween<T> tween, {
        Curve curve = Curves.linear,
      }) {
    return tween.transform(curve.transform(controller.value));
  }

  static double evalDouble(
      AnimationController controller, {
        double from = 0,
        double to = 1,
        double begin = 0,
        double end = 1,
        Curve curve = Curves.linear,
      }) {
    return eval<double>(
      controller,
      Tween<double>(begin: from, end: to),
      curve: Interval(begin, end, curve: curve),
    );
  }
}