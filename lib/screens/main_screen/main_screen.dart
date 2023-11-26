import 'dart:async';

import 'package:binom_tech_test/screens/main_screen/widgets/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

final List<Person> persons = [
  Person(
    imageUrl:
        'https://img.freepik.com/free-photo/portrait-austrian-man_53876-15108.jpg',
    name: 'Andrey',
    birthDateTime: DateTime(1990, 12, 30, 16, 8),
    lat: 55.855347,
    long: 37.695146,
  ),
  Person(
    imageUrl:
        'https://img.freepik.com/premium-photo/portrait-of-a-young-man-with-a-beard-studio-shot_949828-4306.jpg',
    name: 'Maxim',
    birthDateTime: DateTime(1987, 10, 10, 12, 32),
    lat: 55.808318,
    long: 37.551457,
  ),
  Person(
    imageUrl:
        'https://t4.ftcdn.net/jpg/02/32/98/33/360_F_232983351_z5CAl79bHkm6eMPSoG7FggQfsJLxiZjY.jpg',
    name: 'Mike',
    birthDateTime: DateTime(1978, 1, 14, 15, 45),
    lat: 55.679700,
    long: 37.593951,
  ),
  Person(
    imageUrl:
        'https://img.freepik.com/free-photo/close-up-portrait-young-bearded-man-face_171337-2887.jpg',
    name: 'Egor',
    birthDateTime: DateTime(1973, 2, 16, 5, 42),
    lat: 55.707645,
    long: 37.753530,
  ),
  Person(
    imageUrl:
        'https://dc-dermdocs.com/wp-content/uploads/shutterstock_149962697.jpg',
    name: 'Kate',
    birthDateTime: DateTime(1985, 4, 3, 7, 22),
    lat: 55.769772,
    long: 37.740016,
  ),
];

class Person extends Equatable {
  const Person({
    required this.imageUrl,
    required this.name,
    required this.birthDateTime,
    required this.lat,
    required this.long,
  });

  final String imageUrl;
  final String name;
  final DateTime birthDateTime;
  final double lat;
  final double long;

  factory Person.empty() => Person(
        imageUrl: '',
        name: '',
        birthDateTime: DateTime(0),
        lat: 0.0,
        long: 0.0,
      );

  @override
  List<Object?> get props => [imageUrl, name, birthDateTime, lat, long];
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final BottomMenuController _bottonMenuController = BottomMenuController();
  final MapController _mapController = MapController();

  final ValueNotifier<Person?> _selectedPerson = ValueNotifier(null);

  LatLng? _userPosition;

  late final StreamSubscription _streamSub;

  @override
  void initState() {
    super.initState();
    _streamSub = Geolocator.getServiceStatusStream().listen(
      (event) {
        if (event == ServiceStatus.enabled) {
          _determinePosition();
        }

        if (event == ServiceStatus.disabled) {
          _showGeoServiceDialog();
        }
      },
    );
    _determinePosition();
  }

  @override
  void dispose() {
    _bottonMenuController.dispose();
    _mapController.dispose();
    _streamSub.cancel();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showGeoServiceDialog();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showPermissionDialog();

        return;
      }
    }

    final position = await Geolocator.getCurrentPosition();

    setState(() {
      _userPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return PermissionDialog(deteriminePosition: _determinePosition);
      },
    );
  }

  void _showGeoServiceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const GeoServiceDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialZoom: 12,
                maxZoom: 16,
                minZoom: 6,
                initialCenter: const LatLng(55.751829, 37.618924),
                onTap: (tapPosition, point) {
                  _selectedPerson.value = null;
                  _bottonMenuController.hide();
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.binom_tech_test',
                ),
                ListenableBuilder(
                  listenable: _selectedPerson,
                  builder: (context, child) => MarkerLayer(
                    markers: persons
                        .map(
                          (e) => Marker(
                            width: 50,
                            height: 50,
                            point: LatLng(
                              e.lat,
                              e.long,
                            ),
                            child: PersonMarker(
                              onTap: _onMarkerTap,
                              person: e,
                              selected: e == _selectedPerson.value,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                if (_userPosition != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        height: 50,
                        width: 50,
                        point: _userPosition!,
                        child: Image.asset(
                          'assets/my_location.png',
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: SizedBox(
                width: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _onZoomInTap,
                      child: Image.asset('assets/plus.png'),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                        onTap: _onZoomOutTap,
                        child: Image.asset('assets/minus.png')),
                    const SizedBox(height: 4),
                    GestureDetector(
                        onTap: _onMyLocatinTap,
                        child: Image.asset('assets/my_location_button.png')),
                    const SizedBox(height: 4),
                    GestureDetector(
                        onTap: _onNextTrackerTap,
                        child: Image.asset('assets/next_tracker.png')),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomMenu(
                controller: _bottonMenuController,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onNextTrackerTap() {
    if (_selectedPerson.value == null) {
      _selectPerson(persons.first);
      return;
    }
    final index = persons.indexOf(_selectedPerson.value!);

    if (index != persons.length - 1) {
      _selectPerson(persons[index + 1]);

      return;
    }

    _selectPerson(persons.first);
  }

  void _selectPerson(Person person) {
    _mapController.move(
      LatLng(
        person.lat,
        person.long,
      ),
      _mapController.camera.zoom,
    );
    _selectedPerson.value = person;
    _bottonMenuController.show(person);
  }

  void _onMarkerTap(Person person) {
    _selectedPerson.value = person;

    _bottonMenuController.show(person);
  }

  void _onZoomInTap() {
    _mapController.move(
      LatLng(
        _mapController.camera.center.latitude,
        _mapController.camera.center.longitude,
      ),
      _mapController.camera.zoom + 1,
    );
  }

  void _onZoomOutTap() {
    _mapController.move(
      LatLng(
        _mapController.camera.center.latitude,
        _mapController.camera.center.longitude,
      ),
      _mapController.camera.zoom - 1,
    );
  }

  void _onMyLocatinTap() async {
    if (_userPosition == null) {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showGeoServiceDialog();
        return;
      }
      _showPermissionDialog();
      return;
    }

    _mapController.move(
      LatLng(
        _userPosition!.latitude,
        _userPosition!.longitude,
      ),
      _mapController.camera.zoom,
    );
  }
}
