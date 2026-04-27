import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/auth_storage.dart';
import '../models/organization.dart';
import 'login_screen.dart';
import 'account_setup_flow.dart';
import 'client_portal_sign_in_screen.dart';
import 'home_shell.dart';

class OrgSelectionScreen extends StatefulWidget {
  const OrgSelectionScreen({super.key});

  @override
  State<OrgSelectionScreen> createState() => _OrgSelectionScreenState();
}

class _OrgSelectionScreenState extends State<OrgSelectionScreen> {
  List<SavedAccount> _savedAccounts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    final accounts = await AuthStorage.getSavedAccounts();
    setState(() {
      _savedAccounts = accounts;
      _isLoading = false;
    });

    // If no accounts, we no longer redirect directly. 
    // We stay on this screen to show the "Welcome to CollabCRM" state.
    /*
    if (_savedAccounts.isEmpty && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(
            showBackButton: false,
            isAddingNew: true,
          ),
        ),
      );
    }
    */
  }

  void _navigateToLogin(SavedAccount account) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientPortalSignInScreen(
          orgCode: account.orgCode,
          prefilledEmail: account.email,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }


    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 32),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _savedAccounts.isEmpty ? 'Welcome to CollabCRM' : 'Your Organisations',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _savedAccounts.isEmpty
                              ? 'Get started by connecting with organisation'
                              : 'Select an organisation to continue',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 32),
                        ..._savedAccounts.map((account) => _buildOrgCard(account)),
                        const SizedBox(height: 16),
                        _buildAddAnotherButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Temporary dev shortcut — reset to no-accounts landing state
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextButton.icon(
                onPressed: () async {
                  await AuthStorage.clearAllAccounts();
                  await _loadAccounts();
                },
                icon: const Icon(Icons.refresh, size: 14, color: Color(0xFFCBD5E1)),
                label: const Text(
                  'Temporary Back',
                  style: TextStyle(fontSize: 12, color: Color(0xFFCBD5E1)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/logo.svg',
            height: 48,
          ),
          const SizedBox(width: 16),
          Container(
            margin: const EdgeInsets.only(top: 4),
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
        ],
      ),
    );
  }

  Widget _buildOrgCard(SavedAccount account) {
    // Generate initials for avatar
    String orgName = account.orgName ?? 
        (Organization.fromCode(account.orgCode)?.name ?? account.orgCode);
    String initials = orgName.length >= 2 
        ? orgName.substring(0, 2).toUpperCase() 
        : orgName.toUpperCase();
        
    // Assign a mock color based on initials sum
    int colorValue = initials.codeUnits.fold(0, (prev, element) => prev + element);
    Color avatarColor = Color(0xFF000000 | (colorValue * 0x123456) % 0xFFFFFF).withOpacity(0.2);
    Color textColor = const Color(0xFF4F46E5); // Default indigo-ish

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => _navigateToLogin(account),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: avatarColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orgName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      account.email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: account.hasActiveSession ? Colors.green : const Color(0xFFCBD5E1),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF94A3B8),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddAnotherButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(isAddingNew: true),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFCBD5E1),
            style: BorderStyle.solid, // Flutter doesn't easily support dashed borders out-of-the-box without custom painter, using solid for now
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: Color(0xFF64748B), size: 20),
            SizedBox(width: 8),
            Text(
              _savedAccounts.isEmpty ? 'Add Organisation' : 'Add Another Organization',
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
