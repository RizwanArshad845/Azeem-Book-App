/// What the student was last doing, for Home's "Continue where you left off"
/// card. Local-only UX state (never synced to the backend), so a plain
/// immutable class rather than a `freezed` schema entity.
enum LastActivityKind { subjectHub, test, ebook }

class LastActivity {
  const LastActivity({
    required this.kind,
    required this.subjectId,
    required this.recordedAt,
    this.subjectName,
    this.testId,
    this.testTitle,
    this.chapterId,
    this.offline = false,
  });

  final LastActivityKind kind;
  final String subjectId;
  final DateTime recordedAt;

  /// Raw (un-localized) subject name when the caller knew it.
  final String? subjectName;

  /// Set for [LastActivityKind.test].
  final String? testId;
  final String? testTitle;
  final String? chapterId;

  /// Set for [LastActivityKind.ebook]: the saved offline copy was open.
  final bool offline;

  Map<String, dynamic> toJson() => {
    'kind': kind.name,
    'subjectId': subjectId,
    'recordedAt': recordedAt.toIso8601String(),
    'subjectName': subjectName,
    'testId': testId,
    'testTitle': testTitle,
    'chapterId': chapterId,
    'offline': offline,
  };

  /// Returns null for anything malformed (e.g. a payload from an older app
  /// version) so a bad cache entry just hides the card.
  static LastActivity? tryFromJson(Map<String, dynamic> json) {
    final kind = LastActivityKind.values
        .where((k) => k.name == json['kind'])
        .firstOrNull;
    final subjectId = json['subjectId'];
    final recordedAt = DateTime.tryParse(json['recordedAt'] as String? ?? '');
    if (kind == null || subjectId is! String || recordedAt == null) {
      return null;
    }
    return LastActivity(
      kind: kind,
      subjectId: subjectId,
      recordedAt: recordedAt,
      subjectName: json['subjectName'] as String?,
      testId: json['testId'] as String?,
      testTitle: json['testTitle'] as String?,
      chapterId: json['chapterId'] as String?,
      offline: json['offline'] == true,
    );
  }
}
