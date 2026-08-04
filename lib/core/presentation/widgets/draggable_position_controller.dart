// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Lets a caller (e.g. a "recentre" button) tell a DraggableFloating to
// reset to its default position, without the caller needing a
// reference to the widget's State.

import 'package:flutter/foundation.dart';

class DraggablePositionController extends ChangeNotifier {
  void reset() => notifyListeners();
}
