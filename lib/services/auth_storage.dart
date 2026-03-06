import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SavedAccount {
  final String orgCode;
  final String email;
  final String? orgName;
  final String? sessionToken;
  final DateTime? sessionExpiry;

  SavedAccount({
    required this.orgCode,
    required this.email,
    this.orgName,
    this.sessionToken,
    this.sessionExpiry,
  });

  bool get hasActiveSession =>
      sessionToken != null &&
      (sessionExpiry?.isAfter(DateTime.now()) ?? false);

  Map<String, dynamic> toJson() => {
        'orgCode': orgCode,
        'email': email,
        'orgName': orgName,
        'sessionToken': sessionToken,
        'sessionExpiry': sessionExpiry?.toIso8601String(),
      };

  factory SavedAccount.fromJson(Map<String, dynamic> json) => SavedAccount(
        orgCode: json['orgCode'],
        email: json['email'],
        orgName: json['orgName'],
        sessionToken: json['sessionToken'],
        sessionExpiry: json['sessionExpiry'] != null
            ? DateTime.tryParse(json['sessionExpiry'])
            : null,
      );
}

class AuthStorage {
  static const String _accountsKey = 'saved_accounts';

  // Get all saved accounts
  static Future<List<SavedAccount>> getSavedAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accountsJson = prefs.getString(_accountsKey);
    if (accountsJson == null) return [];

    try {
      final List<dynamic> decodedList = jsonDecode(accountsJson);
      return decodedList
          .map((item) => SavedAccount.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Save a new account
  static Future<void> saveAccount(SavedAccount account) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = await getSavedAccounts();

    // Check if account already exists (same org and email)
    final existingIndex = accounts.indexWhere(
      (a) => a.orgCode == account.orgCode && a.email == account.email,
    );

    if (existingIndex >= 0) {
      // Update existing
      accounts[existingIndex] = account;
    } else {
      // Add new
      accounts.add(account);
    }

    final String encodedList =
        jsonEncode(accounts.map((a) => a.toJson()).toList());
    await prefs.setString(_accountsKey, encodedList);
  }

  // Remove an account
  static Future<void> removeAccount(String orgCode, String email) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = await getSavedAccounts();

    accounts.removeWhere((a) => a.orgCode == orgCode && a.email == email);

    final String encodedList =
        jsonEncode(accounts.map((a) => a.toJson()).toList());
    await prefs.setString(_accountsKey, encodedList);
  }
}
