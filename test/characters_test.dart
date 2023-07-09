import 'package:test/test.dart';
import 'package:vid/characters_ext.dart';
import 'package:vid/string_ext.dart';

void main() {
  test('takeWhileLessThanRenderedLength', () {
    expect('abc'.ch.takeWhileLessThanRenderedLength(1).string, 'a');
    expect('abc'.ch.takeWhileLessThanRenderedLength(3).string, 'abc');
    expect('😀😀abc'.ch.takeWhileLessThanRenderedLength(4).string, '😀😀');
  });
  test('skipWhileLessThanRenderedLength', () {
    expect('abc'.ch.skipWhileLessThanRenderedLength(1).string, 'bc');
    expect('abc'.ch.skipWhileLessThanRenderedLength(2).string, 'c');
    expect('abc'.ch.skipWhileLessThanRenderedLength(3).string, '');
    expect('😀😀abc'.ch.skipWhileLessThanRenderedLength(4).string, 'abc');
  });

  test('renderedLength', () {
    expect('abc'.ch.renderedLength(0), 0);
    expect('abc'.ch.renderedLength(2), 2);
    expect('abc'.ch.renderedLength(3), 3);
    expect('😀😀abc'.ch.renderedLength(1), 2);
    expect('😀😀abc'.ch.renderedLength(4), 6);
    expect('😀😀abc'.ch.renderedLength(5), 7);
  });

  test('getRenderLine', () {
    expect('abc'.ch.getRenderLine(0, 1).string, 'a');
    expect('abc'.ch.getRenderLine(0, 3).string, 'abc');
    expect('❤️‍🔥❤️‍🔥ab'.ch.getRenderLine(2, 4).string, '❤️‍🔥ab');
    expect('❤️‍🔥❤️‍🔥ab'.ch.getRenderLine(3, 4).string, ' ab',
        reason: 'replace half emoji at start with space');
    expect('abcd🥹'.ch.getRenderLine(4, 6).string, '🥹');
    expect('abcd🥹'.ch.getRenderLine(5, 6).string, ' ');
  });
}
