import 'dart:async';

import 'package:flutter/services.dart';

/// Allows an application to keep the Wi-Fi radio awake. Normally the Wi-Fi
/// radio may turn off when the user has not used the device in a while.
/// Acquiring a WifiLock will keep the radio on until the lock is released.
/// Multiple applications may hold WifiLocks, and the radio will only be allowed
/// to turn off when no WifiLocks are held in any application.
///
/// Before using a WifiLock, consider carefully if your application requires
/// Wi-Fi access, or could function over a mobile network, if available. A
/// program that needs to download large files should hold a WifiLock to ensure
/// that the download will complete, but a program whose network usage is
/// occasional or low-bandwidth should not hold a WifiLock to avoid adversely
/// affecting battery life.
///
///Note that WifiLocks cannot override the user-level "Wi-Fi Enabled" setting,
/// nor Airplane Mode. They simply keep the radio from turning off when Wi-Fi
/// is already on but the device is idle.
class WifiLock {

  /// In this Wi-Fi lock mode, Wi-Fi will be kept active,
  /// and will behave normally, i.e., it will attempt to automatically
  /// establish a connection to a remembered access point that is
  /// within range, and will do periodic scans if there are remembered
  /// access points but none are in range.
  static const WIFI_MODE_FULL = 1;

  /// In this Wi-Fi lock mode, Wi-Fi will be kept active,
  /// but the only operation that will be supported is initiation of
  /// scans, and the subsequent reporting of scan results. No attempts
  /// will be made to automatically connect to remembered access points,
  /// nor will periodic scans be automatically performed looking for
  /// remembered access points. Scans must be explicitly requested by
  /// an application in this mode.
  static const WIFI_MODE_SCAN_ONLY = 2;

  /// In this Wi-Fi lock mode, Wi-Fi will be kept active as in mode
  /// {@link #WIFI_MODE_FULL} but it operates at high performance
  /// with minimum packet loss and low packet latency even when
  /// the device screen is off. This mode will consume more power
  /// and hence should be used only when there is a need for such
  /// an active connection.
  ///
  /// An example use case is when a voice connection needs to be
  /// kept active even after the device screen goes off. Holding the
  /// regular {@link #WIFI_MODE_FULL} lock will keep the wifi
  /// connection active, but the connection can be lossy.
  /// Holding a {@link #WIFI_MODE_FULL_HIGH_PERF} lock for the
  /// duration of the voice call will improve the call quality.
  ///
  /// When there is no support from the hardware, this lock mode
  /// will have the same behavior as {@link #WIFI_MODE_FULL}
  static const WIFI_MODE_FULL_HIGH_PERF = 3;

  static const MethodChannel _channel = const MethodChannel('multicast_lock');
  static WifiLock _instance;

  factory WifiLock(int type) {
    if (_instance == null) {
      _instance = new WifiLock._private(type);
    }
    return _instance;
  }

  final int type;
  WifiLock._private(this.type);

  /// Locks the Wi-Fi radio on until release() is called.
  Future<void> acquire() async {
    await _channel.invokeMethod('acquire', {'type': this.type});
  }

  /// Unlocks the Wi-Fi radio, allowing it to turn off when the device is idle.
  Future<void> release() async {
    await _channel.invokeMethod('release');
  }

  /// Checks whether this WifiLock is currently held.
  Future<bool> isHeld() async {
    final bool result = await _channel.invokeMethod('isHeld');
    return result;
  }
}