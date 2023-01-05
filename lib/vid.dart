import 'dart:io';

import 'terminal.dart';
import 'vt100.dart';
import 'vt100_buffer.dart';

enum LineWrapMode { none, char, word }

var term = Terminal();
var vt = VT100Buffer();
var filename = '[No Name]';
var lines = <String>[];
var renderLines = <String>[];
var cx = 0;
var cy = 0;
var lineWrapMode = LineWrapMode.none;

void draw() {
  vt.homeAndErase();

  // draw lines
  for (var i = 0; i < renderLines.length; i++) {
    vt.writeln(renderLines[i]);
  }

  // draw empty lines
  for (var i = renderLines.length; i < term.height - 1; i++) {
    vt.writeln('~');
  }

  // draw status
  drawStatus();

  vt.cursorPosition(x: cx + 1, y: cy + 1);

  term.write(vt);
  vt.clear();
}

void drawStatus() {
  vt.invert(true);
  vt.cursorPosition(x: 1, y: term.height);
  final status =
      ' $filename${'${cy + 1}, ${cx + 1}'.padLeft(term.width - filename.length - 2)} ';
  vt.write(status);
  vt.invert(false);
}

void processLines() {
  renderLines.clear();
  switch (lineWrapMode) {
    // cut lines at terminal width
    case LineWrapMode.none:
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.length < term.width) {
          renderLines.add(line);
        } else {
          renderLines.add(line.substring(0, term.width - 1));
        }
      }
      break;
    // split lines at terminal width
    case LineWrapMode.char:
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.isEmpty) {
          renderLines.add('');
          continue;
        }
        var subLine = line;
        while (subLine.length > term.width - 1) {
          renderLines.add(subLine.substring(0, term.width - 1));
          subLine = subLine.substring(term.width - 1);
        }
        renderLines.add(subLine);
      }
      break;
    case LineWrapMode.word:
      // split lines at term.width using word boundaries (regex) and whitespace
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.isEmpty) {
          renderLines.add('');
          continue;
        }
        var subLine = line;
        while (subLine.length > term.width - 1) {
          final matches = RegExp(r'\w+').allMatches(subLine);
          if (matches.isEmpty) {
            renderLines.add(subLine.substring(0, term.width - 1));
            subLine = subLine.substring(term.width - 1);
            break;
          }
          for (var match in matches) {
            if (match.end > term.width - 1) {
              renderLines.add(subLine.substring(0, match.start));
              subLine = subLine.substring(match.start);
              break;
            }
          }
        }
        renderLines.add(subLine);
      }

      break;
  }
}

void quit() {
  vt.homeAndErase();
  vt.reset();
  term.write(vt);
  vt.clear();
  term.rawMode = false;
  exit(0);
}

void checkCursorBounds() {
  if (cx < 0) cx = 0;
  if (cy < 0) cy = 0;
  if (cy >= renderLines.length) {
    cy = renderLines.length - 1;
  }
  final lineLength = renderLines.isEmpty ? 0 : renderLines[cy].length;
  if (cx >= lineLength) {
    cx = lineLength - 1;
  }
}

void input(codes) {
  final str = String.fromCharCodes(codes);
  switch (str) {
    case 'q':
      quit();
      break;
    case 'j':
      cy++;
      checkCursorBounds();
      break;
    case 'k':
      cy--;
      checkCursorBounds();
      break;
    case 'h':
      cx--;
      checkCursorBounds();
      break;
    case 'l':
      cx++;
      checkCursorBounds();
      break;
    case 'x':
      // delete character at cursor position
      deleteCharacterAtCursorPosition();
      break;
    case 't':
      toggleWordWrap();
      break;
  }
  draw();
}

void deleteCharacterAtCursorPosition() {
  // if empty file, do nothing
  if (lines.length == 1 && lines[cy].isEmpty) {
    return;
  }

  // delete character at cursor position or remove line if empty
  String line = lines[cy];
  if (line.isEmpty) {
    lines.removeAt(cy);
  } else {
    lines[cy] = line.replaceRange(cx, cx + 1, '');
  }

  processLines();
  checkCursorBounds();
}

void toggleWordWrap() {
  if (lineWrapMode == LineWrapMode.none) {
    lineWrapMode = LineWrapMode.char;
  } else if (lineWrapMode == LineWrapMode.char) {
    lineWrapMode = LineWrapMode.word;
  } else {
    lineWrapMode = LineWrapMode.none;
  }
  processLines();
  checkCursorBounds();
}

void resize(signal) {
  processLines();
  checkCursorBounds();
  draw();
}

void loadFile(args) {
  if (args.isEmpty) {
    return;
  }
  filename = args[0];
  final file = File(filename);
  if (!file.existsSync()) {
    print('File not found');
  }
  lines = file.readAsLinesSync();
  processLines();
}

void init(List<String> args) {
  term.rawMode = true;
  term.write(VT100.cursorVisible(true));
  loadFile(args);
  draw();
  term.input.listen(input);
  term.resize.listen(resize);
}
