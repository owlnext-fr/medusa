import 'package:medusa/api/mantis_api.dart';
import 'package:medusa/api/requests/status/ping.dart';

/// Endpoint group for status and health-check operations.
class StatusEndpoint {
  /// Parent API connector used to send requests.
  final MantisApi _api;

  /// Creates a new status endpoint wrapper.
  StatusEndpoint(this._api);

  /// Performs a basic connectivity check against the API.
  ///
  /// Returns `true` when the endpoint responds with a successful status code.
  Future<bool> ping() async {
    final response = await _api.send(Ping());
    return response.isSuccessful;
  }
}
