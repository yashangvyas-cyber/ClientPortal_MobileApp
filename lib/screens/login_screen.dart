import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'forgot_password_screen.dart';
import 'home_shell.dart';

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
  bool _obscurePassword = true;
  bool _isLoggingIn = false;
  late String _selectedOrg;

  @override
  void initState() {
    super.initState();
    _selectedOrg = widget.workspaceId ?? 'yopmail';
    _emailController.text = 'clientname@businessunit.com'; // Pre-filled for your convenience
    _passwordController.text = 'password123';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoggingIn = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      if (_emailController.text == 'clientname@businessunit.com' && 
          _passwordController.text == 'password123') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeShell()),
        );
      } else {
        setState(() {
          _isLoggingIn = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password. Use clientname@businessunit.com / password123'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _showOrgPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Business Unit',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildOrgItem('yopmail', 'Primary Business Unit', true),
                  _buildOrgItem('acme-corp', 'Marketing & Sales', false),
                  _buildOrgItem('globex', 'Logistics Division', false),
                  _buildOrgItem('stark-ind', 'R&D Department', false),
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Divider(),
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFF1F5F9),
                      child: Icon(Icons.add, color: Color(0xFF4F46E5)),
                    ),
                    title: const Text('Add another organization'),
                    onTap: () {
                      Navigator.pop(context); // Close bottom sheet
                      Navigator.pop(context); // Go back to Workspace Setup
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrgItem(String id, String subtitle, bool isSelected) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: isSelected ? const Color(0xFFE0E7FF) : const Color(0xFFF1F5F9),
        child: Icon(
          Icons.business,
          color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
        ),
      ),
      title: Text(
        id,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: const Color(0xFF0F172A),
        ),
      ),
      subtitle: Text(subtitle),
      trailing: isSelected 
          ? const Icon(Icons.check_circle, color: Color(0xFF4F46E5))
          : null,
      onTap: () {
        setState(() {
          _selectedOrg = id;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Background color from screenshot
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
                  color: Colors.black.withAlpha(12), // ~0.05 opacity
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E7FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'CLIENT PORTAL',
                        style: TextStyle(
                          color: Color(0xFF4F46E5),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/logo.svg',
                      height: 40,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  widget.isJoining ? 'Join Workspace' : 'Sign in to',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4F46E5),
                  ),
                ),
                Text(
                  widget.isJoining ? widget.workspaceId?.toUpperCase() ?? 'NEW BUSINESS UNIT' : 'Client Portal',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFB347),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.isJoining 
                    ? 'Use your existing credentials to join this unit.'
                    : 'Use your email and password to sign in',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: _showOrgPicker,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFDBEAFE)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.business_outlined, color: Color(0xFF4F46E5), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                              children: [
                                const TextSpan(text: 'Organization: '),
                                TextSpan(
                                  text: _selectedOrg,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down, color: Color(0xFF94A3B8), size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter your email';
                          if (!value.contains('@')) return 'Please enter a valid email';
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          hintText: 'name@company.com',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter your password';
                          if (value.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: const Color(0xFF94A3B8),
                              size: 20,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoggingIn ? null : _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoggingIn 
                      ? const SizedBox(
                          width: 20, 
                          height: 20, 
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                        )
                      : const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
