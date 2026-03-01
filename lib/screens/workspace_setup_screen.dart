import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login_screen.dart';
import 'password_setup_screen.dart';

class WorkspaceSetupScreen extends StatefulWidget {
  const WorkspaceSetupScreen({super.key});

  @override
  State<WorkspaceSetupScreen> createState() => _WorkspaceSetupScreenState();
}

class _WorkspaceSetupScreenState extends State<WorkspaceSetupScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isValidating = false;

  void _onConnect() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isValidating = true;
    });

    // Simulate validation/lookup of the business unit
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isValidating = false;
      });
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(workspaceId: _controller.text.trim()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/logo.svg',
                  height: 60,
                ),
                const SizedBox(height: 48),
                const Text(
                  'Welcome to CollabCRM',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Enter your business unit ID to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Workspace URL or Code',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'e.g. orion-tech-1',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          prefixIcon: const Icon(Icons.link, color: Color(0xFF64748B)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isValidating ? null : _onConnect,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isValidating
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Connect Workspace',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan QR Code from Web'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF475569),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFC7D2FE)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'DEMO: TEST INVITE FLOWS',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4338CA),
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInviteButton(
                              'New User\n(Activate)', 
                              Icons.person_add,
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PasswordSetupScreen(inviteCode: 'ACT-001'),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildInviteButton(
                              'Existing User\n(Join Apex)', 
                              Icons.group_add,
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(
                                    workspaceId: 'apex-consulting',
                                    isJoining: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 48),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'RECENT WORKSPACES',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF94A3B8),
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildRecentWorkspace('Orion Tech 1', 'orion-tech-1', context),
                _buildRecentWorkspace('Paresh Logistics', 'paresh-log-02', context),
                _buildRecentWorkspace('Priya Consulting', 'priya-cons-99', context),
                
                const SizedBox(height: 48),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Don't have a workspace? Contact Support",
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInviteButton(String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF4F46E5),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFC7D2FE)),
        ),
      ),
    );
  }

  Widget _buildRecentWorkspace(String name, String id, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFF1F5F9),
          child: Text(
            name[0],
            style: const TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('ID: $id', style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(workspaceId: id),
            ),
          );
        },
      ),
    );
  }
}
