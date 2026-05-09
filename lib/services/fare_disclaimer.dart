import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Centralised "this fare is calculated by km, may not match BRTA exactly"
/// disclaimer.
///
/// We show it once on first launch (gated by a SharedPreferences flag) and
/// also expose a tappable `info` icon on every fare display so users can
/// re-read it any time.
class FareDisclaimer {
  static const _prefsKey = 'fare_disclaimer_acknowledged_v1';

  static const String titleEn = 'About fare calculation';
  static const String bodyEn =
      'Fares shown in this app are computed using the BRTA per-km rate '
      '(2.53 BDT/km, minimum ৳10) on top of route distances transcribed '
      'from the official fare chart PDF.\n\n'
      'Some pairs may differ slightly from the actual BRTA / bus '
      'conductor fare due to:\n'
      '  • Rounding & per-km rate variance\n'
      '  • Stops not on a transcribed corridor (labelled "Estimated")\n'
      '  • Ongoing operator-specific surcharges\n\n'
      'Please use these figures as a reference only.';

  static const String titleBn = 'ভাড়া হিসাব সম্পর্কে';
  static const String bodyBn =
      'এই অ্যাপের ভাড়া BRTA-এর প্রতি কিলোমিটার রেট (২.৫৩ টাকা/কিমি, '
      'সর্বনিম্ন ১০ টাকা) অনুযায়ী হিসাব করা হয়। দূরত্ব নেওয়া হয়েছে '
      'BRTA অনুমোদিত ভাড়া তালিকা PDF থেকে।\n\n'
      'কিছু রুটে বাস্তব ভাড়ার সঙ্গে সামান্য পার্থক্য থাকতে পারে, '
      'কারণ:\n'
      '  • রাউন্ডিং এবং রেট ভ্যারিয়েশন\n'
      '  • PDF-এ না থাকা স্টপগুলো "Estimated" হিসেবে দেখানো হয়\n'
      '  • অপারেটর-নির্দিষ্ট অতিরিক্ত চার্জ\n\n'
      'অনুগ্রহ করে এটি কেবল রেফারেন্স হিসেবে ব্যবহার করুন।';

  /// Show the disclaimer dialog once on first launch (after Material is up).
  /// Subsequent launches no-op until a future major version bumps `_prefsKey`.
  static Future<void> showOnFirstLaunchIfNeeded(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_prefsKey) ?? false) return;
    if (!context.mounted) return;
    await showDisclaimer(context, dismissible: false, includeAck: true);
    await prefs.setBool(_prefsKey, true);
  }

  /// Show the disclaimer dialog any time (e.g. from an `info` icon tap).
  static Future<void> showDisclaimer(
    BuildContext context, {
    bool dismissible = true,
    bool includeAck = false,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: dismissible,
      builder: (ctx) {
        return AlertDialog(
          title: const Text(titleBn),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bodyBn,
                    style: const TextStyle(height: 1.5, fontSize: 14)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0x101B8A4A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    bodyEn,
                    style: TextStyle(height: 1.4, fontSize: 12.5),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(includeAck ? 'বুঝেছি' : 'ঠিক আছে'),
            ),
          ],
        );
      },
    );
  }
}

/// Compact `(i)` icon button users can tap on any fare display to re-read
/// the disclaimer.
class FareInfoIcon extends StatelessWidget {
  final Color? color;
  final double size;

  const FareInfoIcon({super.key, this.color, this.size = 16});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.outline;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => FareDisclaimer.showDisclaimer(context),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Icon(Icons.info_outline_rounded, size: size, color: c),
      ),
    );
  }
}
