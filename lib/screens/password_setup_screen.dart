import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login_screen.dart';

class PasswordSetupScreen extends StatefulWidget {
  final String? inviteCode;
  const PasswordSetupScreen({super.key, this.inviteCode});

  @override
  State<PasswordSetupScreen> createState() => _PasswordSetupScreenState();
}

class _PasswordSetupScreenState extends State<PasswordSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSaving = false;

  double _strength = 0;
  String _strengthText = 'Weak';
  Color _strengthColor = Colors.red;

  void _checkStrength(String value) {
    double strength = 0;
    if (value.length >= 8) strength += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(value)) strength += 0.25;
    if (RegExp(r'[0-9]').hasMatch(value)) strength += 0.25;
    if (RegExp(r'[!@#\$&*~]').hasMatch(value)) strength += 0.25;

    setState(() {
      _strength = strength;
      if (strength <= 0.25) {
        _strengthText = 'Weak';
        _strengthColor = Colors.red;
      } else if (strength <= 0.5) {
        _strengthText = 'Fair';
        _strengthColor = Colors.orange;
      } else if (strength <= 0.75) {
        _strengthText = 'Good';
        _strengthColor = Colors.blue;
      } else {
        _strengthText = 'Strong';
        _strengthColor = Colors.green;
      }
    });
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    // Simulate account activation
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account activated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen(workspaceId: 'orion-tech-1')),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SvgPicture.asset(
                    'assets/logo.svg',
                    height: 50,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Activate Your Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Welcome! Please set a secure password for your ${widget.inviteCode != null ? "invite (#${widget.inviteCode})" : "new account"}.',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'New Password *',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  onChanged: _checkStrength,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter a password';
                    if (value.length < 8) return 'Minimum 8 characters required';
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Minimum 8 characters',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                        color: const Color(0xFF94A3B8),
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: _strength,
                        backgroundColor: const Color(0xFFF1F5F9),
                        color: _strengthColor,
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _strengthText,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _strengthColor),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Confirm Password *',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmController,
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Repeat your password',
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _isSaving
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Activate Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'Password must contain at least 8 characters, one number, and one special character.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
