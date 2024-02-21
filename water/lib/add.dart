import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  LatLng? currentPosition;
  TextEditingController _titleController = TextEditingController();

  static final CameraPosition initialPosition = CameraPosition(
    target: LatLng(13.15359, 80.17007),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Marker'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: initialPosition,
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  mapController = controller;
                });
              },
              onTap: (LatLng position) {
                setState(() {
                  currentPosition = position;
                  markers.add(
                    Marker(
                      markerId: MarkerId(position.toString()),
                      position: position,
                      draggable: true,
                      infoWindow: InfoWindow(title: 'Marker Title'),
                      onDragEnd: (LatLng newPosition) {
                        setState(() {
                          currentPosition = newPosition;
                        });
                      },
                    ),
                  );
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Enter title for marker',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (currentPosition != null) {
                _saveMarkerToJSON(currentPosition!, _titleController.text);
              }
            },
            child: const Text('Save Marker'),
          ),
          FutureBuilder(
            future: _loadMarkersFromJSON(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  void _saveMarkerToJSON(LatLng position, String title) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String filePath = '${documentsDirectory.path}/markers.json';

    List<dynamic> jsonData = [];
    File file = File(filePath);
    if (file.existsSync()) {
      String jsonString = file.readAsStringSync();
      jsonData = json.decode(jsonString);
    }

    Map<String, dynamic> newData = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'title': title,
      // Add more properties as needed
    };
    jsonData.add(newData);

    String updatedJsonString = json.encode(jsonData);
    file.writeAsStringSync(updatedJsonString);

    print('Marker data inserted successfully.');

    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: InfoWindow(title: title),
        ),
      );
    });
  }

  Future<void> _loadMarkersFromJSON() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String filePath = '${documentsDirectory.path}/markers.json';

    if (File(filePath).existsSync()) {
      String jsonString = File(filePath).readAsStringSync();
      List<dynamic> jsonData = json.decode(jsonString);

      setState(() {
        for (var item in jsonData) {
          markers.add(
            Marker(
              markerId: MarkerId(item['latitude'].toString()),
              position: LatLng(item['latitude'], item['longitude']),
              infoWindow: InfoWindow(title: item['title']),
            ),
          );
        }
      });
    }
  }
}