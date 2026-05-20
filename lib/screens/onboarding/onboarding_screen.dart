import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../theme/app_theme.dart';

const String kOnboardingKey = 'onboarding_complete';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _ctrl = PageController();
  int _page = 0;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    unawaited(HapticFeedback.mediumImpact());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kOnboardingKey, true);
    widget.onDone();
  }

  Future<void> _next(int total) async {
    unawaited(HapticFeedback.lightImpact());
    if (_page < total - 1) {
      await _ctrl.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final OnboardingStrings s =
        context.read<LanguageProvider>().strings.onboarding;

    final List<_SlideData> slides = <_SlideData>[
      _SlideData(
        icon: Icons.fitness_center_rounded,
        color: AppTheme.primaryOrange,
        title: s.slide1Title,
        body: s.slide1Body,
      ),
      _SlideData(
        icon: Icons.calendar_today_rounded,
        color: AppTheme.info,
        title: s.slide2Title,
        body: s.slide2Body,
      ),
      _SlideData(
        icon: Icons.sports_gymnastics_rounded,
        color: AppTheme.success,
        title: s.slide3Title,
        body: s.slide3Body,
      ),
      _SlideData(
        icon: Icons.bar_chart_rounded,
        color: const Color(0xFFAB47BC),
        title: s.slide4Title,
        body: s.slide4Body,
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finish,
                child: Text(
                  s.skip,
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                onPageChanged: (int i) {
                  unawaited(HapticFeedback.selectionClick());
                  setState(() => _page = i);
                },
                itemCount: slides.length,
                itemBuilder: (_, int i) => _Slide(data: slides[i]),
              ),
            ),
            _BottomBar(
              page: _page,
              total: slides.length,
              nextLabel: _page == slides.length - 1 ? s.start : s.next,
              onNext: () => unawaited(_next(slides.length)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SlideData {
  const _SlideData({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;
}

class _Slide extends StatelessWidget {
  const _Slide({required this.data});

  final _SlideData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, color: data.color, size: 60),
          ),
          const SizedBox(height: 40),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            data.body,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.page,
    required this.total,
    required this.nextLabel,
    required this.onNext,
  });

  final int page;
  final int total;
  final String nextLabel;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: List<Widget>.generate(total, (int i) {
              final bool active = i == page;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(right: 6),
                width: active ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active
                      ? AppTheme.primaryOrange
                      : const Color(0xFF444444),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              nextLabel,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
