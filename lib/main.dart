import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:winner_casino_test/common/app_lifecycle_observer.dart';
import 'package:winner_casino_test/screens/group_tournaments_screen.dart';
import 'package:winner_casino_test/common/palette.dart';
import 'package:winner_casino_test/common/snack_bar.dart';

import 'models/tournaments_group.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WinnerCasinoApp());
}

class WinnerCasinoApp extends StatelessWidget {
  static final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
          const GroupTournamentsScreen(
            key: Key('group_tournaments'),
          ),
      ),
    ]
  );

  const WinnerCasinoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<TournamentGroupProvider>(
            create: (_) => TournamentGroupProvider(),
          ),
          Provider(
            create: (context) => Palette(),
          ),
        ],
        child: Builder(builder: (context) {
          final palette = context.watch<Palette>();

          return MaterialApp.router(
            title: 'Winner Casino Test',
            theme: ThemeData.from(
              colorScheme: ColorScheme.fromSeed(
                seedColor: palette.darkPen,
                background: palette.background,
              ),
              textTheme: TextTheme(
                bodyText2: TextStyle(
                  color: palette.ink,
                ),
              ),
            ),
            routeInformationParser: _router.routeInformationParser,
            routerDelegate: _router.routerDelegate,
            scaffoldMessengerKey: scaffoldMessengerKey,
          );
        }),
      ),
    );
  }
}
