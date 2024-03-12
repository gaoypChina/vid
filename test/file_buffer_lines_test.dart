import 'package:test/test.dart';
import 'package:vid/config.dart';
import 'package:vid/file_buffer.dart';
import 'package:vid/file_buffer_lines.dart';

void main() {
  test('createLines', () {
    final f = FileBuffer(text: 'abc\ndef');
    f.createLines(WrapMode.none, 80, 24);
    expect(f.lines.length, 2);
    expect(f.lines[0].str, 'abc ');
    expect(f.lines[1].str, 'def ');
  });

  test('createLines w newline at end', () {
    final f = FileBuffer(text: 'abc\ndef\n');
    f.createLines(WrapMode.none, 80, 24);
    expect(f.lines.length, 2);
    expect(f.lines[0].str, 'abc ');
    expect(f.lines[1].str, 'def ');
  });

  test('createLines with wordwrap', () {
    final f = FileBuffer(text: 'abc def ghi jkl');
    f.createLines(WrapMode.word, 8, 10);
    expect(f.lines.length, 2);
    expect(f.lines[0].str, 'abc def ');
    expect(f.lines[1].str, 'ghi jkl ');
  });

  test('createLines with emoji at end', () {
    final f = FileBuffer(text: 'abc def😀 ghi jkl\n');
    f.createLines(WrapMode.word, 8, 20);
    expect(f.lines.length, 3);
    expect(f.lines[0].str, 'abc ');
    expect(f.lines[1].str, 'def😀 ');
    expect(f.lines[2].str, 'ghi jkl ');
  });

  test('createLines word wrapped use last breakat point', () {
    final f = FileBuffer(text: 'The old bookstore exuded');
    f.createLines(WrapMode.word, 20, 20);
    expect(f.lines.length, 2);
    expect(f.lines[0].str, 'The old bookstore ');
    expect(f.lines[0].start, 0);
    expect(f.lines[0].end, 18);
    expect(f.lines[1].str, 'exuded ');
    expect(f.lines[1].start, 18);
    expect(f.lines[1].end, 25);
  });

  test('no wrap', () {
    final f = FileBuffer(text: 'hei jeg heter Erlend 😀😀😀');
    f.createLines(WrapMode.none, 12, 12);
    expect(f.lines.length, 1);
    expect(f.lines[0].str, 'hei jeg heter Erlend 😀😀😀 ');
  });

  test('word wrap', () {
    final f = FileBuffer(text: 'hei jeg heter Erlend 😀😀😀');
    f.createLines(WrapMode.word, 12, 12);
    expect(f.lines.length, 4);
    expect(f.lines[0].str, 'hei jeg ');
    expect(f.lines[1].str, 'heter ');
    expect(f.lines[2].str, 'Erlend ');
    expect(f.lines[3].str, '😀😀😀 ');
  });

  test('char wrap', () {
    final f = FileBuffer(text: 'hei jeg heter Erlend 😀😀😀');
    f.createLines(WrapMode.char, 12, 12);
    expect(f.lines.length, 3);
    expect(f.lines[0].str, 'hei jeg het');
    expect(f.lines[1].str, 'er Erlend ');
    expect(f.lines[2].str, '😀😀😀 ');
  });
}
