import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/organization.dart';
import 'home_shell.dart';
import 'password_setup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  final String? workspaceId;
  final bool isJoining;
  const LoginScreen({super.key, this.workspaceId, this.isJoining = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _orgCodeController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoggingIn = false;

  @override
  void initState() {
    super.initState();
    if (widget.workspaceId != null) {
      _orgCodeController.text = widget.workspaceId!;
    }
    _emailController.text =
        'clientname@businessunit.com'; // Pre-filled for your convenience
    _passwordController.text = 'password123';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _orgCodeController.dispose();
    super.dispose();
  }

  void _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    if (_orgCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter an organization code (e.g., yopmail or bluewhale)',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoggingIn = true;
    });

    // Simulate network delay to verify organization and authenticate
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final org = Organization.fromCode(_orgCodeController.text);

    if (org == null) {
      setState(() {
        _isLoggingIn = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Organization not found. Try "yopmail" or "bluewhale"'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // In a real app, we would authenticate against the organization
    if (_emailController.text == 'clientname@businessunit.com' &&
        _passwordController.text == 'password123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeShell(organization: org)),
      );
    } else {
      setState(() {
        _isLoggingIn = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid email or password. Use clientname@businessunit.com / password123',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(12),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildLoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -16,
          right: -16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFC7D2FE)),
            ),
            child: const Text(
              'CLIENT APP',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4338CA),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [SvgPicture.asset('assets/logo.svg', height: 40)],
        ),
      ],
    );
  }

  Widget _buildStepTitle(String title, String subtitle) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4F46E5),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        _buildStepTitle('Welcome Back', 'Sign in to your account'),
        const SizedBox(height: 32),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Organization Code *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _orgCodeController,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter an organization code'
                    : null,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  hintText: 'e.g. yopmail or bluewhale',
                  prefixIcon: const Icon(
                    Icons.business,
                    color: Color(0xFF94A3B8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Email Address *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                validator: (value) => (value == null || !value.contains('@'))
                    ? 'Please enter a valid email'
                    : null,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  hintText: 'name@company.com',
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF94A3B8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Password *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter a password'
                    : null,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Forgot Password
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
              );
            },
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: Color(0xFF4F46E5),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isLoggingIn ? null : _handleSignIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isLoggingIn
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'First time here? ',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PasswordSetupScreen(),
                  ),
                );
              },
              child: const Text(
                'Set up your account',
                style: TextStyle(
                  color: Color(0xFF4F46E5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
