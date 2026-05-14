import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/ui/ui_models.dart';
import '../../theme/app_theme.dart';
import 'login_presenter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    implements LoginView {
  late LoginPresenter _presenter;
  late LoginModel _model;

  @override
  void initState() {
    super.initState();
    _presenter = LoginPresenter(view: this);
    _presenter.getUI(context);
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }

  @override
  void setUI(LoginModel model) {
    setState(() => _model = model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: <Widget>[
              const Spacer(flex: 2),
              _AppIcon(),
              const SizedBox(height: 24),
              Text(
                _model.title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _model.tagline,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                ),
              ),
              const Spacer(flex: 2),
              if (_model.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _friendlyError(_model.error!),
                    style: const TextStyle(
                      color: AppTheme.danger,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              _SocialButton(
                label: _model.googleBtn,
                icon: _GoogleIcon(),
                onTap: () => unawaited(_presenter.signInWithGoogle(context)),
              ),
              const SizedBox(height: 12),
              _SocialButton(
                label: _model.appleBtn,
                icon: const Icon(
                  Icons.apple_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                onTap: () => unawaited(_presenter.signInWithApple(context)),
                dark: true,
              ),
              const Spacer(),
              Text(
                _model.legal,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _friendlyError(String raw) {
    if (raw.contains('cancelled') || raw.contains('cancel')) {
      return _model.errorCancelled;
    }
    if (raw.contains('network')) {
      return _model.errorNetwork;
    }
    return _model.errorGeneric;
  }
}

class _AppIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Icon(
        Icons.fitness_center_rounded,
        color: AppTheme.primaryOrange,
        size: 52,
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.dark = false,
  });

  final String label;
  final Widget icon;
  final VoidCallback onTap;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: dark ? Colors.black : Colors.white,
          side: BorderSide(
            color: dark ? Colors.white24 : Colors.transparent,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: dark ? Colors.white : Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -1.57, 3.14, true, Paint()..color = const Color(0xFFEA4335),
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      1.57, 1.57, true, Paint()..color = const Color(0xFF34A853),
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      3.14, 1.57, true, Paint()..color = const Color(0xFFFBBC05),
    );
    canvas.drawCircle(
      Offset(cx, cy), r * 0.65, Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromLTWH(cx, cy - r * 0.2, r, r * 0.4),
      Paint()..color = const Color(0xFF4285F4),
    );
  }

  @override
  bool shouldRepaint(_GooglePainter old) => false;
}
