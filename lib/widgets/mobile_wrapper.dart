import 'package:flutter/material.dart';
import 'package:device_frame/device_frame.dart';

class MobileWrapper extends StatefulWidget {
  final Widget child;
  const MobileWrapper({super.key, required this.child});

  @override
  State<MobileWrapper> createState() => _MobileWrapperState();
}

class _MobileWrapperState extends State<MobileWrapper> {
  // Custom Device Definitions for 2026 Models
  static final DeviceInfo _iPhone17Pro = DeviceInfo.genericPhone(
    platform: TargetPlatform.iOS,
    id: 'iphone-17-pro',
    name: 'iPhone 17 Pro',
    screenSize: const Size(393, 852),
    safeAreas: const EdgeInsets.only(top: 54, bottom: 34),
  );

  static final DeviceInfo _onePlus13R = DeviceInfo.genericPhone(
    platform: TargetPlatform.android,
    id: 'oneplus-13r',
    name: 'OnePlus 13R',
    screenSize: const Size(412, 906),
    safeAreas: const EdgeInsets.only(top: 36, bottom: 20),
  );

  late DeviceInfo _currentDevice;
  Orientation _orientation = Orientation.portrait;
  bool _useHighFidelity = true;

  final List<DeviceInfo> _availableDevices = [
    _onePlus13R,
    _iPhone17Pro,
    Devices.ios.iPhone13,
    Devices.android.samsungGalaxyS20,
    Devices.ios.iPad,
  ];

  @override
  void initState() {
    super.initState();
    _currentDevice = _onePlus13R;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          final isHighFidelityAvailable = _currentDevice == _onePlus13R || _currentDevice == _iPhone17Pro;
          
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
                  if (isHighFidelityAvailable) ...[
                    const Text("High-Fi", style: TextStyle(color: Colors.white38, fontSize: 10)),
                    Switch(
                      value: _useHighFidelity,
                      onChanged: (val) => setState(() => _useHighFidelity = val),
                    ),
                  ],
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
                  child: (_useHighFidelity && isHighFidelityAvailable)
                      ? HighFidelityFrame(
                          device: _currentDevice,
                          orientation: _orientation,
                          child: widget.child,
                        )
                      : DeviceFrame(
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

class HighFidelityFrame extends StatelessWidget {
  final DeviceInfo device;
  final Orientation orientation;
  final Widget child;

  const HighFidelityFrame({
    super.key,
    required this.device,
    required this.orientation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    bool isAndroid = device.identifier.platform == TargetPlatform.android;
    
    // OnePlus 13R vs iPhone 17 Pro styling
    double cornerRadius = isAndroid ? 32 : 48; // iPhone has more rounded corners
    double bezelWidth = 6.0; // Modern 2026 slim bezels
    
    return Center(
      child: Container(
        width: device.screenSize.width + (bezelWidth * 2),
        height: device.screenSize.height + (bezelWidth * 2),
        decoration: BoxDecoration(
          color: isAndroid ? const Color(0xFF1E293B) : const Color(0xFF27272A), // Gunmetal vs Titanium
          borderRadius: BorderRadius.circular(cornerRadius + bezelWidth),
          border: Border.all(
            color: isAndroid ? const Color(0xFF475569) : const Color(0xFF52525B),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(180),
              blurRadius: 40,
              spreadRadius: 2,
            ),
            // Inner bezel shadow
            BoxShadow(
              color: Colors.white12,
              blurRadius: 1,
              spreadRadius: -2,
              offset: const Offset(1, 1),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isAndroid 
                ? [const Color(0xFF334155), const Color(0xFF0F172A), const Color(0xFF1E293B)]
                : [const Color(0xFF3F3F46), const Color(0xFF18181B), const Color(0xFF27272A)],
          ),
        ),
        padding: EdgeInsets.all(bezelWidth),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(cornerRadius),
          child: Stack(
            children: [
              // The App Screen
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.only(top: 32), // Reserve space for simulated status bar
                  color: Colors.white,
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: ScaffoldMessenger(
                      child: Scaffold(body: child),
                    ),
                  ),
                ),
              ),

              // Simulated System Status Bar
              Positioned(
                top: 0,
                left: isAndroid ? 16 : 30,
                right: isAndroid ? 16 : 30,
                height: 32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Time
                    Text(
                      "17:48",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: isAndroid ? 'Roboto' : 'SF Pro Text',
                      ),
                    ),
                    // Status Icons
                    Row(
                      children: [
                        Icon(Icons.signal_cellular_4_bar, size: 12, color: Colors.black),
                        const SizedBox(width: 4),
                        Icon(Icons.wifi, size: 12, color: Colors.black),
                        const SizedBox(width: 4),
                        Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Icon(Icons.battery_full, size: 18, color: Colors.black),
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Text(
                                "67",
                                style: TextStyle(color: Colors.white, fontSize: 6, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Device Specific Hardware Features
              if (isAndroid) ...[
                // OnePlus 13R Punch Hole
                Align(
                  alignment: const Alignment(0, -0.96),
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(40),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                // Slim notification bar tint (optional)
              ] else ...[
                // iPhone 17 Pro Dynamic Island
                Align(
                  alignment: const Alignment(0, -0.96),
                  child: Container(
                    width: 110,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.indigo.withAlpha(50),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              
              // Glass Reflection Effect
              IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: const Alignment(-0.5, -0.5),
                      colors: [
                        Colors.white.withAlpha(15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

