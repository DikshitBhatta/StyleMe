import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPicker extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  const MapPicker({super.key, required this.onLocationSelected});

  @override
  _MapPickerState createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  LatLng? selectedLocation;

  void _onTap(LatLng location) {
    setState(() {
      selectedLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a location'),
        backgroundColor: Colors.green[700],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(27.7172, 85.3240), 
          initialZoom: 11.0,
          onTap: (tapPosition, point) {
            _onTap(point);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          if (selectedLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: selectedLocation!,
                  child: const Icon(Icons.location_pin, color: Colors.red, size: 40), // Use 'child' instead of 'builder'
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedLocation != null) {
            Navigator.of(context).pop(selectedLocation);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a location')),
            );
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
