/// Shared fuzzy stop-name matching used across `BusService`,
/// `TransferService`, and `PdfCorridor.findStop`.
///
/// Plain `String.contains` causes false positives for numbered stops:
/// "Mirpur 1" is a substring of "Mirpur 10", "Mirpur 11", "Mirpur 12", etc.,
/// but those are physically distinct stops a few km apart. This helper does
/// a digit-aware substring match: when the shorter string is contained in
/// the longer one, the boundary characters on either side must not be
/// digits, so "Mirpur 1" no longer matches "Mirpur 10".
library;

bool stopNameMatches(String a, String b) {
  final aa = a.toLowerCase().trim();
  final bb = b.toLowerCase().trim();
  if (aa.isEmpty || bb.isEmpty) return false;
  if (aa == bb) return true;
  if (_containsBoundaryAware(aa, bb)) return true;
  if (_containsBoundaryAware(bb, aa)) return true;
  return false;
}

bool _containsBoundaryAware(String haystack, String needle) {
  final idx = haystack.indexOf(needle);
  if (idx < 0) return false;
  final before = idx == 0 ? null : haystack.codeUnitAt(idx - 1);
  final afterIdx = idx + needle.length;
  final after =
      afterIdx >= haystack.length ? null : haystack.codeUnitAt(afterIdx);
  if (before != null && _isDigit(before)) return false;
  if (after != null && _isDigit(after)) return false;
  // Reject any case where the needle is followed by a token that extends
  // a numeric label (e.g. needle "Mirpur" inside "Mirpur 10" is fine,
  // because the boundary char is a space — not a digit).
  return true;
}

bool _isDigit(int codeUnit) => codeUnit >= 0x30 && codeUnit <= 0x39;
