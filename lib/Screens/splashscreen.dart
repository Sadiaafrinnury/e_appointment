// ───────────── Tokens ─────────────
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kBlue = Color(0xFF1976D2);
const kNavy = Color(0xFF0B2A5B);
const kMuted = Color(0xFF5F6B7A);
const kBorder = Color(0xFF9AA5B4);
const kLine = Color(0xFFD3DAE4);

// ───────────── Strings ─────────────
const _strEn = {
  'hospital': 'Sarkari Karmachari Hospital',
  'portal': 'Patient Healthcare Portal',
  'title': 'Account Access',
  'id': 'Phone / Patient ID / Username',
  'pass': 'Password',
  'remember': 'Remember Me',
  'forgot': 'Forgot password?',
  'signin': 'Sign In',
  'or': 'or',
  'otp': 'Get password with OTP',
  'otpHelp':
      'Set your first password through OTP verification before signing in.',
  'noacc': "Don't have an account? ",
  'create': 'Create account',
  'help': 'Help with signing in:',
  'quick': 'Quick introduction',
  'guide': 'User guide',
  'secure': 'Encrypted connection. Your health records stay private.',
  'tech': 'Technical assistance by ',
  'reqId': 'Enter your phone, ID or username',
  'reqPass': 'Enter your password',
};

