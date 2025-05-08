import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ChallengeList extends StatefulWidget {
  const ChallengeList({super.key});

  @override
  State<ChallengeList> createState() => _ChallengeListState();
}

class _ChallengeListState extends State<ChallengeList> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(37.5665, 126.9780); // 서울 시청 기준
  List<int> joinedChallengeIds = [];
  List<Map<String, dynamic>> challenges = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChallenges();
    loadJoinedChallengeIds();
  }

  Future<void> loadJoinedChallengeIds() async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();
    if (idToken == null) return;

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/user/joined-challenges/'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final ids = data['joined_ids'] as List;
      setState(() {
        joinedChallengeIds = ids.cast<int>();
      });
    } else {
      print('참여 챌린지 ID 목록 불러오기 실패: ${response.body}');
    }

  }

  Future<void> fetchChallenges() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/challenge/list/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final List rawList = data['data'];
      setState(() {
        challenges = rawList.map((c) => {
          'id': c['id'].toString(),
          'name': c['name'],
          'current': c['current_participants'],
          'max': c['max_participants'],
          'location': c['location']['address'],
          'lat': double.tryParse(c['location']['latitude'].toString()) ?? 0.0,
          'lng': double.tryParse(c['location']['longitude'].toString()) ?? 0.0,
        }).toList();
        isLoading = false;
      });
    } else {
      debugPrint("서버 오류: ${response.statusCode}");
    }
  }


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('현재 진행 중인 챌린지')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const SizedBox(height: 10),
          Container(
            height: 250,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: _center, zoom: 14.0),
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
                final isJoined = joinedChallengeIds.contains(int.parse(challenge['id']));

                return GestureDetector(
                  onTap: () {
                    context.push(
                      '/challengedetail/${challenge['id']}',
                      extra: {'isJoined': isJoined},
                    );
                  },
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isJoined ? Colors.grey : const Color(0xFF8AB78A),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          challenge['name'].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '현재 참여: ${challenge['current']}/${challenge['max']}',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          challenge['location'].toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        if (isJoined)
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Icon(Icons.check_circle, color: Colors.white, size: 20),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )

        ],
      ),

      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}