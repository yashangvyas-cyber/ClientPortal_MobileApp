import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/org_selection_screen.dart';
import 'widgets/mobile_wrapper.dart';

void main() {
  runApp(const CollabCRMMobileApp());
}

class CollabCRMMobileApp extends StatelessWidget {
  const CollabCRMMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CollabCRM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Using builder to ensure ALL screens are wrapped in the mobile frame during prototyping
      builder: (context, child) => MobileWrapper(child: child!),
      home: const OrgSelectionScreen(),
    );
  }
}
