import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:azeem_book_app/core/storage/local_cache_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalCacheService cache;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    cache = LocalCacheService(prefs: prefs);
  });

  test('set and get object from cache', () async {
    await cache.set('user', {'id': '123', 'name': 'Ahmed'});

    final result = cache.get('user', (json) => json['name'] as String);
    expect(result, 'Ahmed');
  });

  test('set and getList from cache', () async {
    await cache.set('items', [
      {'id': '1', 'title': 'Item 1'},
      {'id': '2', 'title': 'Item 2'},
    ]);

    final list = cache.getList('items', (json) => json['title'] as String);
    expect(list, ['Item 1', 'Item 2']);
  });

  test('isStale returns true when key missing', () {
    expect(cache.isStale('non_existent'), isTrue);
  });

  test('isStale respects ttl', () async {
    await cache.set('quick', {'foo': 'bar'});
    // Right after setting, not stale with 1 hour ttl
    expect(cache.isStale('quick', ttl: const Duration(hours: 1)), isFalse);
    // Stale with 0 duration
    expect(cache.isStale('quick', ttl: Duration.zero), isTrue);
  });
}
