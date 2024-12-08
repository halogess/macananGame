import 'package:go_router/go_router.dart';
// import 'package:macanan_game/game/landing_page.dart';
import 'package:macanan_game/views/menu.dart';
import 'package:macanan_game/views/one_macan.dart';

enum AppRoute {
  menu,
  game,
}

GoRouter goRouter(){
  return GoRouter(
    initialLocation: '/menu',
    routes: <RouteBase>[
      GoRoute(
          path: '/game',
          name: AppRoute.game.name,
          builder: (context, state){ return const GameScreen();}
      ),
      GoRoute(
          path: '/menu',
          name: AppRoute.menu.name,
          builder: (context, state){ return const MenuScreen();}
      ),
    ],
  );
}