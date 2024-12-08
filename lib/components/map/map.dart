// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:macanan_game/components/map/node.dart';

class MapData {
  final double screenWidth;
  final double screenHeight;
  final List<MapNode> nodes;

  MapData(
      {required this.screenWidth,
      required this.screenHeight,
      List<MapNode>? nodes})
      : nodes = nodes ?? _generateMapNodes(screenWidth, screenHeight);

  // Get a node by its ID
  MapNode? getNodeById(String nodeId) {
    return nodes.firstWhere((node) => node.id == nodeId);
  }

  // Mendapatkan semua node yang terhubung langsung dengan currentNodeId
  List<MapNode> getConnectedNodes(String currentNodeId) {
    final currentNode = nodes.firstWhere((node) => node.id == currentNodeId);

    return nodes
        .where((n) => currentNode.connections
            .any((connection) => connection.targetNodeId == n.id))
        .toList();
  }

  // Update node accessibility based on game logic
  MapData updateNodeAccessibility(String currentNodeId) {
    // Dapatkan node-node yang terhubung langsung
    final connectedNodes =
        getConnectedNodes(currentNodeId).map((node) => node.id).toSet();

    // Perbarui properti isAccessible pada node-node yang relevan
    final updatedNodes = nodes.map((node) {
      final isAccessible =
          node.id == currentNodeId || connectedNodes.contains(node.id);
      return node.copyWith(isAccessible: isAccessible);
    }).toList();

    return MapData(
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      nodes: updatedNodes,
    );
  }

  static bool _checkRowCol(int row, int col) {
    if (row == 2 && col == 1) return false;
    if (row == 1 && col == 2) return false;

    if (row == 4 && col == 1) return false;
    if (row == 5 && col == 2) return false;

    if (row == 1 && col == 8) return false;
    if (row == 2 && col == 9) return false;

    if (row == 5 && col == 8) return false;
    if (row == 4 && col == 9) return false;

    return true;
  }

  static List<MapNode> _generateMapNodes(double width, double height) {
    final List<MapNode> nodes = [];

    // Hitung ukuran jarak titik
    final double nodeSize = min(width / 11, height / 6);

    int nodeIndex = 0;
    for (int row = 1; row < 6; row++) {
      for (int col = 1; col < 10; col++) {
        if (_checkRowCol(row, col)) {
          final x = (col * nodeSize);
          final y = (row * nodeSize);
          final id = 'node_$nodeIndex';

          nodes
              .add(MapNode(id: id, position: Offset(x, y), row: row, col: col));
          nodeIndex++;
        }
      }
    }
    _createConnections(nodes);
    return nodes;
  }

  static List<int> addDirection(String key) {
    if (key == "atas") {
      return [-1, 0];
    } else if (key == "bawah") {
      return [1, 0];
    } else if (key == "kanan") {
      return [0, 1];
    } else if (key == "kiri") {
      return [0, -1];
    } else if (key == "atas-kiri") {
      return [-1, -1];
    } else if (key == "bawah-kiri") {
      return [1, -1];
    } else if (key == "atas-kanan") {
      return [-1, 1];
    } else if (key == "bawah-kanan") {
      return [1, 1];
    } else if (key == "2bawah") {
      return [2, 0];
    } else if (key == "2atas") {
      return [-2, 0];
    } else {
      // Handle cases where the key is not recognized
      print("Key tidak dikenal: $key");
    }
    return [];
  }

