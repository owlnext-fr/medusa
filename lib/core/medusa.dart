import 'dart:typed_data';

import 'package:medusa/api/mantis_api.dart';

/// High-level Medusa facade used to interact with the Mantis backend.
///
/// This class wraps the lower-level API client and exposes a simple surface
/// for the most common operations:
/// - checking API reachability with [ping]
/// - creating an issue with an attached screenshot via [createIssue]
///
/// [Medusa] uses a singleton instance. Each call to the factory constructor
/// reconfigures the same underlying instance and returns it.
class Medusa {
  /// Mantis API client used for all operations.
  late MantisApi _api;

  late String _project;
  late String _category;
  bool isInitialized = false;

  /// Returns the singleton [Medusa] instance and configures its API client.
  ///
  /// Use this constructor once at startup (or when reconfiguration is needed)
  /// to provide credentials and optional metadata propagated to issue creation.
  ///
  /// Parameters:
  /// - [baseUrl]: base URL of the Mantis API.
  /// - [token]: authentication token used for API calls.
  /// - [project]: Mantis project name where issues will be created.
  /// - [category]: Mantis category name assigned to created issues.
  /// - [browser], [os], [device], [environment]: optional context metadata.
  /// - [debugCallback]: optional callback invoked by the connector in debug
  ///   mode.
  static void initialize({
    required String baseUrl,
    required String token,
    required String project,
    required String category,
    String? browser,
    String? os,
    String? device,
    String? environment,
    DebugCallback? debugCallback,
  }) {
    _instance._project = project;
    _instance._category = category;
    _instance._api = MantisApi(
      baseUrl,
      token,
      browser: browser,
      os: os,
      device: device,
      environment: environment,
      debugCallback: debugCallback,
    );

    _instance.isInitialized = true;
  }

  static bool get getIsInitialized {
    return _instance.isInitialized;
  }

  /// Performs a connectivity check against the Mantis API.
  ///
  /// Returns `true` when the API responds successfully.
  static Future<bool> ping() => _instance._api.status.ping();

  /// Creates a new issue and attaches a screenshot to it.
  ///
  /// The method first creates the issue, then uploads [fileData] as
  /// `screenshot.png` on the created issue.
  ///
  /// Parameters:
  /// - [path]: the app path where the issue occurred, included in the issue description.
  /// - [summary]: short issue title.
  /// - [issueDescription]: detailed issue description.
  /// - [stepToReproduce]: optional steps to reproduce the issue, included in the issue description.
  /// - [expectedBehavior]: optional expected behavior, included in the issue description.
  /// - [severity]: severity value expected by Mantis.
  /// - [fileData]: screenshot bytes to attach.
  ///
  /// Returns the created issue id.
  ///
  /// Throws an [Exception] if the attachment step fails.
  ///
  /// Note: although [fileData] is typed as nullable in the current API, this
  /// implementation requires a non-null value at runtime.
  static Future<int> createIssue({
    required String path,
    required String summary,
    required String issueDescription,
    required String? stepToReproduce,
    required String? expectedBehavior,
    required String severity,
    required Uint8List? fileData,
  }) async {
    Map<String, dynamic> postResponse = await _instance._api.issues.create(
      summary: summary,
      description:
          "Description:\n$issueDescription\n\n---\n\nPath: $path\n\n---\n\nStep to Reproduce:\n$stepToReproduce\n\n---\n\nExpected Behavior:\n$expectedBehavior",
      project: _instance._project,
      category: _instance._category,
      severity: severity,
    );

    final issueId = postResponse["issue"]['id'].toString();

    bool attachmentResponse = await _instance._api.issues.attachFile(
      issueId,
      'screenshot.png',
      fileData!,
    );

    if (attachmentResponse) {
      return int.parse(issueId);
    } else {
      throw Exception('Failed to attach file to issue $issueId');
    }
  }

  /// Internal singleton instance.
  static final Medusa _instance = Medusa._internal();

  /// Private constructor used by the singleton pattern.
  Medusa._internal();
}