const _strBn = {
  'hospital': 'সরকারি কর্মচারী হাসপাতাল',
  'portal': 'রোগী স্বাস্থ্যসেবা পোর্টাল',
  'title': 'অ্যাকাউন্ট অ্যাক্সেস',
  'id': 'ফোন / রোগী আইডি / ইউজারনেম',
  'pass': 'পাসওয়ার্ড',
  'remember': 'আমাকে মনে রাখুন',
  'forgot': 'পাসওয়ার্ড ভুলে গেছেন?',
  'signin': 'সাইন ইন',
  'or': 'অথবা',
  'otp': 'ওটিপি দিয়ে পাসওয়ার্ড নিন',
  'otpHelp':
      'সাইন ইন করার আগে ওটিপি যাচাইয়ের মাধ্যমে প্রথম পাসওয়ার্ড সেট করুন।',
  'noacc': 'অ্যাকাউন্ট নেই? ',
  'create': 'অ্যাকাউন্ট খুলুন',
  'help': 'সাইন ইনে সাহায্য:',
  'quick': 'দ্রুত পরিচিতি',
  'guide': 'ব্যবহার নির্দেশিকা',
  'secure': 'এনক্রিপ্টেড সংযোগ। আপনার স্বাস্থ্য তথ্য গোপন থাকবে।',
  'tech': 'কারিগরি সহায়তা: ',
  'reqId': 'ফোন, আইডি বা ইউজারনেম লিখুন',
  'reqPass': 'পাসওয়ার্ড লিখুন',
};

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  // entrance (staggered), ambient loop (ring + floating blobs), error shake
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();
  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 24),
  )..repeat();
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );

  final _form = GlobalKey<FormState>();
  final _passNode = FocusNode();
  bool _bn = false, _hide = true, _remember = false;
  int _status = 0; // 0 idle, 1 loading, 2 done

  String t(String k) => (_bn ? _strBn : _strEn)[k]!;

  @override
  void dispose() {
    _enter.dispose();
    _loop.dispose();
    _shake.dispose();
    _passNode.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_form.currentState!.validate()) {
      HapticFeedback.mediumImpact();
      _shake.forward(from: 0);
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _status = 1);
    await Future.delayed(const Duration(seconds: 2)); // TODO: auth API
    if (!mounted) return;
    setState(() => _status = 2);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _status = 0);
  }

  // Staggered fade + slide-up for each block
  Widget _stagger(int i, Widget child) {
    final start = (i * 0.07).clamp(0.0, 0.62);
    final anim = CurvedAnimation(
      parent: _enter,
      curve: Interval(
        start,
        math.min(start + 0.38, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.12),
          end: Offset.zero,
        ).animate(anim),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE6F0FB), Color(0xFFB9D5F2)],
              ),
            ),
          ),
          // floating soft blobs
          AnimatedBuilder(
            animation: _loop,
            builder: (_, __) {
              final a = _loop.value * 2 * math.pi;
              return Stack(
                children: [
                  Positioned(
                    left: -70 + 25 * math.sin(a),
                    top: 120 + 20 * math.cos(a),
                    child: _blob(220, 0.45),
                  ),
                  Positioned(
                    right: -80 + 25 * math.cos(a),
                    bottom: 80 + 25 * math.sin(a),
                    child: _blob(240, 0.35),
                  ),
                ],
              );
            },
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, c) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: c.maxHeight),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                          child: _stagger(0, _languageButton()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: _card(),
                        ),
                      ),
                      _stagger(9, _footer()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blob(double s, double o) => Container(
    width: s,
    height: s,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        colors: [Colors.white.withOpacity(o), Colors.white.withOpacity(0)],
      ),
    ),
  );

  // ───────────── Language (icon-only, like the design) ─────────────
  Widget _languageButton() => PopupMenuButton<bool>(
    tooltip: 'Language',
    onSelected: (v) => setState(() => _bn = v),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    itemBuilder: (_) => const [
      PopupMenuItem(value: false, child: Text('English')),
      PopupMenuItem(value: true, child: Text('বাংলা')),
    ],
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kBorder),
      ),
      child: const Icon(Icons.language_rounded, size: 20, color: kMuted),
    ),
  );

  // ───────────── Card ─────────────
  Widget _card() => _stagger(
    1,
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kNavy.withOpacity(0.18),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(children: [_header(), _body()]),
      ),
    ),
  );

  Widget _header() => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2F73BC), Color(0xFF0E4A89)],
      ),
    ),
    child: Stack(
      children: [
        Positioned(
          right: -50,
          top: -60,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.07),
            ),
          ),
        ),
        Row(
          children: [
            _logo(),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t('hospital'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    t('portal'),
                    style: const TextStyle(
                      color: Color(0xFFD6E6F7),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );

  // Logo with slowly rotating dashed ring
  Widget _logo() => SizedBox(
    width: 74,
    height: 74,
    child: Stack(
      alignment: Alignment.center,
      children: [
        RotationTransition(
          turns: _loop,
          child: CustomPaint(size: const Size(74, 74), painter: _RingPainter()),
        ),
        Container(
          width: 56,
          height: 56,
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          // Add your logo: assets/skh_logo.png (declare in pubspec.yaml)
          child: Image.asset(
            'assets/skh_logo.png',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Center(
              child: Text(
                'SKH',
                style: TextStyle(
                  color: Color(0xFF1B7A3D),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  // ───────────── Body ─────────────
  Widget _body() => Container(
    width: double.infinity,
    color: Colors.white.withOpacity(0.88),
    padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
    child: AutofillGroup(
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _stagger(
              2,
              Text(
                t('title'),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B1F24),
                ),
              ),
            ),
            const SizedBox(height: 14),
            // fields + remember row shake together on error
            AnimatedBuilder(
              animation: _shake,
              builder: (_, child) => Transform.translate(
                offset: Offset(
                  math.sin(_shake.value * math.pi * 6) * 9 * (1 - _shake.value),
                  0,
                ),
                child: child,
              ),
              child: Column(
                children: [
                  _stagger(
                    3,
                    TextFormField(
                      autofillHints: const [
                        AutofillHints.username,
                        AutofillHints.telephoneNumber,
                      ],
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => _passNode.requestFocus(),
                      validator: (v) =>
                          (v ?? '').trim().isEmpty ? t('reqId') : null,
                      decoration: _deco(
                        t('id'),
                        '01XXXXXXXXX',
                        const Icon(Icons.person_outline_rounded, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _stagger(
                    4,
                    TextFormField(
                      focusNode: _passNode,
                      obscureText: _hide,
                      autofillHints: const [AutofillHints.password],
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _signIn(),
                      validator: (v) => (v ?? '').isEmpty ? t('reqPass') : null,
                      decoration: _deco(
                        t('pass'),
                        '••••••••',
                        const Icon(Icons.lock_outline_rounded, size: 20),
                        IconButton(
                          onPressed: () => setState(() => _hide = !_hide),
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (w, a) => ScaleTransition(
                              scale: a,
                              child: FadeTransition(opacity: a, child: w),
                            ),
                            child: Icon(
                              _hide
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              key: ValueKey(_hide),
                              color: kMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            _stagger(
              5,
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => setState(() => _remember = !_remember),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: Checkbox(
                              value: _remember,
                              onChanged: (v) =>
                                  setState(() => _remember = v ?? false),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            t('remember'),
                            style: const TextStyle(color: kMuted, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      minimumSize: const Size(0, 36),
                    ),
                    child: Text(
                      t('forgot'),
                      style: const TextStyle(
                        color: kNavy,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _stagger(
              6,
              _SignInButton(
                label: t('signin'),
                status: _status,
                onTap: _signIn,
              ),
            ),
            const SizedBox(height: 10),
            _stagger(
              7,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(child: Divider(color: kLine)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          t('or'),
                          style: const TextStyle(color: kMuted, fontSize: 11),
                        ),
                      ),
                      const Expanded(child: Divider(color: kLine)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () {}, // TODO: OTP flow
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: kNavy,
                        side: const BorderSide(color: Color(0xFFC3CBD6)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: Text(t('otp')),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    t('otpHelp'),
                    style: const TextStyle(color: kMuted, fontSize: 11.5),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        t('noacc'),
                        style: const TextStyle(color: kMuted, fontSize: 13),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          t('create'),
                          style: const TextStyle(
                            color: kNavy,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    t('help'),
                    style: const TextStyle(color: kMuted, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 22,
                    runSpacing: 8,
                    children: [
                      _helpLink(
                        Icons.play_circle_outline_rounded,
                        t('quick'),
                        () {},
                      ), // TODO: intro video
                      _helpLink(
                        Icons.menu_book_rounded,
                        t('guide'),
                        () {},
                      ), // TODO: user guide
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _stagger(
              8,
              Column(
                children: [
                  const Divider(color: kLine, height: 1),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.shield_rounded, size: 15, color: kMuted),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          t('secure'),
                          style: const TextStyle(color: kMuted, fontSize: 11.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _helpLink(IconData i, String text, VoidCallback onTap) => InkWell(
    borderRadius: BorderRadius.circular(8),
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(i, size: 17, color: kNavy),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: kNavy,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    ),
  );

  InputDecoration _deco(
    String label,
    String hint,
    Widget prefix, [
    Widget? suffix,
  ]) {
    OutlineInputBorder b(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: c, width: w),
    );
    return InputDecoration(
      labelText: label,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: const TextStyle(color: kMuted, fontSize: 12.5),
      hintStyle: const TextStyle(color: Color(0xFFA3ABB5), fontSize: 14),
      prefixIcon: prefix,
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      enabledBorder: b(kBorder),
      focusedBorder: b(kBlue, 2),
      errorBorder: b(Colors.red.shade400),
      focusedErrorBorder: b(Colors.red.shade400, 2),
    );
  }

  Widget _footer() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    child: Text.rich(
      TextSpan(
        style: const TextStyle(color: kMuted, fontSize: 11.5),
        children: [
          TextSpan(text: t('tech')),
          const TextSpan(
            text: 'Crystal Technology Bangladesh Ltd.',
            style: TextStyle(color: kNavy, fontWeight: FontWeight.w800),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    ),
  );
}

// ───────────── Sign-in button: idle → spinner → check ─────────────
class _SignInButton extends StatelessWidget {
  final String label;
  final int status;
  final VoidCallback onTap;
  const _SignInButton({
    required this.label,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final idle = status == 0;
        final color = status == 2 ? const Color(0xFF2E7D32) : kBlue;
        return Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeInOutCubic,
            width: idle ? c.maxWidth : 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(idle ? 14 : 25),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(idle ? 14 : 25),
                onTap: idle ? onTap : null,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (w, a) =>
                        ScaleTransition(scale: a, child: w),
                    child: switch (status) {
                      1 => const SizedBox(
                        key: ValueKey('load'),
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Colors.white,
                        ),
                      ),
                      2 => const Icon(
                        Icons.check_rounded,
                        key: ValueKey('done'),
                        color: Colors.white,
                        size: 28,
                      ),
                      _ => Text(
                        label,
                        key: const ValueKey('label'),
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: size.width / 2 - 3,
    );
    const n = 24;
    for (var i = 0; i < n; i++) {
      canvas.drawArc(rect, i * 2 * math.pi / n, math.pi / n * 0.9, false, p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
