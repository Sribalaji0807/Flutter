import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:water/add.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  List<dynamic> jsonData = [];
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/markers.json');
    setState(() {
      jsonData = json.decode(jsonString);
      markers = _createMarkersFromJsonData();
    });
  }

  Set<Marker> _createMarkersFromJsonData() {
    Set<Marker> markers = {};
    for (var data in jsonData) {
      double latitude = data['latitude'];
      double longitude = data['longitude'];
      String title = data['title'];
      String name = data['name'];
      Marker marker = Marker(
        markerId: MarkerId(title+" "+name),
        position: LatLng(latitude, longitude),
        draggable: false,
        infoWindow: InfoWindow(
          title: title,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
      markers.add(marker);
    }
    return markers;
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(13.082680, 80.270721),
    zoom: 15.00000,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 0.0,
      target: LatLng(13.15359, 80.17007),
      tilt: 59.440717697143555,
      zoom: 14);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Water Supply Map'),
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        ),
        drawer: const NavigateDrawer(),
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _goToTheLake,
          label: const Text('Find the Lake?'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.water_drop),
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

class NavigateDrawer extends StatelessWidget {
  const NavigateDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        height: 150,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.water_drop,
                size: 60,
                color: Colors.black,
              ),
              SizedBox(height: 8),
              Text(
                'Water Supply Map',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(22),
        child: Wrap(
          runSpacing: 20,
          children: [
            ListTile(
              leading: const Icon(
                Icons.home_filled,
                size: 42,
                color: Colors.black,
              ),
              title: const Text(
                'Home',
                style: TextStyle(
                  fontSize: 20, // Larger font size
                  color: Color.fromARGB(255, 0, 0, 0), // Text color
                  fontWeight: FontWeight.w500, // Bold text
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to the home screen
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.favorite_border,
                size: 42,
                color: Colors.black,
              ),
              title: const Text(
                'Favo',
                style: TextStyle(
                  fontSize: 20, // Larger font size
                  color: Color.fromARGB(255, 0, 0, 0), // Text color
                  fontWeight: FontWeight.w500, // Bold text
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to the favourites screen
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.location_city,
                size: 42,
                color: Colors.black,
              ),
              title: const Text(
                'Add Location',
                style: TextStyle(
                  fontSize: 20, // Larger font size
                  color: Color.fromARGB(255, 0, 0, 0), // Text color
                  fontWeight: FontWeight.w500, // Bold text
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Add()),
                );
                // Navigate to the workflow screen
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.contact_page,
                size: 42,
                color: Colors.black,
              ),
              title: const Text(
                'Contact us',
                style: TextStyle(
                  fontSize: 20, // Larger font size
                  color: Color.fromARGB(255, 0, 0, 0), // Text color
                  fontWeight: FontWeight.w500, // Bold text
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to the workflow screen
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.info,
                size: 42,
                color: Colors.black,
              ),
              title: const Text(
                'About Us',
                style: TextStyle(
                  fontSize: 20, // Larger font size
                  color: Color.fromARGB(255, 0, 0, 0), // Text color
                  fontWeight: FontWeight.w500, // Bold text
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to the workflow screen
              },
            ),
          ],
        ),
      );
}
