import 'package:characters/characters.dart';

import 'constants.dart';
import 'file_buffer.dart';
import 'line.dart';

extension FileBufferLines on FileBuffer {
  // split text into lines
  void createLines() {
    // add missing newline
    if (!text.endsWith(nl)) text += nl;

    // split text into lines (remove last empty line)
    final splits = text.split(nl)..removeLast();

    // split text into lines with some metadata used for cursor positioning etc.
    lines.clear();
    int byteStart = 0;
    for (int i = 0; i < splits.length; i++) {
      final Characters lnspc = '${splits[i]} '.characters;
      lines.add(Line(byteStart: byteStart, text: lnspc, lineNo: i));
      byteStart += lnspc.string.length;
    }
  }

  // check if file is empty, only one line with empty string
  bool get empty => lines.length == 1 && lines.first.isEmpty;
}