  static void _createConnections(List<MapNode> nodes) {
    // Membuat map untuk mempercepat pencarian node berdasarkan posisi
    final nodeMap = {
      for (var node in nodes) '${node.row}_${node.col}': node,
    };

    for (int i = 0; i < nodes.length; i++) {
      // Reset connections untuk setiap node
      nodes[i] = nodes[i].copyWith(connections: []);

      // Ambil informasi baris dan kolom dari node saat ini
      final currentNode = nodes[i];
      final row = currentNode.row;
      final col = currentNode.col;
      final currentKey = '${row}_$col';

      // Tetangga default dalam 4 arah
      List<List<int>> directions = [];
      directions.add(addDirection('atas'));
      directions.add(addDirection('bawah'));

      if (col != 2 && col != 8) {
        if ((row == 2 && col == 3) ||
            (row == 4 && col == 3) ||
            (row == 2 && col == 7) ||
            (row == 4 && col == 7)) {
          continue;
        }
        directions.add(addDirection('kiri'));
        directions.add(addDirection('kanan'));
      }

      if ((row == 1 && col == 1) || (row == 1 && col == 9)) {
        directions.add(addDirection('2bawah'));
      }

      if ((row == 5 && col == 1) || (row == 5 && col == 9)) {
        directions.add(addDirection('2atas'));
      }

      if ((row == 3 && col == 1) || (row == 3 && col == 9)) {
        directions.add(addDirection('2atas'));
        directions.add(addDirection('2bawah'));
      }

      if ((row == 1 && col == 1) ||
          (row == 2 && col == 2) ||
          (row == 3 && col == 7) ||
          (row == 4 && col == 8)) {
        directions.add(addDirection('bawah-kanan'));
      }

      if ((row == 5 && col == 1) ||
          (row == 4 && col == 2) ||
          (row == 3 && col == 7) ||
          (row == 2 && col == 8)) {
        directions.add(addDirection('atas-kanan'));
      }

      // Node lainnya mengikuti aturan umum
      // Tambahkan arah diagonal jika termasuk node aktif
      if (['2_4', '2_6', '4_4', '4_6'].contains(currentKey)) {
        directions.add(addDirection('atas-kiri'));
        directions.add(addDirection('atas-kanan'));
        directions.add(addDirection('bawah-kiri'));
        directions.add(addDirection('bawah-kanan'));
      }

      // Iterasi semua arah untuk membuat koneksi
      for (var dir in directions) {
        final neighborRow = row + dir[0];
        final neighborCol = col + dir[1];

        // Cari tetangga di nodeMap
        final neighborKey = '${neighborRow}_$neighborCol';
        if (nodeMap.containsKey(neighborKey)) {
          final neighborNode = nodeMap[neighborKey]!;

          // Tentukan arah koneksi
          String direction = _determineDirection(dir);

          // Tambahkan koneksi dua arah
          nodes[i] = nodes[i].addConnection(MapConnection(
              targetNodeId: neighborNode.id, direction: direction));
        }
      }

      for (var node in nodes) {
        for (var conn in node.connections) {
          // Tangani kemungkinan node tidak ditemukan
          MapNode? connNode;
          try {
            connNode = nodes.firstWhere((item) => item.id == conn.targetNodeId);
          } catch (e) {
            print('Node tidak ditemukan untuk koneksi: ${conn.targetNodeId}');
            continue;
          }

          // Cek apakah koneksi balik sudah ada
          bool hasReverseConnection = false;
          try {
            connNode.connections
                .firstWhere((item) => item.targetNodeId == node.id);
            hasReverseConnection = true;
          } catch (e) {
            hasReverseConnection = false;
          }

          // Jika belum ada koneksi balik, tambahkan
          if (!hasReverseConnection) {
            connNode = connNode.addConnection(MapConnection(
                targetNodeId: node.id,
                direction: _getOppositeDirection(conn.direction)));

            // Update node di list nodes
            int index = nodes.indexWhere((item) => item.id == connNode!.id);
            if (index != -1) {
              nodes[index] = connNode;
            }
          }
        }
      }
    }
  }

  // Helper method to determine direction based on row and col changes
  static String _determineDirection(List<int> dir) {
    if (dir[0] == -1 && dir[1] == 0) return 'up';
    if (dir[0] == 1 && dir[1] == 0) return 'down';
    if (dir[0] == 0 && dir[1] == 1) return 'right';
    if (dir[0] == 0 && dir[1] == -1) return 'left';
    if (dir[0] == -1 && dir[1] == -1) return 'up-left';
    if (dir[0] == -1 && dir[1] == 1) return 'up-right';
    if (dir[0] == 1 && dir[1] == -1) return 'down-left';
    if (dir[0] == 1 && dir[1] == 1) return 'down-right';
    if (dir[0] == 2 && dir[1] == 0) return 'down';
    if (dir[0] == -2 && dir[1] == 0) return 'up';
    return 'unknown';
  }

  // Helper method to get the opposite direction
  static String _getOppositeDirection(String direction) {
    switch (direction) {
      case 'up':
        return 'down';
      case 'down':
        return 'up';
      case 'left':
        return 'right';
      case 'right':
        return 'left';
      case 'up-left':
        return 'down-right';
      case 'up-right':
        return 'down-left';
      case 'down-left':
        return 'up-right';
      case 'down-right':
        return 'up-left';
      default:
        return 'unknown';
    }
  }
}
