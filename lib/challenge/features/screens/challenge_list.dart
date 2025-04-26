import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/widgets/app_bottom_nav.dart';

class ChallengeList extends StatefulWidget {
  const ChallengeList({super.key});

  @override
  State<ChallengeList> createState() => _ChallengeListState();
}

class _ChallengeListState extends State<ChallengeList> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(37.5665, 126.9780); // 서울 시청 기준 좌표

  final List<Map<String, dynamic>> challenges = [
    {'id': '1', 'name': '분리수거 같이 해요~', 'current': 1, 'max': 5, 'location': '장소: 1', 'lat': 37.5665, 'lng': 126.9780},
    {'id': '2', 'name': '텀블러 사용하기', 'current': 1, 'max': 8, 'location': '장소: 2', 'lat': 37.5651, 'lng': 126.9895},
  ];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('현재 진행 중인 챌린지')),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            height: 250,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 14.0,
              ),
              markers: challenges.map((challenge) {
                return Marker(
                  markerId: MarkerId(challenge['id']),
                  position: LatLng(challenge['lat'], challenge['lng']),
                  infoWindow: InfoWindow(title: challenge['name']),
                );
              }).toSet(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                final challenge = challenges[index];
                return GestureDetector(
                  onTap: () {
                    mapController.animateCamera(
                      CameraUpdate.newLatLng(
                        LatLng(challenge['lat'], challenge['lng']),
                      ),
                    );
                  },
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(challenge['name'].toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text('현재 참여: ${challenge['current']}/${challenge['max']}', style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 5),
                        Text(challenge['location'].toString(), style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}
