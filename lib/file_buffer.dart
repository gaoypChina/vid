import 'package:characters/characters.dart';

import 'modes.dart';
import 'position.dart';

// the file buffer
class FileBuffer {
  // the path to the file
  String? path;

  // the text of the file
  String text = '';

  // always have at least one line with one empty string
  var lines = [Characters.empty];

  // the current cursor position (0 based, in human-readable symbol space as opposed to byte space)
  var cursor = Position();

  // the view offset in the file (0 based, in human-readable symbol space as opposed to byte space)
  var view = Position();

  // the current mode
  var mode = Mode.normal;

  // the pending action to be executed
  Function? pendingAction;

  // the count of the pending action
  int? count;

  // the register to use for the pending action
  String? yankBuffer;

  // if the file has been modified and not saved
  bool isModified = false;
}
