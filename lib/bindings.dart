import 'action_typedefs.dart';
import 'actions_command.dart';
import 'actions_find.dart';
import 'actions_insert.dart';
import 'actions_motion.dart';
import 'actions_normal.dart';
import 'actions_operator.dart';
import 'motion.dart';

const normalActions = <String, NormalFn>{
  'q': NormalActions.quit,
  'Q': NormalActions.quitWithoutSaving,
  'S': NormalActions.substituteLine,
  's': NormalActions.save,
  'x': NormalActions.deleteCharNext,
  'i': NormalActions.insert,
  'a': NormalActions.appendCharNext,
  'A': NormalActions.appendLineEnd,
  'I': NormalActions.insertLineStart,
  'o': NormalActions.openLineBelow,
  'O': NormalActions.openLineAbove,
  'r': NormalActions.replace,
  'D': NormalActions.deleteLineEnd,
  'p': NormalActions.pasteAfter,
  'P': NormalActions.pasteBefore,
  '\u0004': NormalActions.moveDownHalfPage,
  '\u0015': NormalActions.moveUpHalfPage,
  'J': NormalActions.joinLines,
  'C': NormalActions.changeLineEnd,
  'u': NormalActions.undo,
  '.': NormalActions.repeat,
  ';': NormalActions.repeatFindNext,
  'n': NormalActions.findNext,
  '\u0001': NormalActions.increase,
  '\u0018': NormalActions.decrease,
  ':': NormalActions.command,
  '/': NormalActions.search,
};

const operatorActions = <String, OperatorFn>{
  'c': Operators.change,
  'd': Operators.delete,
  'y': Operators.yank,
};

const motionActions = <String, Motion>{
  'h': NormalMotion(Motions.charPrev),
  'l': NormalMotion(Motions.charNext),
  ' ': NormalMotion(Motions.charNext),
  'k': NormalMotion(Motions.lineUp, linewise: true),
  'j': NormalMotion(Motions.lineDown, linewise: true),
  'w': NormalMotion(Motions.wordNext),
  'W': NormalMotion(Motions.wordCapNext),
  'b': NormalMotion(Motions.wordPrev),
  'B': NormalMotion(Motions.wordCapPrev),
  'e': NormalMotion(Motions.wordEnd),
  'ge': NormalMotion(Motions.wordEndPrev),
  '#': NormalMotion(Motions.sameWordPrev),
  '*': NormalMotion(Motions.sameWordNext),
  '0': NormalMotion(Motions.lineStart),
  '^': NormalMotion(Motions.firstNonBlank),
  '\$': NormalMotion(Motions.lineEnd, inclusive: false),
  'gg': NormalMotion(Motions.fileStart, linewise: true),
  'G': NormalMotion(Motions.fileEnd, linewise: true),
  'f': FindMotion(Find.findNextChar),
  'F': FindMotion(Find.findPrevChar),
  't': FindMotion(Find.tillNextChar),
  'T': FindMotion(Find.tillPrevChar),
};

const insertActions = <String, InsertFn>{
  '\x7f': InsertActions.backspace,
  '\n': InsertActions.enter,
  '\x1b': InsertActions.escape,
};

const commandActions = <String, CommandFn>{
  '': CommandActions.noop,
  'q': CommandActions.quit,
  'q!': CommandActions.quitWoSaving,
  'w': CommandActions.write,
  'wq': CommandActions.writeAndQuit,
  'x': CommandActions.writeAndQuit,
};

const normalBindings = {
  ...normalActions,
  ...motionActions,
  ...operatorActions,
};

const opBindings = {
  ...operatorActions,
  ...motionActions,
};
