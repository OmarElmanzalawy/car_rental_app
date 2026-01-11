import 'dart:async';

import 'package:flutter/widgets.dart';

class EarningsAnimatedIn extends StatefulWidget {
  const EarningsAnimatedIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration delay;

  @override
  State<EarningsAnimatedIn> createState() => _EarningsAnimatedInState();
}

class _EarningsAnimatedInState extends State<EarningsAnimatedIn> {
  bool _visible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay, () {
      if (mounted) {
        setState(() => _visible = true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: _visible ? 1 : 0),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) {
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - t)),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

