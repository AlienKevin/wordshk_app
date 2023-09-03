import 'dart:io';

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

import 'bridge_generated.dart';

const base = 'wordshk_api';
final path = Platform.isWindows ? '$base.dll' : 'lib$base.so';
late final dylib = loadLibForFlutter(path);
late final api = WordshkApiImpl(dylib);
