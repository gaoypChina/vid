import 'package:characters/characters.dart';

import 'config.dart';
import 'east_asian_width.dart';
import 'emoji_data.dart';

extension StringExt on String {
  // Shorthand for characters (Characters(this))
  Characters get ch => characters;

  // Try to determine the rendered width of a single character
  int get renderWidth {
    // if the string is empty, return 0
    if (isEmpty) return 0;

    // if the string is a single space, return 1
    if (this == ' ') return 1;

    // if the string is a single tab, return 4 ?
    if (this == '\t') return Config.tabWidth;

    if (codeUnits.contains(0xFE0E)) return 1; // text presentation

    if (codeUnits.contains(0xFE0F)) return 2; // emoji presentation

    if (emojiData.contains(runes.first)) return 2;

    if (eastAsianWidth.contains(runes.first)) return 2;

    return 1;
  }
}
