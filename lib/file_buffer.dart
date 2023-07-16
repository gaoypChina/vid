import 'package:characters/characters.dart';
import 'package:vid/line.dart';

import 'modes.dart';
import 'position.dart';
import 'undo.dart';

// all things related to the file buffer
class FileBuffer {
  // the path to the file
  String? path;

  // the text of the file
  String text = '';

  // text split by '\n' character, created by createLines when text is changed
  var lines = [Line(index: 0, text: Characters.empty)];

  // the cursor position (0 based, in grapheme cluster space)
  var cursor = Position();

  // the view offset (0 based, in grapheme cluster space)
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

  // list of undo operations
  List<UndoOp> undoList = [];
}
