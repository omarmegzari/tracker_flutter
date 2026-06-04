// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracker_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(vehicles)
final vehiclesProvider = VehiclesProvider._();

final class VehiclesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Vehicle>>,
          List<Vehicle>,
          Stream<List<Vehicle>>
        >
    with $FutureModifier<List<Vehicle>>, $StreamProvider<List<Vehicle>> {
  VehiclesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vehiclesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vehiclesHash();

  @$internal
  @override
  $StreamProviderElement<List<Vehicle>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Vehicle>> create(Ref ref) {
    return vehicles(ref);
  }
}

String _$vehiclesHash() => r'e4627e7019a9671bd4de89db7d7e9db0cc168ce4';

@ProviderFor(fuelEntries)
final fuelEntriesProvider = FuelEntriesProvider._();

final class FuelEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FuelEntry>>,
          List<FuelEntry>,
          Stream<List<FuelEntry>>
        >
    with $FutureModifier<List<FuelEntry>>, $StreamProvider<List<FuelEntry>> {
  FuelEntriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fuelEntriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fuelEntriesHash();

  @$internal
  @override
  $StreamProviderElement<List<FuelEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<FuelEntry>> create(Ref ref) {
    return fuelEntries(ref);
  }
}

String _$fuelEntriesHash() => r'f1b52de11364f21c9ae9e4c5a4ac0ab5dfd8d135';

@ProviderFor(maintenances)
final maintenancesProvider = MaintenancesProvider._();

final class MaintenancesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Maintenance>>,
          List<Maintenance>,
          Stream<List<Maintenance>>
        >
    with
        $FutureModifier<List<Maintenance>>,
        $StreamProvider<List<Maintenance>> {
  MaintenancesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maintenancesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maintenancesHash();

  @$internal
  @override
  $StreamProviderElement<List<Maintenance>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Maintenance>> create(Ref ref) {
    return maintenances(ref);
  }
}

String _$maintenancesHash() => r'1f32579290a99e8eae14c32d08706d3033737519';

@ProviderFor(TrackerController)
final trackerControllerProvider = TrackerControllerProvider._();

final class TrackerControllerProvider
    extends $AsyncNotifierProvider<TrackerController, void> {
  TrackerControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackerControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackerControllerHash();

  @$internal
  @override
  TrackerController create() => TrackerController();
}

String _$trackerControllerHash() => r'7d80936acd4075d5f2c8bc255623c866ff5e5319';

abstract class _$TrackerController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
