import 'package:carive/screens/home/car_details/car_details.dart';
import 'package:carive/services/auth.dart';
import 'package:carive/services/wishlist_service.dart';
import 'package:carive/shared/circular_progress_indicator.dart';
import 'package:carive/shared/constants.dart';
import 'package:carive/shared/custom_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum menuItem { open, remove }

class WishListScreen extends StatefulWidget {
  WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  AuthService auth = AuthService();
  final wishListService = WishListService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String userId;
  @override
  void initState() {
    super.initState();
    userId = auth.auth.currentUser?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data!.data() as Map<String, dynamic>;
          final List<String> wishListedCarsIds =
              List<String>.from(user['wishlistedCars'] ?? []);

          if (wishListedCarsIds.isEmpty) {
            return const Center(
              child: Text(
                'No cars in the wishlist.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('cars')
                .where('carId', whereIn: wishListedCarsIds)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final cars = snapshot.data!.docs;
                if (cars.isEmpty) {
                  return const Center(
                    child: Text(
                      'Your wishList is Empty',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return CustomScaffold(
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFF3E515F),
                          child: Icon(Icons.arrow_back_ios_rounded,
                              color: Colors.white),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      title: const Text("WishList"),
                      centerTitle: false,
                    ),
                    body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              final car =
                                  cars[index].data() as Map<String, dynamic>;
                              final carId = car['carId'];
                              final carName = car['carModel'];
                              final carImage = car['imageUrl'];
                              final carLocation = car['location'];
                              final carMake = car['make'];
                              final fuelType = car['fuelType'];
                              final seatCapacity = car['seatCapacity'];
                              final modelYear = car['modelYear'];
                              final location = car['location'];
                              final amount = car['amount'];
                              final latitude = car['latitude'];
                              final longitude = car['longitude'];
                              final isAvailable = car['isAvailable'];
                              final ownerId = car['userId'];
                              final ownerFcmToken = car['ownerFcmToken'];
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(carImage),
                                ),
                                title: Text(
                                  "$carMake $carName",
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  "$carLocation",
                                  style: TextStyle(color: themeColorblueGrey),
                                ),
                                trailing: PopupMenuButton<menuItem>(
                                  color: Colors.white,
                                  onSelected: (value) async {
                                    if (value == menuItem.open) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => CarDetails(
                                            latitude: latitude,
                                            longitude: longitude,
                                            carId: carId,
                                            brand: carMake,
                                            image: carImage,
                                            location: location,
                                            model: carName,
                                            price: amount,
                                            modelYear: modelYear,
                                            seatCapacity: seatCapacity,
                                            fuelType: fuelType,
                                            ownerId: ownerId,
                                            isAvailable: isAvailable,
                                            ownerFcmToken: ownerFcmToken),
                                      ));
                                    } else if (value == menuItem.remove) {
                                      await wishListService.removeFromWishList(
                                          _auth.currentUser!.uid, carId);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Car has been removed from wishlist.'),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => [
                                    const PopupMenuItem<menuItem>(
                                      value: menuItem.open,
                                      child: Text('Open'),
                                    ),
                                    const PopupMenuItem<menuItem>(
                                      value: menuItem.remove,
                                      child: Text('Remove from wishlist'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => Divider(),
                            itemCount: cars.length)),
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
                return const CustomProgressIndicator();
              }
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Error fetching user data.',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          return const CustomProgressIndicator();
        }
      },
    );
  }
}
