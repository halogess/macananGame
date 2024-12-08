import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:macanan_game/router.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // play game
                GoRouter.of(context).goNamed(AppRoute.game.name);
              },
              child: const Text("Start Game"),
            ), 
            ElevatedButton(
              onPressed: () {
                // play game
                GoRouter.of(context).goNamed(AppRoute.game.name);
              },
              child: const Text("Start Game"),
            )
          ],
        ),
      ),
    );
  }
}