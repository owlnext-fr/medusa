import 'package:lucky_dart/lucky_dart.dart';

/// Request model used to create an issue in Mantis.
class CreateIssue extends Request with HasJsonBody {
  /// Issue summary/title.
  final String _summary;

  /// Detailed issue description.
  final String _description;

  /// Mantis project name.
  final String _project;

  /// Mantis category name.
  final String _category;

  /// Mantis severity value.
  final String _severity;

  /// Optional browser metadata.
  final String? _browser;

  /// Optional operating system metadata.
  final String? _os;

  /// Optional device metadata.
  final String? _device;

  /// Optional environment metadata.
  final String? _environment;

  /// Builds a create-issue request payload.
  CreateIssue(
    this._summary,
    this._description,
    this._project,
    this._category,
    this._severity, {
    String? browser,
    String? os,
    String? device,
    String? environment,
  })  : _browser = browser,
        _os = os,
        _device = device,
        _environment = environment;

  /// JSON payload sent to the `/issues` endpoint.
  @override
  Map<String, dynamic> jsonBody() {
    return {
      'summary': _summary,
      'description': _description,
      'project': {'name': _project},
      'category': {'name': _category},
      'priority': {'name': 'none'},
      'severity': {'name': _severity},
      "reproducibility": {"name": "always"},
      "custom_fields": [
        if (_browser != null)
          {
            'field': {'name': 'c_browser'},
            'value': _browser,
          },
        if (_os != null)
          {
            'field': {'name': 'c_os'},
            'value': _os,
          },
        if (_device != null)
          {
            'field': {'name': 'c_device'},
            'value': _device,
          },
        if (_environment != null)
          {
            'field': {'name': 'c_environment'},
            'value': _environment,
          },
      ],
      'tags': [
        {'name': 'from-api'},
      ],
    };
  }

  /// HTTP method used by this request.
  @override
  String get method => 'POST';

  /// Relative endpoint path for issue creation.
  @override
  String resolveEndpoint() => '/issues';
}
