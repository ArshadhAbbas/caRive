import 'dart:ui';

import 'package:carive/screens/host/new_or_edit_cars_screen/new_or_edit_cars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:carive/screens/home/car_details/car_details.dart';
import 'package:carive/shared/constants.dart';

// ignore: must_be_immutable
class TransluscentCard extends StatelessWidget {
  TransluscentCard(
      {super.key,
      required this.carId,
      required this.brand,
      required this.model,
      required this.price,
      required this.location,
      required this.image,
      required this.modelYear,
      required this.seatCapacity,
      required this.fuelType,
      required this.ownerId,
      required this.isAvailable,
      required this.ownerFcmToken,
      required this.latitude,
      required this.longitude});
  String carId;
  String brand;
  String model;
  int price;
  String location;
  String image;
  String fuelType;
  String modelYear;
  String seatCapacity;
  String ownerId;
  bool isAvailable;
  double latitude;
  double longitude;
  String ownerFcmToken;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final isCurrentUserOwner = user != null && user.uid == ownerId;
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white60.withOpacity(0.13), Colors.white10],
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        model,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: 10,
                            child: CircleAvatar(
                              backgroundColor:
                                  isAvailable ? Colors.green : Colors.red,
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          isAvailable ? "Available" : "Unavailable",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/map-marker.png',
                        width: 15,
                      ),
                      wSizedBox10,
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "₹$price",
                            style: TextStyle(color: themeColorGreen),
                          ),
                          const Text(
                            "/day",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      !isCurrentUserOwner
                          ? Expanded(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xFF198396)),
                                ),
                                child: const Text("Explore",
                                    overflow: TextOverflow.clip, maxLines: 1),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CarDetails(
                                        latitude: latitude,
                                        longitude: longitude,
                                        carId: carId,
                                        brand: brand,
                                        image: image,
                                        location: location,
                                        model: model,
                                        price: price,
                                        modelYear: modelYear,
                                        seatCapacity: seatCapacity,
                                        fuelType: fuelType,
                                        ownerId: ownerId,
                                        isAvailable: isAvailable,
                                        ownerFcmToken: ownerFcmToken),
                                  ));
                                },
                              ),
                            )
                          : ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFF198396)),
                              ),
                              child: const Text("Edit"),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return NewOrEditCarScreen(
                                    actionType: ActionType.editCar,
                                    isAvailable: isAvailable,
                                    latitude: latitude,
                                    longitude: longitude,
                                    carId: carId,
                                    selectedMake: brand,
                                    image: image,
                                    location: location,
                                    selectedCarModel: model,
                                    amount: price,
                                    modelYear: modelYear,
                                    selectedSeatCapacity: seatCapacity,
                                    selectedFuel: fuelType,
                                  );
                                }));
                              },
                            )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
