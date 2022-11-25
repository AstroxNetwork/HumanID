import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useDelay(VoidCallback callback, Duration delay) {
  final ref = useRef(callback);
  useEffect(() {
    final timer = Timer.periodic(delay, (timer) {
      ref.value();
      timer.cancel();
    });
    return timer.cancel;
  }, [delay]);
}
