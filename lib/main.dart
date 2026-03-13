import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/battle_provider.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/deployment_screen.dart';
import 'screens/game_start_screen.dart';
import 'screens/battle_tracker_screen.dart';
import 'screens/summary_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const FlamesOfWarApp());
}

class FlamesOfWarApp extends StatelessWidget {
  const FlamesOfWarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BattleProvider(),
      child: MaterialApp(
        title: 'FoW Battle Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const HomeScreen(),
        routes: {
          '/deployment': (_) => const DeploymentScreen(),
          '/game-start': (_) => const GameStartScreen(),
          '/battle': (_) => const BattleTrackerScreen(),
          '/summary': (_) => const SummaryScreen(),
        },
      ),
    );
  }
}
