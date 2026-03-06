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
                          child: ChoiceChip(
                            label: Text(
                              device.name,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white60,
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _currentDevice = device;
                                });
                              }
                            },
                            backgroundColor: Colors.white.withAlpha(20),
                            selectedColor: const Color(0xFF4F46E5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            visualDensity: VisualDensity.compact,
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

