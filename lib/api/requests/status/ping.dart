import 'package:lucky_dart/core/request.dart';

/// Lightweight request used to validate API reachability.
class Ping extends Request {
  /// HTTP method used by this request.
  @override
  String get method => 'GET';

  /// Relative endpoint path used as a connectivity probe.
  @override
  String resolveEndpoint() => '/issues';
}
