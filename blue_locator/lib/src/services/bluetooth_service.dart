import 'package:blue_locator/src/models/device_model.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothService {
  static FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  static Future<List<Device>> scanDevices() async {
    final List<Device> devices = [];

    // Start scanning
    await flutterBlue.startScan(
      timeout: const Duration(
        seconds: 4,
      ),
    );

    // Listen to scan results
    flutterBlue.scanResults.listen((results) {
      for (final ScanResult result in results) {
        // Create a new device
        final Device device = Device(
          name: result.device.name,
          type: result.device.id.id,
          rssi: result.rssi,
        );
        devices.add(device);
      }
    });

    // Stop scanning
    await flutterBlue.stopScan();

    return devices;
  }
}
