import 'package:flutter/material.dart';

const blue = Color(0xFF1976D2), navy = Color(0xFF0B2A5B);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hide = true, remember = false;

  InputDecoration deco(String label, String hint, IconData icon, [Widget? s]) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(icon),
        suffixIcon: s,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      );

  Widget feature(IconData i, String t) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Row(
      children: [
        Icon(i, color: Colors.white),
        const SizedBox(width: 12),
        Text(
          t,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final brand = Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFF1B5FA8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            child: Text('SKH', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          const Text(
            'Sarkari Karmachari Hospital',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Patient Healthcare Portal',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          feature(Icons.event_available, 'Appointment Management'),
          feature(Icons.verified_user, 'Verified Patient Access'),
          feature(Icons.description, 'Prescriptions & Reports'),
        ],
      ),
    );

    final form = Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account Access',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: deco(
              'Phone / Patient ID / Username',
              '01XXXXXXXXX',
              Icons.person_outline,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            obscureText: hide,
            decoration: deco(
              'Password',
              '••••••••',
              Icons.lock_outline,
              IconButton(
                icon: Icon(hide ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => hide = !hide),
              ),
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: remember,
                onChanged: (v) => setState(() => remember = v!),
              ),
              const Text('Remember Me'),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(color: navy, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Sign In'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Get password with OTP'),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Set your first password through OTP verification before signing in.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Row(
            children: [
              const Text("Don't have an account? "),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Create account',
                  style: TextStyle(color: navy, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFCFE2F5),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 880),
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: LayoutBuilder(
                builder: (_, c) => c.maxWidth > 700
                    ? IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(flex: 46, child: brand),
                            Expanded(flex: 54, child: form),
                          ],
                        ),
                      )
                    : Column(children: [brand, form]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
