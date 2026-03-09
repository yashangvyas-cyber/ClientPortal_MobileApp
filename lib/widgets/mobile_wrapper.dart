import 'package:flutter/material.dart';
import 'package:device_frame/device_frame.dart';

class MobileWrapper extends StatefulWidget {
  final Widget child;
  const MobileWrapper({super.key, required this.child});

  @override
  State<MobileWrapper> createState() => _MobileWrapperState();
}

class _MobileWrapperState extends State<MobileWrapper> {
  late DeviceInfo _currentDevice;
  Orientation _orientation = Orientation.portrait;

  final List<DeviceInfo> _availableDevices = [
    Devices.ios.iPhone13,
    Devices.android.samsungGalaxyS20,
    Devices.ios.iPad,
  ];

  @override
  void initState() {
    super.initState();
    _currentDevice = Devices.ios.iPhone13;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: const Color(0xFF0F172A),
              appBar: AppBar(
                backgroundColor: const Color(0xFF1E293B),
                elevation: 4,
                centerTitle: false,
                title: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Text(
                        "Preview:",
                        style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12),
                      ..._availableDevices.map((device) {
                        final isSelected = _currentDevice == device;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _currentDevice = device;
                              });
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected 
                                  ? const Color(0xFF4F46E5) 
                                  : const Color(0xFF334155).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected 
                                    ? const Color(0xFF818CF8) 
                                    : Colors.white10,
                                  width: 1,
                                ),
                                boxShadow: isSelected ? [
                                  BoxShadow(
                                    color: const Color(0xFF4F46E5).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ] : null,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSelected) 
                                    const Padding(
                                      padding: EdgeInsets.only(right: 6),
                                      child: Icon(
                                        Icons.check_circle, 
                                        size: 14, 
                                        color: Colors.white,
                                      ),
                                    ),
                                  Text(
                                    device.name,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                actions: [
                  const VerticalDivider(color: Colors.white24, indent: 12, endIndent: 12),
                  IconButton(
                    tooltip: "Toggle Orientation",
                    icon: Icon(
                      _orientation == Orientation.portrait ? Icons.screen_lock_portrait : Icons.screen_lock_landscape,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _orientation = _orientation == Orientation.portrait
                            ? Orientation.landscape
                            : Orientation.portrait;
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: DeviceFrame(
                    device: _currentDevice,
                    orientation: _orientation,
                    screen: Container(
                      color: Colors.white,
                      // Wrap with a local MaterialApp to constrain SnackBars to this screen
                      child: MaterialApp(
                        debugShowCheckedModeBanner: false,
                        home: ScaffoldMessenger(
                          child: Scaffold(body: widget.child),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        
        return widget.child;
      },
    );
  }
}

