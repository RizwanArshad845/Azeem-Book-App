/// Keyword-overlap heuristic grader for short-answer questions — no AI
/// grading for this demo. Fraction of the model answer's keywords that
/// also appear in the student's answer, after light stemming and synonym
/// normalization so paraphrased wording (plurals, verb tense, or a
/// same-meaning word) still counts as a match.
class GradeShortAnswerUseCase {
  const GradeShortAnswerUseCase();

  static const Set<String> _stopwords = {
    'a', 'an', 'the', 'is', 'are', 'was', 'were', 'be', 'been', 'being',
    'of', 'in', 'on', 'at', 'to', 'for', 'and', 'or', 'but', 'with', 'as',
    'by', 'that', 'this', 'it', 'its', 'from', 'which', 'can', 'could',
    'should', 'would', 'will', 'shall', 'has', 'have', 'had', 'do', 'does',
    'did', 'not', 'no', 'also', 'into', 'than', 'then', 'so', 'such',
    'these', 'those', 'i', 'you', 'we', 'they', 'their', 'our', 'your',
  };

  /// Word clusters treated as equivalent once stemmed, so a synonym in the
  /// student's answer still matches the model answer's keyword. Each
  /// cluster normalizes to the stem of its first entry.
  static const List<Set<String>> _synonymClusters = [
    {'error', 'bug', 'fault', 'mistake'},
    {'find', 'locate', 'detect'},
    {'fix', 'resolve', 'correct'},
    {'check', 'verify', 'validate'},
    {'create', 'build', 'construct', 'generate'},
    {'important', 'essential', 'vital', 'crucial'},
    {'combine', 'merge', 'integrate'},
    {'allow', 'permit', 'enable'},
    {'protect', 'secure', 'safeguard'},
    {'increase', 'grow', 'rise'},
    {'decrease', 'reduce', 'lower'},
    {'problem', 'issue'},
    {'method', 'technique', 'approach'},
    {'step', 'phase', 'stage'},
    {'fast', 'quick', 'rapid'},
    {'automatic', 'auto'},
  ];

  static final Map<String, String> _synonymCanonical = _buildSynonymCanonical();

  static Map<String, String> _buildSynonymCanonical() {
    final map = <String, String>{};
    for (final cluster in _synonymClusters) {
      final canonical = _stem(cluster.first);
      for (final word in cluster) {
        map[_stem(word)] = canonical;
        // Words like "locate"/"resolve" lose their silent "e" once "-ing"
        // or "-ed" is stripped ("locating" -> "locat"), so register that
        // alias too or the -ing/-ed form won't match the cluster.
        if (word.endsWith('e') && word.length > 3) {
          map[word.substring(0, word.length - 1)] = canonical;
        }
      }
    }
    return map;
  }

  double call({required String studentAnswer, required String modelAnswer}) {
    final modelTokens = _tokenize(modelAnswer);
    if (modelTokens.isEmpty) return 0;

    final studentTokens = _tokenize(studentAnswer);
    if (studentTokens.isEmpty) return 0;

    final overlap = studentTokens.intersection(modelTokens).length;
    return (overlap / modelTokens.length).clamp(0.0, 1.0);
  }

  Set<String> _tokenize(String text) {
    final lower = text.toLowerCase();
    final cleaned = lower.replaceAll(RegExp(r'[^a-z0-9\s]'), ' ');
    return cleaned
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty && !_stopwords.contains(w))
        .map(_normalize)
        .toSet();
  }

  static String _normalize(String word) {
    final stemmed = _stem(word);
    return _synonymCanonical[stemmed] ?? stemmed;
  }

  /// Suffix-stripping stemmer — not full linguistic stemming, just enough
  /// to fold common plural/verb-tense variants (test/tests/tested/testing)
  /// onto the same token so they overlap.
  static String _stem(String word) {
    if (word.length <= 3) return word;
    if (word.endsWith('ies')) {
      return '${word.substring(0, word.length - 3)}y';
    }
    if (word.endsWith('edly') && word.length > 6) {
      return word.substring(0, word.length - 4);
    }
    if (word.endsWith('ing') && word.length > 5) {
      return word.substring(0, word.length - 3);
    }
    if (word.endsWith('ed') && word.length > 4) {
      return word.substring(0, word.length - 2);
    }
    if (word.endsWith('ly') && word.length > 4) {
      return word.substring(0, word.length - 2);
    }
    if (word.endsWith('es') && word.length > 4) {
      return word.substring(0, word.length - 2);
    }
    if (word.endsWith('s') && !word.endsWith('ss') && word.length > 3) {
      return word.substring(0, word.length - 1);
    }
    return word;
  }
}
