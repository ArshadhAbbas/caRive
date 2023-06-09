import 'package:cloud_firestore/cloud_firestore.dart';

class WishListService {
  final CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection("users");
  Future<void> addToWishList(String uid, String carId) async {
    try {
      await userCollectionReference.doc(uid).update({
        "wishlistedCars": FieldValue.arrayUnion([carId]),
      });
    } catch (e) {
      print("An error occurred while adding the car to wishList: $e");
      throw e;
    }
  }

  Future<void> removeFromWishList(String uid, String carId) async {
    try {
      await userCollectionReference.doc(uid).update({
        "wishlistedCars": FieldValue.arrayRemove([carId]),
      });
    } catch (e) {
      print("An error occurred while removing the post: $e");
      throw e;
    }
  }
}
