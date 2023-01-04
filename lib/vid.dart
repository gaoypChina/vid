import 'dart:io';

import 'console.dart';

var c = Console();
var lines = <String>[];
var cx = 4;
var cy = 0;

void quit() {
  c.erase();
  c.reset();
  c.apply();
  c.rawMode(false);
  exit(0);
}

void draw() {
  c.erase();

  // draw lines
  for (var i = 0; i < lines.length; i++) {
    c.append(lines[i]);
    c.append('\n');
  }
  c.cursorMove(x: cx, y: cy);
  c.apply();
}

void input(codes) {
  final str = String.fromCharCodes(codes);
  if (str == 'q') {
    quit();
  }
}

void resize(signal) {
  draw();
}

void load(arguments) {
  if (arguments.isEmpty) {
    return;
  }
  final file = File(arguments[0]);
  if (!file.existsSync()) {
    print('File not found');
  }
  lines = file.readAsLinesSync();
  print(lines);
}

void init(List<String> arguments) {
  c.rawMode(true);
  c.cursorVisible(true);
  load(arguments);
  draw();
  c.input.listen(input);
  c.resize.listen(resize);
}
