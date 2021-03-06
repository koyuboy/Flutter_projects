import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guidance/src/models/trip.dart';
import 'package:guidance/src/models/user_model.dart';
import 'package:guidance/src/utils/services/user_service.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final UserService userService = UserService();

class TripService {
  Future<bool> doesTripExist(String guideId) async {
    final touristId = _auth.currentUser!.uid;
    final tripList = await FirebaseFirestore.instance.collection('trips').get();
    for (var element in tripList.docs) {
      if (element['guideId'] == guideId && element['touristId'] == touristId) {
        return true;
      }
    }
    return false;
  }

  Future<String> createTrip(String guideId, DateTime goalDate,
      String goalCountry, String goalCity) async {
    late String guideName;
    late String touristName;
    await userService.getUserById(guideId).then((value) {
      guideName = value.name + " " + value.surname;
    });
    await userService.getUserById(_auth.currentUser!.uid).then((value) {
      touristName = value.name + " " + value.surname;
    });
    Trip trip = Trip(
      guideId: guideId,
      goalCountry: goalCountry,
      goalCity: goalCity,
      goalDate: goalDate,
      touristId: _auth.currentUser!.uid.toString(),
      guideName: guideName,
      touristName: touristName,
      guideAcceptance: null,
      touristAcceptance: null,
      lastMessageTime: DateTime.now(),
      lastMessage: '',
    );
    try {
      final result = await FirebaseFirestore.instance
          .collection("trips")
          .add(trip.toJson());
      trip.id = result.id;
      await FirebaseFirestore.instance
          .collection('trips')
          .doc(result.id)
          .update(trip.toJson());
      return result.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<Trip> getTripById(String id) async {
    var collection = FirebaseFirestore.instance.collection('trips');
    var docSnapshot = await collection.doc(id).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      return Trip.fromJson(data!);
    } else {
      throw ("Not found Trip by this ID!");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTrips(
      String userId, String role) {
    if (role == 'UserRole.tourist') {
      return _firestore
          .collection('trips')
          .where('touristId', isEqualTo: userId)
          .snapshots();
    } else {
      return _firestore
          .collection('trips')
          .where('guideId', isEqualTo: userId)
          .snapshots();
    }
  }

  Future<void> updateLastMessageofTrip(
      String tripId, String lastMessage, DateTime lastMessageTime) async {
    try {
      FirebaseFirestore.instance.collection('trips').doc(tripId).update(
          {'lastMessage': lastMessage, 'lastMessageTime': lastMessageTime});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTripDealStatus(
      String tripId, String userId, bool decision) async {
    try {
      UserModel userModel = await userService.getUserById(userId);
      if (userModel.role == "UserRole.guide") {
        FirebaseFirestore.instance
            .collection('trips')
            .doc(tripId)
            .update({'guideAcceptance': decision});
      } else {
        FirebaseFirestore.instance
            .collection('trips')
            .doc(tripId)
            .update({'touristAcceptance': decision});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> getTripStatusByTripId(String id) async {
    UserModel userModel = await userService.getUserById(_auth.currentUser!.uid);
    if (userModel.role == "UserRole.guide") {
      var collection = FirebaseFirestore.instance.collection('trips');
      var docSnapshot = await collection.doc(id).get();
      Map<String, dynamic>? dS = docSnapshot.data();
      return dS?['guideAcceptance'];
    } else {
      var collection = FirebaseFirestore.instance.collection('trips');
      var docSnapshot = await collection.doc(id).get();
      Map<String, dynamic>? dS = docSnapshot.data();
      return dS?['touristAcceptance'];
    }
  }
}
