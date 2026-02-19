import 'dart:convert';
import 'dart:typed_data';

import 'package:lucky_dart/lucky_dart.dart';

/// Request model used to attach a file to an existing issue.
class AttachFileToIssue extends Request with HasJsonBody {
  /// Target issue identifier.
  final String issueId;

  /// File name as displayed in Mantis.
  final String fileName;

  /// Raw file bytes to upload.
  final Uint8List fileData;

  /// Creates a file-attachment request for [issueId].
  AttachFileToIssue(this.issueId, this.fileName, this.fileData);

  /// JSON payload containing a base64-encoded file.
  @override
  Map<String, dynamic> jsonBody() {
    String base64File = base64Encode(fileData);

    return {
      'files': [
        {
          'name': fileName,
          'content': base64File,
        }
      ]
    };
  }

  /// HTTP method used by this request.
  @override
  String get method => 'POST';

  /// Relative endpoint path for issue file uploads.
  @override
  String resolveEndpoint() => '/issues/$issueId/files';
}
