import 'package:lucky_dart/lucky_dart.dart';
import 'package:medusa/api/endpoints/issue_endpoint.dart';
import 'package:medusa/api/endpoints/status_endpoint.dart';

/// Debug callback signature used by [MantisApi].
///
/// The callback is invoked by the underlying connector when debug mode is
/// enabled.
typedef DebugCallback = void Function(
    {Map<String, dynamic>? data, required String event, String? message});

/// API client used to communicate with a Mantis instance.
///
/// This connector centralizes authentication and exposes endpoint groups
/// through [status] and [issues].
class MantisApi extends Connector {
  /// Base URL of the Mantis API.
  final String _baseUrl;

  /// API token used in the `Authorization` header.
  final String _token;

  /// Optional browser metadata sent with issue creation.
  final String? browser;

  /// Optional operating system metadata sent with issue creation.
  final String? os;

  /// Optional device metadata sent with issue creation.
  final String? device;

  /// Optional environment metadata sent with issue creation.
  final String? environment;

  /// Status-related API operations.
  late StatusEndpoint status;

  /// Issue-related API operations.
  late IssueEndpoint issues;

  /// Optional debug callback.
  late DebugCallback? debugCallback;

  /// Creates a new [MantisApi] client.
  ///
  /// [baseUrl] is the Mantis API root URL, and [token] is used for
  /// authenticated requests.
  MantisApi(
    this._baseUrl,
    this._token, {
    this.browser,
    this.os,
    this.device,
    this.environment,
    this.debugCallback,
  }) {
    status = StatusEndpoint(this);
    issues = IssueEndpoint(this);
  }

  /// Resolves the base URL used by the connector.
  @override
  String resolveBaseUrl() => _baseUrl;

  /// Provides header-based authentication with the API token.
  @override
  Authenticator? get authenticator =>
      HeaderAuthenticator('Authorization', _token);

  /// Indicates that this connector uses authentication.
  @override
  bool get useAuth => true;

  /// Enables debug mode when [debugCallback] is provided.
  @override
  bool get debugMode => debugCallback != null;

  /// Exposes the configured debug callback.
  @override
  void Function(
      {Map<String, dynamic>? data,
      required String event,
      String? message})? get onDebug => debugCallback;
}
