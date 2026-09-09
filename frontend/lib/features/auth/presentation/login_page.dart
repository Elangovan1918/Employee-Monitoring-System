import 'package:flutter/material.dart';

import '../data/auth_repository.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepository = AuthRepository();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final session = await _authRepository.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage(session: session)),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeefaff),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 850;
            final loginBox = _LoginBox(
              state: this,
              onTogglePassword: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            );

            if (isWide) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Row(
                      children: [
                        const Expanded(child: _VeriniteSidePanel()),
                        Expanded(child: _LoginSide(loginBox: loginBox)),
                      ],
                    ),
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const _VeriniteSidePanel(compact: true),
                  const SizedBox(height: 18),
                  loginBox,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _VeriniteSidePanel extends StatelessWidget {
  const _VeriniteSidePanel({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: compact ? 260 : 560),
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 28 : 52),
      decoration: BoxDecoration(
        color: const Color(0xff55bddd),
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff8bdef0), Color(0xff60c4e1)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LogoMark(size: compact ? 76 : 120),
            SizedBox(height: compact ? 18 : 28),
            Text(
              'verinite',
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 38 : 54,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'We Make Payments Happen',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.92),
                fontSize: compact ? 15 : 19,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _LogoMarkPainter()),
    );
  }
}

class _LogoMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final outer = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(size.width * 0.03),
    );
    canvas.drawRRect(outer, Paint()..color = const Color(0xff55bddd));

    final inset = size.width * 0.14;
    final path = Path()
      ..moveTo(inset, inset)
      ..lineTo(size.width - inset, inset)
      ..lineTo(size.width - inset, size.height - inset)
      ..close();
    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LoginSide extends StatelessWidget {
  const _LoginSide({required this.loginBox});

  final Widget loginBox;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 560),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xfffbfeff),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xffd7eff7)),
      ),
      child: Center(child: SingleChildScrollView(child: loginBox)),
    );
  }
}

class _LoginBox extends StatelessWidget {
  const _LoginBox({required this.state, required this.onTogglePassword});

  final _LoginPageState state;
  final VoidCallback onTogglePassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffd7eff7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x180b7195),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: state._formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Employee Monitoring System',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff163d4d),
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            // const Text(
            //   'Enter your details to continue.',
            //   style: TextStyle(color: Color(0xff6b8c99)),
            // ),
            const SizedBox(height: 26),
            TextFormField(
              controller: state._usernameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter your username'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: state._passwordController,
              obscureText: state._obscurePassword,
              onFieldSubmitted: (_) => state._login(),
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  tooltip: 'Show password',
                  onPressed: onTogglePassword,
                  icon: Icon(
                    state._obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Enter your password' : null,
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: state._isLoading ? null : state._login,
                child: state._isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Sign in'),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              state._isLoading ? 'Signing in...' : 'Secure employee workspace',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Color(0xff8aa0a8)),
            ),
          ],
        ),
      ),
    );
  }
}
