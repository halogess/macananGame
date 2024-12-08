// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:macanan_game/components/map/map.dart';
import 'package:macanan_game/components/map/map_widget.dart';
import 'package:macanan_game/components/map/node.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late MapData _mapData;
  String _currentNodeId = 'node_0';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize MapData in didChangeDependencies instead of initState
    _initializeMapData();
  }

  void _initializeMapData() {
    // Use MediaQuery here, which is safe in didChangeDependencies
    final screenSize = MediaQuery.of(context).size;
    setState(() {
      _mapData = MapData(
        screenWidth: screenSize.width,
        screenHeight: screenSize.height,
      );
    });
  }

  void _onNodeTap(MapNode node) {
    setState(() {
      // Hanya izinkan tap pada node yang bisa diakses
      if (node.isAccessible) {
          // Update current node
          _currentNodeId = node.id;
          
          // Update map accessibility based on current node
          _mapData = _mapData.updateNodeAccessibility(_currentNodeId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Macanan Game'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: MapWidget(
            mapData: _mapData,
            currentNodeId: _currentNodeId,
            onNodeTap: _onNodeTap,
          ),
        ),
      ),
    );
  }
}