import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/risiko_app.dart';
import 'state/battle_state.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => BattleInputState(), child: const RisikoApp()));
}
