import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  // Request necessary permissions for Bluetooth
  Future<void> requestPermissions() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location
    ].request();
    scanForDevices();
  }

  // Scan for Bluetooth devices
  void scanForDevices() async {
    var status = await Permission.bluetoothScan.request();
    if (status.isGranted) {
      devices.clear();

      // Start scanning
      FlutterBluePlus.scan();

      // Listen for devices being discovered
      FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult result in results) {
          if (!devices.any((device) => device.remoteId == result.device.remoteId)) {
            setState(() {
              devices.add(result.device);
            });
          }
        }
      });

      // Stop scanning after 5 seconds
      await Future.delayed(Duration(seconds: 5));
      FlutterBluePlus.stopScan();
    } else {
      print("Bluetooth scan permission denied");
    }
  }


  // Connect to a selected Bluetooth device
  void connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connected to ${device.platformName}")),
      );
    } catch (e) {
      print("Error connecting: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bluetooth Scanner")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: scanForDevices,
            child: Text("Scan for Devices"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devices[index].platformName.isNotEmpty
                      ? devices[index].platformName
                      : "Unknown Device"),
                  subtitle: Text(devices[index].remoteId.toString()),
                  onTap: () => connectToDevice(devices[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}