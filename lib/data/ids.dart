import 'dart:math' as math;

final _rng = math.Random();

/// Time-sortable opaque id: microsecond timestamp (base36) + random suffix.
/// Good enough for a single-device local store; sorts roughly by creation.
String newId() {
  final micros = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  final suffix = _rng.nextInt(1 << 32).toRadixString(36).padLeft(7, '0');
  return '$micros-$suffix';
}
