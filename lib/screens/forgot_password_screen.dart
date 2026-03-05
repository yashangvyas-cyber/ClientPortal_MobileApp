import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubmitting = false;
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate network call
    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
      _submitted = true;
    });
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
            child: _submitted ? _buildSuccessState() : _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Back button row
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back, size: 16, color: Color(0xFF64748B)),
                  SizedBox(width: 4),
                  Text('Back to Sign In', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Icon
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: Color(0xFFEEF2FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.lock_reset_outlined, size: 36, color: Color(0xFF4F46E5)),
        ),
        const SizedBox(height: 20),

        // Title
        const Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4F46E5),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "No worries! Enter your email address and we'll send you a link to reset your password.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.5),
        ),
        const SizedBox(height: 28),

        // Form
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    (value == null || !value.contains('@')) ? 'Please enter a valid email address' : null,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  hintText: 'name@company.com',
                  prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF94A3B8)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Submit button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _handleSendLink,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('Send Reset Link', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Success icon
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Color(0xFFF0FDF4),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.mark_email_read_outlined, size: 40, color: Color(0xFF22C55E)),
        ),
        const SizedBox(height: 20),
        const Text(
          'Check your inbox!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 10),
        Text(
          'We sent a password reset link to\n${_emailController.text}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.5),
        ),
        const SizedBox(height: 8),
        const Text(
          'Please check your spam folder if you don\'t see it.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Back to Sign In', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: () => setState(() {
            _submitted = false;
            _emailController.clear();
          }),
          child: const Text(
            "Didn't receive it? Resend",
            style: TextStyle(fontSize: 13, color: Color(0xFF4F46E5), fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
