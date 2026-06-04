import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/vehicle.dart';
import 'auth_provider.dart';

part 'tracker_provider.g.dart';

@riverpod
Stream<List<Vehicle>> vehicles(Ref ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('vehicles')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Vehicle.fromJson(doc.data(), doc.id))
          .toList());
}

@riverpod
class TrackerController extends _$TrackerController {
  @override
  FutureOr<void> build() {}

  Future<void> addVehicle(String brand, String model, String registration) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('vehicles')
          .add({
        'brand': brand,
        'model': model,
        'registrationNumber': registration,
      });
    });
  }
}
