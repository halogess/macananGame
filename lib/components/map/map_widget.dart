import 'package:flutter/material.dart';
import 'package:macanan_game/components/map/map.dart';
import 'package:macanan_game/components/map/node.dart';

class MapWidget extends StatefulWidget {
  final MapData mapData;
  final String currentNodeId;
  final Function(MapNode) onNodeTap;
  // final List<String> highlightedNeighborIds;

  const MapWidget({
    super.key,
    required this.mapData,
    required this.currentNodeId,
    required this.onNodeTap,
    // this.highlightedNeighborIds = const [],
  });

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 5.0,
            ),
          ),
          child: CustomPaint(
            painter: MapPainter(
              nodes: widget.mapData.nodes,
              currentNodeId: widget.currentNodeId,
            ),
            child: _buildNodeButtons(),
          ),
        );
      },
    );
  }

  Widget _buildNodeButtons() {
    return Stack(
      children: widget.mapData.nodes.map((node) {
        return Positioned(
          left: node.position.dx - 25,
          top: node.position.dy - 25,
          child: GestureDetector(
            onTap: node.isAccessible
                ? () {
                    widget.onNodeTap(node);
                  }
                : null,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getNodeColor(node),
                border: Border.all(
                  color: _getNodeBorderColor(node),
                  width: 2,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getNodeColor(MapNode node) {
    if (node.id == widget.currentNodeId) return Colors.green;
    if (node.isAccessible) return Colors.white;
    return Colors.black;
  }

  Color _getNodeBorderColor(MapNode node) {
    return node.isAccessible ? Colors.blue : Colors.black;
  }
}

class MapPainter extends CustomPainter {
  final List<MapNode> nodes;
  final String currentNodeId;

  MapPainter({
    required this.nodes,
    required this.currentNodeId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw connections between nodes
    for (var node in nodes) {
      // String note = 'row : ${node.row} col :  ${node.col} conn : ${node.connections.length}';
      // print(note);
      for (var connection in node.connections) {
        final connectedNode = nodes.firstWhere((n) => n.id == connection.targetNodeId);
        canvas.drawLine(
          Offset(node.position.dx, node.position.dy),
          Offset(connectedNode.position.dx, connectedNode.position.dy),
          paint,
        );

        // print('${connection.direction} - row : ${connectedNode.row} col : ${connectedNode.col}');
      }
      // print('');
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}