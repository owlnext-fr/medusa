import 'package:flutter/foundation.dart';
import 'package:medusa/api/mantis_api.dart';
import 'package:medusa/api/requests/issues/attach_file_to_issue.dart';
import 'package:medusa/api/requests/issues/create_issue.dart';

/// Endpoint group handling issue-related operations.
class IssueEndpoint {
  /// Parent API connector used to send requests.
  final MantisApi _api;

  /// Creates a new issue endpoint wrapper.
  IssueEndpoint(this._api);

  /// Creates a new issue in Mantis.
  ///
  /// Returns the response JSON map when the operation succeeds.
  /// Throws an [Exception] when the API call fails.
  Future<Map<String, dynamic>> create({
    required String summary,
    required String description,
    required String project,
    required String category,
    required String severity,
  }) async {
    final response = await _api.send(CreateIssue(
      summary,
      description,
      project,
      category,
      severity,
      browser: _api.browser,
      os: _api.os,
      device: _api.device,
      environment: _api.environment,
    ));

    if (response.isSuccessful) {
      return response.json();
    } else {
      throw Exception('Failed to create issue: ${response.statusCode}');
    }
  }

  /// Attaches a file to an existing issue.
  ///
  /// Returns `true` when the upload succeeds.
  /// Throws an [Exception] when the API call fails.
  Future<bool> attachFile(
      String issueId, String fileName, Uint8List fileData) async {
    final response =
        await _api.send(AttachFileToIssue(issueId, fileName, fileData));

    if (response.isSuccessful) {
      return true;
    } else {
      throw Exception('Failed to add attachment: ${response.statusCode}');
    }
  }
}
