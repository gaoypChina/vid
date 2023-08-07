import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'actions_find.dart';
import 'actions_insert.dart';
import 'actions_motion.dart';
import 'actions_normal.dart';
import 'actions_operator.dart';
import 'actions_replace.dart';
import 'actions_text_objects.dart';
import 'bindings.dart';
import 'characters_render.dart';
import 'config.dart';
import 'esc.dart';
import 'file_buffer.dart';
import 'file_buffer_lines.dart';
import 'file_buffer_view.dart';
import 'modes.dart';
import 'position.dart';
import 'range.dart';
import 'terminal.dart';

class Editor {
  final term = Terminal();
  final file = FileBuffer();
  final buff = StringBuffer();
  String message = '';

  void init(List<String> args) {
    file.load(args);
    term.rawMode = true;
    term.write(Esc.enableAltBuffer(true));
    term.input.listen(onInput);
    term.resize.listen(onResize);
    draw();
  }

  void quit() {
    term.write(Esc.enableAltBuffer(false));
    term.rawMode = false;
    exit(0);
  }

  void onResize(ProcessSignal signal) {
    draw();
  }

  void draw() {
    buff.clear();
    buff.write(Esc.homeAndEraseDown);

    file.clampView(term);

    // draw text lines
    drawTextLines();

    // draw status line
    drawStatusLine();

    // draw cursor
    drawCursor();

    term.write(buff);
  }

  void drawTextLines() {
    final lines = file.lines;
    final view = file.view;
    final lineStart = view.l;
    final lineEnd = view.l + term.height - 1;

    for (int l = lineStart; l < lineEnd; l++) {
      // if no more lines draw '~'
      if (l > lines.length - 1) {
        buff.writeln('~');
        continue;
      }
      // for empty lines draw empty line
      if (lines[l].isEmpty) {
        buff.writeln();
        continue;
      }
      // get substring of line in view based on render width
      final line = lines[l].text.getRenderLine(view.c, term.width);
      buff.writeln(line);
    }
  }

  void drawCursor() {
    final view = file.view;
    final cursor = file.cursor;
    final curlen = file.lines[cursor.l].text.renderLength(cursor.c);
    final curpos = Position(l: cursor.l - view.l + 1, c: curlen - view.c + 1);
    buff.write(Esc.cursorPosition(c: curpos.c, l: curpos.l));
  }

  void drawStatusLine() {
    buff.write(Esc.invertColors(true));
    buff.write(Esc.cursorPosition(c: 1, l: term.height));

    final cursor = file.cursor;
    final modified = file.isModified;
    final filename = file.path ?? '[No Name]';
    final mode = statusModeStr(file.mode);
    final left = ' $mode  $filename ${modified ? '* ' : ''}$message ';
    final right = ' ${cursor.l + 1}, ${cursor.c + 1} ';
    final padLeft = term.width - left.length - 1;
    final status = '$left ${right.padLeft(padLeft)}';

    if (status.length <= term.width - 1) {
      buff.write(status);
    } else {
      buff.write(status.substring(0, term.width));
    }

    buff.write(Esc.invertColors(false));
  }

  String statusModeStr(Mode mode) {
    return switch (mode) {
      Mode.normal => 'NOR',
      Mode.operator => 'PEN',
      Mode.insert => 'INS',
      Mode.replace => 'REP',
    };
  }

  void showMessage(String text, {bool timed = false}) {
    message = text;
    draw();
    if (timed) {
      Timer(Duration(milliseconds: Config.messageTime), () {
        message = '';
        draw();
      });
    }
  }

  void onInput(List<int> codes) {
    input(utf8.decode(codes));
  }

  void input(String char, {bool redraw = true}) {
    switch (file.mode) {
      case Mode.insert:
        insert(char);
      case Mode.normal:
        normal(char);
      case Mode.operator:
        operator(char);
      case Mode.replace:
        replace(char);
    }
    if (redraw) {
      draw();
    }
    message = '';
  }

  void insert(String char) {
    InsertAction? insertAction = insertActions[char];
    if (insertAction != null) {
      insertAction(file);
      return;
    }
    defaultInsert(file, char);
  }

  void normal(String char) {
    // accumulate countInput: if char is a number, add it to countInput
    // if char is not a number, parse countInput and set fileBuffer.count
    final count = int.tryParse(char);
    if (count != null && (count > 0 || file.countInput.isNotEmpty)) {
      file.countInput += char;
      return;
    }
    if (file.countInput.isNotEmpty) {
      file.count = int.parse(file.countInput);
      file.countInput = '';
    }

    // accumulate fileBuffer.input until maxInput is reached and try to match
    // a command in the bindings map
    file.input += char;
    const int maxInput = 2;
    if (file.input.length > maxInput) {
      file.input = char;
    }

    if (file.find != null) {
      file.cursor = file.find!(file, file.cursor, char, false);
      file.find = null;
      file.input = '';
      return;
    }
    FindAction? findAction = findActions[file.input];
    if (findAction != null) {
      file.find = findAction;
      file.input = '';
      return;
    }

    NormalAction? normalAtion = normalActions[file.input];
    if (normalAtion != null) {
      normalAtion(this, file);
      file.input = '';
      file.count = null;
      return;
    }

    OperatorAction? operator = operatorActions[file.input];
    if (operator != null) {
      file.input = '';
      file.count = null;
      file.mode = Mode.operator;
      file.operator = operator;
    }
  }

  void operator(String char) {
    OperatorAction? operator = file.operator;
    if (operator == null) {
      return;
    }

    if (file.find != null) {
      Position end = file.find!(file, file.cursor, char, true);
      Range range = Range(start: file.cursor, end: end);
      operator(file, range);
      file.find = null;
      return;
    }

    FindAction? findAction = findActions[char];
    if (findAction != null) {
      file.find = findAction;
      return;
    }

    TextObject? textObject = textObjects[char];
    if (textObject != null) {
      Range range = textObject(file, file.cursor);
      operator(file, range);
      return;
    }

    Motion? motion = motionActions[char];
    if (motion != null) {
      Position end = motion(file, file.cursor);
      Range range = Range(start: file.cursor, end: end);
      operator(file, range);
      return;
    }
  }

  void replace(String char) {
    defaultReplace(file, char);
  }
}
