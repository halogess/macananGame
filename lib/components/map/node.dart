import 'package:flutter/material.dart';
class MapNode {
  final String id;
  final Offset position;
  final List<MapConnection> connections;
  final bool isAccessible;
  final bool isCompleted;
  final int row;
  final int col;

  MapNode({
    required this.id,
    required this.position,
    List<MapConnection>? connections,
    this.isAccessible = true,
    this.isCompleted = false,
    required this.col,
    required this.row,
  }) : connections = connections ?? [];

  // Create a copy of the node with optional parameter overrides
  MapNode copyWith({
    String? id,
    Offset? position,
    List<MapConnection>? connections,
    bool? isAccessible,
    bool? isCompleted,
    int? col,
    int? row,
  }) {
    return MapNode(
      id: id ?? this.id,
      position: position ?? this.position,
      connections: connections ?? this.connections,
      isAccessible: isAccessible ?? this.isAccessible,
      isCompleted: isCompleted ?? this.isCompleted,
      row: row ?? this.row,
      col: col ?? this.col,
    );
  }

  // Add a method to add a connection
  MapNode addConnection(MapConnection newConnection) {
    // Check if the connection already exists
    final connectionExists = connections.any(
      (existingConnection) => 
        existingConnection.targetNodeId == newConnection.targetNodeId && 
        existingConnection.direction == newConnection.direction
    );

    if (!connectionExists) {
      return copyWith(
        connections: [...connections, newConnection]
      );
    }
    return this;
  }

}

class MapConnection {
  final String targetNodeId; 
  final String direction;

  MapConnection({
    required this.targetNodeId,
    required this.direction,
  });

  // Optional: Add equality and hash code for proper comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MapConnection &&
           targetNodeId == other.targetNodeId &&
           direction == other.direction;
  }

  @override
  int get hashCode => targetNodeId.hashCode ^ direction.hashCode;
}