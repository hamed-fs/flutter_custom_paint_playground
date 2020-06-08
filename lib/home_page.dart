import 'package:flutter/material.dart';

import 'package:flutter_custom_paint_playground/node.dart';
import 'package:flutter_custom_paint_playground/graph_custom_paint.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey _paintKey = GlobalKey();
  List<Node> _nodes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Listener(
        onPointerDown: (PointerDownEvent event) async {
          Node node = await _showNodeNameDialog(event);

          if (node != null) {
            setState(() => _nodes.add(node));
          }
        },
        child: CustomPaint(
          key: _paintKey,
          painter: GraphCustomPainter(_nodes),
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showNodeNeighborAlertDialog(context, _nodes),
      ),
    );
  }

  Future<Node> _showNodeNameDialog(PointerDownEvent event) async {
    final RenderBox referenceBox = _paintKey.currentContext.findRenderObject();
    final Offset offset = referenceBox.globalToLocal(event.position);

    final String name = await showNodeNameAlertDialog(context);

    return name == null || name.isEmpty
        ? null
        : Node(name: name, position: offset);
  }

  Future<String> showNodeNameAlertDialog(BuildContext context) async {
    final textEditingController = TextEditingController();

    final AlertDialog alert = AlertDialog(
      title: Text(
        "Node Name:",
        style: TextStyle(fontSize: 16.0),
      ),
      content: TextField(
        controller: textEditingController,
      ),
      actions: [
        FlatButton(
          child: Text("CANCEL"),
          onPressed: () => Navigator.of(context).pop(null),
        ),
        FlatButton(
          child: Text("OK"),
          onPressed: () =>
              Navigator.of(context).pop(textEditingController.text),
        ),
      ],
    );

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<String> showNodeNeighborAlertDialog(
    BuildContext context,
    List<Node> nodes,
  ) async {
    final parentTextEditingController = TextEditingController();
    final childrenTextEditingController = TextEditingController();

    final AlertDialog alert = AlertDialog(
      title: Text(
        "Add Neighbors:",
        style: TextStyle(fontSize: 16.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Parent'),
          TextField(
            controller: parentTextEditingController,
          ),
          SizedBox(height: 32.0),
          Text('Children'),
          TextField(
            controller: childrenTextEditingController,
          ),
        ],
      ),
      actions: [
        FlatButton(
          child: Text("CANCEL"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text("OK"),
          onPressed: () {
            _addChildren(
              parentTextEditingController.text,
              childrenTextEditingController.text,
              nodes,
            );

            Navigator.of(context).pop();
          },
        ),
      ],
    );

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _addChildren(String parentString, String childrenString, List<Node> nodes) {
    if (parentString.isEmpty || childrenString.isEmpty) {
      return;
    }

    final Node parent =
        nodes.firstWhere((Node element) => element.name == parentString);

    final List<Node> children = nodes
        .where(
            (Node element) => childrenString.split(',').contains(element.name))
        .toList();

    if (children != null && children.isNotEmpty) {
      for (Node child in children) {
        if (!parent.neighbors.contains(child)) {
          parent.neighbors.add(child);
        }

        if (!child.neighbors.contains(parent)) {
          child.neighbors.add(parent);
        }
      }
    }
  }
}
