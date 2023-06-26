import 'dart:async';
import 'package:blue_locator/src/features/home/widgets/device_item.dart';
import 'package:blue_locator/src/models/device_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, Device> devices = {};

  Completer<void>? scanCompleter;
  StreamSubscription<List<ScanResult>>? scanSubscription;

  @override
  void dispose() {
    scanSubscription?.cancel();
    super.dispose();
  }

  Future<void> requestBluetoothPermission() async {
    final status = await Permission.bluetooth.request();
    if (!status.isGranted) {
      throw Exception('Bluetooth permission not granted');
    }
  }

  Future<void> scanBluetoothDevices() async {
    await requestBluetoothPermission();
    final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

    scanCompleter = Completer<void>();
    await scanSubscription?.cancel();
    devices.clear();

    scanSubscription = flutterBlue.scanResults.listen((results) {
      for (final ScanResult r in results) {
        setState(() {
          if (r.device.name.isNotEmpty) {
            devices[r.device.id.id] = Device(
              id: r.device.id.id,
              name: r.device.name ?? '',
              type: r.device.type.name,
              rssi: r.rssi,
            );
          }
        });
      }
    });

    await flutterBlue.startScan(timeout: const Duration(seconds: 10));

    await scanCompleter?.future;
    await flutterBlue.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Tracker!'),
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final deviceList = devices.values.toList();
          return DeviceItem(device: deviceList[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scanBluetoothDevices().then((_) {
            scanCompleter?.complete();
          });
        },
        tooltip: 'Scan',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
