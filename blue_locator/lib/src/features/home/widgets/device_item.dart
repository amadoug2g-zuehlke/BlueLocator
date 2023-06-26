import 'package:blue_locator/src/models/device_model.dart';
import 'package:flutter/material.dart';

class DeviceItem extends StatelessWidget {
  const DeviceItem({required this.device, super.key});

  final Device device;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(device.name),
      subtitle: Text(
        'Type: ${device.type}\nRSSI: ${device.rssi}',
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        // TODO(amadou): Navigate to the DeviceDetails page
      },
    );
  }
}
