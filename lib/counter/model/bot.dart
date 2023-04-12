import 'dart:async';
import 'dart:developer';

import 'package:mcd/counter/counter.dart';

class Bot {
  Timer? timer;
  Order? order;
  // ignore: sort_constructors_first
  Bot({
    this.timer,
    this.order,
  });

  String get status  => order?.id == null ? 'IDLE' : 'Active';

}
