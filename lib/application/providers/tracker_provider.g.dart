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
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackerControllerHash();

  @$internal
  @override
  TrackerController create() => TrackerController();
}

String _$trackerControllerHash() => r'454da53cd3e7e6e8bde6389d0ca7ba0c50a84bda';

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
