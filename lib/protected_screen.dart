import 'package:flutter/material.dart';
import 'package:screen_protector/screen_protector.dart';

import 'NewPatient/new_patient_mtd.dart';

enum ProtectionType {
  normal,
  blur,
  color,
}

class ProtectedScreen extends StatefulWidget {
  final Widget child;
  final bool enableProtection;
  final ProtectionType protectionType;
  final int blurRadius;
  final Color colorOverlay;
  final bool showProtectionIndicator;
  final String protectionMessage;

  const ProtectedScreen({
    Key? key,
    required this.child,
    this.enableProtection = true,
    this.protectionType = ProtectionType.normal,
    this.blurRadius = 20,
    this.colorOverlay = const Color(0x80000000), // Semi-transparent black
    this.showProtectionIndicator = false,
    this.protectionMessage = 'Screen protection is active',
  }) : super(key: key);

  @override
  State<ProtectedScreen> createState() => _ProtectedScreenState();
}

class _ProtectedScreenState extends State<ProtectedScreen>
    with WidgetsBindingObserver {
  bool isProtectionEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (widget.enableProtection) {
      _enableProtection();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disableProtection();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        if (widget.enableProtection && mounted) {
          _enableProtection();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      // Keep protection active
        break;
      case AppLifecycleState.detached:
        _disableProtection();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  Future<void> _enableProtection() async {
    try {
      switch (widget.protectionType) {
        case ProtectionType.normal:
          await ScreenProtector.protectDataLeakageOn();
          break;
        case ProtectionType.blur:
          await ScreenProtector.protectDataLeakageWithBlur();
          break;
        case ProtectionType.color:
          await ScreenProtector.protectDataLeakageWithColor(widget.colorOverlay);
          break;
      }

      if (mounted) {
        setState(() {
          isProtectionEnabled = true;
        });
      }

      print('Screen protection enabled: ${widget.protectionType}');
    } catch (e) {
      print('Failed to enable screen protection: $e');
      if (mounted) {
        setState(() {
          isProtectionEnabled = false;
        });
      }
    }
  }

  Future<void> _disableProtection() async {
    try {
      await ScreenProtector.protectDataLeakageOff();
      if (mounted) {
        setState(() {
          isProtectionEnabled = false;
        });
      }
      print('Screen protection disabled');
    } catch (e) {
      print('Failed to disable screen protection: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _disableProtection();
        return true;
      },
      child: Column(
        children: [
          // Optional protection indicator
          if (widget.showProtectionIndicator && isProtectionEnabled)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.green.shade100,
              child: Row(
                children: [
                  Icon(Icons.security,
                      color: Colors.green.shade700, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    widget.protectionMessage,
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          // Main content
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}

// Usage examples:

// Example 1: Basic protection
class BasicProtectedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProtectedScreen(
      child: NewPatientMTD(),
    );
  }
}

// Example 2: Protection with blur effect
class BlurProtectedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProtectedScreen(
      protectionType: ProtectionType.blur,
      blurRadius: 25,
      showProtectionIndicator: true,
      child: NewPatientMTD(),
    );
  }
}

// Example 3: Protection with color overlay
class ColorProtectedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProtectedScreen(
      protectionType: ProtectionType.color,
      colorOverlay: const Color(0x90FF0000), // Semi-transparent red
      showProtectionIndicator: true,
      protectionMessage: 'Confidential data - Screenshots blocked',
      child: NewPatientMTD(),
    );
  }
}