import 'dart:ui';

import 'package:carive/services/auth.dart';
import 'package:carive/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HostYourCars extends StatefulWidget {
  HostYourCars({Key? key}) : super(key: key);

  @override
  State<HostYourCars> createState() => _HostYourCarsState();
}

class _HostYourCarsState extends State<HostYourCars> {
  AuthService auth = AuthService();

  late String userId;
  @override
  void initState() {
    super.initState();
    userId = auth.auth.currentUser?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('cars')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final cars = snapshot.data!.docs;

          if (cars.isEmpty) {
            return const Center(
              child: Text(
                'No cars available.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20),
              itemCount: cars.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final car = cars[index].data() as Map<String, dynamic>;
                final carName = car['carModel'] as String;
                final carImage = car['imageUrl'];
                final carLocation = car['location'];
                final carPrice = car['amount'];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      height: 400,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.white60.withOpacity(0.13),
                              Colors.white10
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              height: 130,
                              width: 170,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  carImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  carName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Container(
                                        width: 10,
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.green,
                                        )),
                                    const Text(
                                      "Available",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/map-marker.png',
                                  width: 15,
                                ),
                                wSizedBox10,
                                Text(carLocation,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15))
                              ],
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "₹${carPrice}",
                                        style:
                                            TextStyle(color: themeColorGreen),
                                      ),
                                      const Text(
                                        "/day",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Error fetching car data.',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
