import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit/media_kit.dart';
import 'package:nippon_tv/pages/home.dart';
import 'package:nippon_tv/pages/player.dart';

Future<void> main() async {
  MediaKit.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Home();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'player',
          builder: (context, state) {
            final url = state.uri.queryParameters['url'];
            final title = state.uri.queryParameters['title'];
            return PlayerWidget(url: url ?? '', title: title ?? '');
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.grey,
        primaryColor: Colors.black,
      ),
      routerConfig: _router,
    );
  }
}
