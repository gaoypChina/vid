import 'action_typedefs.dart';
import 'actions_find.dart';
import 'actions_insert.dart';
import 'actions_motion.dart';
import 'actions_normal.dart';
import 'actions_operator.dart';
import 'actions_text_objects.dart';

final insertActions = <String, InsertFn>{
  '\x1b': InsertActions.escape,
  '\x7f': InsertActions.backspace,
  '\n': InsertActions.enter,
};

final normalActions = <String, NormalFn>{
  'q': NormalActions.quit,
  'Q': NormalActions.quitWithoutSaving,
  's': NormalActions.save,
  'h': NormalActions.cursorCharPrev,
  'l': NormalActions.cursorCharNext,
  'j': NormalActions.cursorCharDown,
  'k': NormalActions.cursorCharUp,
  '\x1b[A': NormalActions.cursorCharUp,
  '\x1b[B': NormalActions.cursorCharDown,
  '\x1b[C': NormalActions.cursorCharNext,
  '\x1b[D': NormalActions.cursorCharPrev,
  'w': NormalActions.cursorWordNext,
  'b': NormalActions.cursorWordPrev,
  'e': NormalActions.cursorWordEnd,
  'x': NormalActions.deleteCharNext,
  '0': NormalActions.cursorLineStart,
  '^': NormalActions.lineFirstNonBlank,
  '\$': NormalActions.cursorLineEnd,
  'i': NormalActions.insert,
  'a': NormalActions.appendCharNext,
  'A': NormalActions.appendLineEnd,
  'I': NormalActions.insertLineStart,
  'o': NormalActions.openLineBelow,
  'O': NormalActions.openLineAbove,
  'G': NormalActions.cursorLineBottomOrCount,
  'gg': NormalActions.cursorLineTopOrCount,
  'ge': NormalActions.cursorWordEndPrev,
  'r': NormalActions.replace,
  'D': NormalActions.deleteLineEnd,
  'p': NormalActions.pasteAfter,
  'P': NormalActions.pasteBefore,
  '\u0004': NormalActions.moveDownHalfPage,
  '\u0015': NormalActions.moveUpHalfPage,
  'J': NormalActions.joinLines,
  'C': NormalActions.changeLineEnd,
  'u': NormalActions.undo,
  '*': NormalActions.sameWordNext,
  '#': NormalActions.sameWordPrev,
  '.': NormalActions.repeat,
  ';': NormalActions.repeatFindNext,
};

final operatorActions = <String, OperatorFn>{
  'c': Operators.change,
  'd': Operators.delete,
  'y': Operators.yank,
};

final textObjectActions = <String, TextObjectFn>{
  'k': TextObjects.lineUp,
  'j': TextObjects.lineDown,
  'g': TextObjects.firstLine,
  'G': TextObjects.lastLine,
};

final motionActions = <String, MotionFn>{
  'h': Motions.charPrev,
  'l': Motions.charNext,
  'j': Motions.charDown,
  'k': Motions.charUp,
  'g': Motions.fileStart,
  'G': Motions.fileEnd,
  'w': Motions.wordNext,
  'b': Motions.wordPrev,
  'e': Motions.wordEnd,
  '0': Motions.lineStart,
  '^': Motions.firstNonBlank,
  '\$': Motions.lineEnd,
  '\x1b': Motions.escape,
};

final findActions = <String, FindFn>{
  'f': Find.findNextChar,
  'F': Find.findPrevChar,
  't': Find.tillNextChar,
  'T': Find.tillPrevChar,
};
