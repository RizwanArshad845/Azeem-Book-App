import 'dart:async';

import 'package:azeem_book_app/core/providers/connectivity_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeConnectivity implements Connectivity {
  _FakeConnectivity(this.current);

  List<ConnectivityResult> current;
  final controller = StreamController<List<ConnectivityResult>>.broadcast();

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      controller.stream;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => current;
}

void main() {
  late _FakeConnectivity fake;
  late bool reachable;
  late ProviderContainer container;

  Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 10));

  void start() {
    container = ProviderContainer(
      overrides: [
        connectivityServiceProvider.overrideWithValue(fake),
        internetReachabilityProvider.overrideWithValue(() async => reachable),
      ],
    );
    addTearDown(container.dispose);
    container.listen(isOnlineProvider, (_, _) {});
  }

  setUp(() {
    fake = _FakeConnectivity([ConnectivityResult.wifi]);
    reachable = true;
    addTearDown(fake.controller.close);
  });

  test('starts online and stays online while a network is up and reachable',
      () async {
    start();
    expect(container.read(isOnlineProvider), isTrue);
    await settle();
    expect(container.read(isOnlineProvider), isTrue);
  });

  test('goes offline immediately when every network is lost, then recovers',
      () async {
    start();
    await settle();

    fake.current = [ConnectivityResult.none];
    fake.controller.add([ConnectivityResult.none]);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(isOnlineProvider), isFalse);

    fake.current = [ConnectivityResult.mobile];
    fake.controller.add([ConnectivityResult.mobile]);
    await settle();
    expect(container.read(isOnlineProvider), isTrue);
  });

  test('is offline when an interface is up but the internet is unreachable',
      () async {
    reachable = false; // e.g. Wi-Fi with no uplink
    start();
    await settle();
    expect(container.read(isOnlineProvider), isFalse);
  });

  test('starts offline if there is no network at launch', () async {
    fake.current = [ConnectivityResult.none];
    start();
    await settle();
    expect(container.read(isOnlineProvider), isFalse);
  });

  test('recheck() re-reads both signals', () async {
    start();
    await settle();

    reachable = false;
    await container.read(isOnlineProvider.notifier).recheck();
    expect(container.read(isOnlineProvider), isFalse);

    reachable = true;
    await container.read(isOnlineProvider.notifier).recheck();
    expect(container.read(isOnlineProvider), isTrue);
  });
}
