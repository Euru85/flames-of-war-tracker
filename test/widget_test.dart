import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flames_of_war_tracker/main.dart';
import 'package:flames_of_war_tracker/providers/battle_provider.dart';

void main() {
  testWidgets('App launches and shows home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => BattleProvider(),
        child: const FlamesOfWarApp(),
      ),
    );
    expect(find.text('FLAMES OF WAR'), findsOneWidget);
  });
}
