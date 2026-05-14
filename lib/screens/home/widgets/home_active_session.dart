import 'dart:async';

import 'package:flutter/material.dart';

import '../../../models/ui/home_model.dart';
import '../../../theme/app_theme.dart';

class HomeActiveSessionBanner extends StatefulWidget {
  const HomeActiveSessionBanner({
    super.key,
    required this.model,
    required this.onTap,
  });
  final HomeModel model;
  final VoidCallback onTap;

  @override
  State<HomeActiveSessionBanner> createState() =>
      _HomeActiveSessionBannerState();
}

class _HomeActiveSessionBannerState extends State<HomeActiveSessionBanner> {
  late Timer _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (!mounted) {
      return;
    }
    setState(() {
      _elapsed = widget.model.sessionStart != null
          ? DateTime.now().difference(widget.model.sessionStart!)
          : Duration.zero;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _timeLabel {
    final String m = _elapsed.inMinutes.toString().padLeft(2, '0');
    final String s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s ${widget.model.strings.activeSessionElapsed}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[AppTheme.primaryOrange, AppTheme.darkOrange],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.play_circle_rounded,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.model.strings.activeSessionTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    _timeLabel,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white70,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
