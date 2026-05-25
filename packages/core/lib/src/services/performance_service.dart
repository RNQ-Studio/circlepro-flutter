import 'package:firebase_performance/firebase_performance.dart';

/// Service wrapper for Firebase Performance Monitoring.
///
/// Provides custom trace creation and HTTP metric tracking.
class PerformanceService {
  static final FirebasePerformance _performance = FirebasePerformance.instance;

  /// Execute [operation] inside a named performance trace.
  ///
  /// Automatically records success/error status and duration.
  static Future<T> trace<T>(
    String name,
    Future<T> Function() operation,
  ) async {
    final trace = _performance.newTrace(name);
    await trace.start();
    try {
      final result = await operation();
      trace.putAttribute('status', 'success');
      return result;
    } catch (e) {
      trace.putAttribute('status', 'error');
      trace.putAttribute(
        'error',
        e.toString().substring(0, e.toString().length.clamp(0, 100)),
      );
      rethrow;
    } finally {
      await trace.stop();
    }
  }

  /// Create an [HttpMetric] for tracking a network request.
  static HttpMetric createHttpMetric(String url, HttpMethod method) {
    return _performance.newHttpMetric(url, method);
  }
}
